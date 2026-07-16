import Foundation
import os.log

@MainActor
public final class GitService: @unchecked Sendable {
    private let logger = Logger(subsystem: "com.findergitclone.app", category: "GitService")
    private var currentProcess: Process?

    public init() {}

    public func clone(
        from gitURL: GitURL,
        to destination: URL,
        branch: String? = nil,
        depth: Int? = nil,
        onProgress: @escaping @MainActor @Sendable (GitProgress) -> Void
    ) async throws -> URL {
        let repoName = gitURL.repositoryName
        let cloneDestination = uniqueDestination(for: destination, repoName: repoName)

        try ensureGitAvailable()
        try ensureDirectoryExists(at: cloneDestination.deletingLastPathComponent())

        let process = Process()
        self.currentProcess = process

        let pipe = Pipe()
        let errorPipe = Pipe()

        process.executableURL = URL(fileURLWithPath: "/usr/bin/git")
        process.currentDirectoryURL = cloneDestination.deletingLastPathComponent()

        var arguments = ["clone", "--progress"]
        if let branch = branch {
            arguments += ["--branch", branch]
        }
        if let depth = depth {
            arguments += ["--depth", "\(depth)"]
        }
        arguments.append(gitURL.original)
        arguments.append(repoName)

        process.arguments = arguments
        process.standardOutput = pipe
        process.standardError = pipe
        process.standardInput = nil

        let fileHandle = pipe.fileHandleForReading
        fileHandle.readabilityHandler = { handle in
            let data = handle.availableData
            guard !data.isEmpty else { return }
            guard let output = String(data: data, encoding: .utf8) else { return }
            let lines = output.components(separatedBy: .newlines)
            for line in lines where !line.isEmpty {
                if let progress = GitProgress.parse(line: line) {
                    Task { @MainActor in
                        onProgress(progress)
                    }
                }
            }
        }

        defer {
            fileHandle.readabilityHandler = nil
            self.currentProcess = nil
        }

        do {
            try process.run()
            process.waitUntilExit()

            let exitCode = process.terminationStatus
            if exitCode != 0 {
                let errorData = errorPipe.fileHandleForReading.readDataToEndOfFile()
                let errorOutput = String(data: errorData, encoding: .utf8) ?? "Unknown error"

                throw mapGitError(exitCode: exitCode, output: errorOutput, gitURL: gitURL)
            }

            onProgress(GitProgress(phase: .done, percentage: 100))
            return cloneDestination
        } catch let error as GitError {
            throw error
        } catch {
            throw GitError.cloneFailed(error.localizedDescription)
        }
    }

    public func cancel() {
        if let process = currentProcess, process.isRunning {
            process.terminate()
        }
    }

    public func isGitAvailable() -> Bool {
        let process = Process()
        process.executableURL = URL(fileURLWithPath: "/usr/bin/git")
        process.arguments = ["--version"]
        process.standardOutput = Pipe()
        process.standardError = Pipe()

        do {
            try process.run()
            process.waitUntilExit()
            return process.terminationStatus == 0
        } catch {
            return false
        }
    }

    public func getGitVersion() -> String? {
        let process = Process()
        process.executableURL = URL(fileURLWithPath: "/usr/bin/git")
        process.arguments = ["--version"]

        let pipe = Pipe()
        process.standardOutput = pipe
        process.standardError = FileHandle.nullDevice

        do {
            try process.run()
            process.waitUntilExit()
            let data = pipe.fileHandleForReading.readDataToEndOfFile()
            return String(data: data, encoding: .utf8)?.trimmingCharacters(in: .whitespacesAndNewlines)
        } catch {
            return nil
        }
    }

    private func ensureGitAvailable() throws {
        guard isGitAvailable() else {
            throw GitError.gitNotFound
        }
    }

    private func ensureDirectoryExists(at url: URL) throws {
        let fm = FileManager.default
        if !fm.fileExists(atPath: url.path) {
            try fm.createDirectory(at: url, withIntermediateDirectories: true)
        }
    }

    private func uniqueDestination(for base: URL, repoName: String) -> URL {
        var destination = base.appendingPathComponent(repoName)
        var counter = 1

        while FileManager.default.fileExists(atPath: destination.path) {
            destination = base.appendingPathComponent("\(repoName)-\(counter)")
            counter += 1
        }

        return destination
    }

    private func mapGitError(exitCode: Int32, output: String, gitURL: GitURL) -> GitError {
        let lowercased = output.lowercased()

        if lowercased.contains("authentication") || lowercased.contains("403") || lowercased.contains("could not read username") {
            return .authenticationFailed(output.trimmingCharacters(in: .whitespacesAndNewlines))
        } else if lowercased.contains("repository not found") || lowercased.contains("404") {
            return .repositoryNotFound(gitURL.original)
        } else if lowercased.contains("errno") || lowercased.contains("no space left") {
            return .diskSpaceError
        } else if lowercased.contains("permission denied") || lowercased.contains("eacces") {
            return .permissionDenied(output.trimmingCharacters(in: .whitespacesAndNewlines))
        } else if lowercased.contains("ssh") || lowercased.contains("host key") {
            return .sshError(output.trimmingCharacters(in: .whitespacesAndNewlines))
        } else if lowercased.contains("network") || lowercased.contains("timeout") || lowercased.contains("connection refused") {
            return .networkError(output.trimmingCharacters(in: .whitespacesAndNewlines))
        } else if lowercased.contains("fatal") {
            return .cloneFailed(output.trimmingCharacters(in: .whitespacesAndNewlines))
        } else {
            return .cloneFailed("Git exited with code \(exitCode): \(output.trimmingCharacters(in: .whitespacesAndNewlines))")
        }
    }
}
