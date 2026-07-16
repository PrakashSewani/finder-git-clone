import Foundation

@MainActor
public final class ActionRegistry {
    private var actions: [any PostCloneAction] = []

    public init() {
        register(OpenEditorAction())
        register(InstallDependenciesAction())
    }

    public func register(_ action: any PostCloneAction) {
        actions.append(action)
        actions.sort { $0.priority > $1.priority }
    }

    public func actions(for result: DetectionResult) -> [any PostCloneAction] {
        actions.filter { $0.shouldRun(for: result) }
    }

    public func executeActions(for result: DetectionResult) async throws {
        let applicable = actions(for: result)
        for action in applicable {
            try await action.execute(for: result)
        }
    }
}
