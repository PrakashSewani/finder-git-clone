import Foundation
import Observation
import AppKit
import FinderGitCloneCore

@MainActor
@Observable
public final class AppState {
    public enum State: Equatable {
        case idle
        case input(targetPath: String)
        case validating
        case cloning(GitProgress)
        case success(DetectionResult)
        case error(GitError)
    }

    public var state: State = .idle
    public var repositoryURL: String = ""
    public var selectedBranch: String = ""
    public var cloneDepth: Int = 0
    public var installedEditors: [Editor] = []
    public var detectedProject: DetectionResult?
    public var preferences = PreferencesService()

    private let gitService = GitService()
    private let projectDetector = ProjectDetector()
    private let actionRegistry = ActionRegistry()

    public init() {
        Task {
            await loadInstalledEditors()
        }
    }

    public func showCloneDialog(targetPath: String) {
        state = .input(targetPath: targetPath)
        repositoryURL = ""
        selectedBranch = ""
        cloneDepth = 0
    }

    public func cancel() {
        gitService.cancel()
        state = .idle
    }

    public func dismiss() {
        gitService.cancel()
        state = .idle
        repositoryURL = ""
        selectedBranch = ""
        cloneDepth = 0
        detectedProject = nil
    }

    public func startClone() async {
        let targetPath: String
        if case .input(let path) = state {
            targetPath = path
        } else {
            return
        }

        let gitURL = GitURL(string: repositoryURL)
        guard gitURL.isValid else {
            state = .error(gitURL.validationError ?? .invalidURL(repositoryURL))
            return
        }

        state = .validating

        do {
            let destination = URL(fileURLWithPath: targetPath)
            let clonedURL = try await gitService.clone(from: gitURL, to: destination) { [weak self] progress in
                Task { @MainActor in
                    self?.state = .cloning(progress)
                }
            }

            let result = projectDetector.detectProjectWithDetails(in: clonedURL)
            detectedProject = result
            state = .success(result)

            if preferences.autoOpenInEditor {
                try await actionRegistry.executeActions(for: result)
            }
        } catch let error as GitError {
            if error == .cancelled {
                state = .input(targetPath: targetPath)
            } else {
                state = .error(error)
            }
        } catch {
            state = .error(.unknown(error.localizedDescription))
        }
    }

    public func retry() {
        if case .input(let path) = state {
            state = .input(targetPath: path)
        } else if case .error = state {
            let targetPath: String
            if case .input(let path) = state {
                targetPath = path
            } else {
                targetPath = FileManager.default.homeDirectoryForCurrentUser.appendingPathComponent("Downloads").path
            }
            state = .input(targetPath: targetPath)
        }
    }

    public func openInFinder(_ url: URL) {
        NSWorkspace.shared.selectFile(nil, inFileViewerRootedAtPath: url.path)
    }

    private func loadInstalledEditors() async {
        installedEditors = EditorDetector().detectInstalledEditors()
    }
}
