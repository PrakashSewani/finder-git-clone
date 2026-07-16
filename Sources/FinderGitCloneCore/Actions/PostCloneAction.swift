import Foundation

public protocol PostCloneAction: Sendable {
    var name: String { get }
    var description: String { get }
    var priority: Int { get }
    var requiresConfirmation: Bool { get }

    nonisolated func shouldRun(for result: DetectionResult) -> Bool
    @MainActor func execute(for result: DetectionResult) async throws
}
