import Foundation
import AppKit

public struct EditorDetector: Sendable {
    public init() {}

    public func detectInstalledEditors() -> [Editor] {
        Editor.allCases.filter { $0.isInstalled() }
    }

    public func findBestEditor(for projectType: ProjectType, preferred: [Editor]? = nil) -> Editor? {
        let installed = detectInstalledEditors()
        guard !installed.isEmpty else { return nil }

        if let preferred = preferred {
            for editor in preferred {
                if installed.contains(editor) && isEditorCompatible(editor, with: projectType) {
                    return editor
                }
            }
            for editor in preferred {
                if installed.contains(editor) {
                    return editor
                }
            }
        }

        let fallbackOrder = defaultEditorOrder(for: projectType)
        for editor in fallbackOrder {
            if installed.contains(editor) {
                return editor
            }
        }

        return installed.first
    }

    private func isEditorCompatible(_ editor: Editor, with projectType: ProjectType) -> Bool {
        switch projectType {
        case .xcodeWorkspace, .xcodeProject:
            return editor == .xcode || editor == .vscode || editor == .cursor
        case .vscodeWorkspace, .vscodeProject:
            return editor == .vscode || editor == .cursor
        case .cursorWorkspace:
            return editor == .cursor || editor == .vscode
        case .androidStudioProject:
            return editor == .androidStudio || editor == .intellij || editor == .vscode
        case .intellijProject:
            return editor == .intellij || editor == .androidStudio || editor == .vscode
        case .rustProject, .nodeProject, .pythonProject, .swiftProject:
            return true
        case .dotnetProject:
            return editor == .vscode || editor == .cursor || editor == .intellij
        case .genericFolder:
            return true
        }
    }

    private func defaultEditorOrder(for projectType: ProjectType) -> [Editor] {
        switch projectType {
        case .xcodeWorkspace, .xcodeProject:
            return [.xcode, .vscode, .cursor, .intellij, .fleet]
        case .vscodeWorkspace, .vscodeProject:
            return [.vscode, .cursor, .intellij, .fleet]
        case .cursorWorkspace:
            return [.cursor, .vscode, .intellij, .fleet]
        case .androidStudioProject:
            return [.androidStudio, .intellij, .vscode, .cursor]
        case .intellijProject:
            return [.intellij, .androidStudio, .vscode, .cursor, .fleet]
        case .rustProject:
            return [.vscode, .cursor, .intellij, .fleet]
        case .nodeProject:
            return [.vscode, .cursor, .intellij, .fleet]
        case .pythonProject:
            return [.vscode, .cursor, .intellij, .fleet]
        case .swiftProject:
            return [.vscode, .cursor, .xcode, .fleet]
        case .dotnetProject:
            return [.vscode, .cursor, .intellij]
        case .genericFolder:
            return [.vscode, .cursor, .intellij, .fleet, .sublimeText]
        }
    }
}
