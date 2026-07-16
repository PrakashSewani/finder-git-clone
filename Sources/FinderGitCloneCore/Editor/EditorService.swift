import Foundation
import AppKit

@MainActor
public final class EditorService {
    private let detector: EditorDetector

    public init() {
        self.detector = EditorDetector()
    }

    public func installedEditors() -> [Editor] {
        detector.detectInstalledEditors()
    }

    public func openProject(at directory: URL, projectType: ProjectType, preferredEditor: Editor? = nil) throws {
        let editor = detector.findBestEditor(for: projectType, preferred: preferredEditor.map { [$0] })

        guard let editor = editor else {
            openInFinder(directory)
            return
        }

        try editor.open(directory)
    }

    private func openInFinder(_ directory: URL) {
        NSWorkspace.shared.selectFile(nil, inFileViewerRootedAtPath: directory.path)
    }
}
