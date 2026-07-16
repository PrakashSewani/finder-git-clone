import Foundation
import AppKit

@MainActor
public struct OpenEditorAction: PostCloneAction {
    public let name = "Open in Editor"
    public let description = "Opens the cloned project in the detected editor"
    public let priority = 100
    public let requiresConfirmation = false
    private let preferredEditor: Editor?

    public init(preferredEditor: Editor? = nil) {
        self.preferredEditor = preferredEditor
    }

    public nonisolated func shouldRun(for result: DetectionResult) -> Bool {
        true
    }

    public func execute(for result: DetectionResult) async throws {
        let service = EditorService()
        try service.openProject(
            at: result.directory,
            projectType: result.type,
            preferredEditor: preferredEditor
        )
    }
}
