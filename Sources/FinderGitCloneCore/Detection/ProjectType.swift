import Foundation

public enum ProjectType: Sendable, Equatable, CaseIterable {
    case xcodeWorkspace
    case xcodeProject
    case vscodeWorkspace
    case vscodeProject
    case cursorWorkspace
    case intellijProject
    case androidStudioProject
    case rustProject
    case nodeProject
    case dotnetProject
    case pythonProject
    case swiftProject
    case genericFolder

    public var displayName: String {
        switch self {
        case .xcodeWorkspace: return "Xcode Workspace"
        case .xcodeProject: return "Xcode Project"
        case .vscodeWorkspace: return "VS Code Workspace"
        case .vscodeProject: return "VS Code Project"
        case .cursorWorkspace: return "Cursor Project"
        case .intellijProject: return "IntelliJ Project"
        case .androidStudioProject: return "Android Studio Project"
        case .rustProject: return "Rust Project"
        case .nodeProject: return "Node.js Project"
        case .dotnetProject: return ".NET Project"
        case .pythonProject: return "Python Project"
        case .swiftProject: return "Swift Project"
        case .genericFolder: return "Folder"
        }
    }

    public var sfSymbol: String {
        switch self {
        case .xcodeWorkspace, .xcodeProject: return "hammer.fill"
        case .vscodeWorkspace, .vscodeProject: return "chevron.left.forwardslash.chevron.right"
        case .cursorWorkspace: return "cursorarrow.click.2"
        case .intellijProject: return "wrench.and.screwdriver"
        case .androidStudioProject: return "phone"
        case .rustProject: return "gearshape.fill"
        case .nodeProject: return "hexagon.fill"
        case .dotnetProject: return "leaf.fill"
        case .pythonProject: return "ant.fill"
        case .swiftProject: return "bird.fill"
        case .genericFolder: return "folder.fill"
        }
    }

    public var priority: Int {
        switch self {
        case .xcodeWorkspace: return 100
        case .xcodeProject: return 90
        case .vscodeWorkspace: return 80
        case .cursorWorkspace: return 75
        case .vscodeProject: return 70
        case .intellijProject: return 60
        case .androidStudioProject: return 55
        case .rustProject: return 50
        case .nodeProject: return 45
        case .dotnetProject: return 40
        case .pythonProject: return 35
        case .swiftProject: return 30
        case .genericFolder: return 0
        }
    }
}
