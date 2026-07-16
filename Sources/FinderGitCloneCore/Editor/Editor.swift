import Foundation
import AppKit

public enum Editor: String, Sendable, CaseIterable, Identifiable {
    case vscode = "com.microsoft.VSCode"
    case cursor = "com.todesktop.230313mzl4w4u92"
    case xcode = "com.apple.dt.Xcode"
    case intellij = "com.jetbrains.intellij"
    case androidStudio = "com.google.android.studio"
    case sublimeText = "com.sublimetext.4"
    case vim = "com.apple.Terminal"
    case nova = "com.panic.Nova"
    case fleet = "com.jetbrains.Fleet"

    public var id: String { rawValue }

    public var displayName: String {
        switch self {
        case .vscode: return "VS Code"
        case .cursor: return "Cursor"
        case .xcode: return "Xcode"
        case .intellij: return "IntelliJ IDEA"
        case .androidStudio: return "Android Studio"
        case .sublimeText: return "Sublime Text"
        case .vim: return "Terminal (vim)"
        case .nova: return "Nova"
        case .fleet: return "Fleet"
        }
    }

    public var sfSymbol: String {
        switch self {
        case .vscode: return "chevron.left.forwardslash.chevron.right"
        case .cursor: return "cursorarrow.click.2"
        case .xcode: return "hammer.fill"
        case .intellij: return "wrench.and.screwdriver"
        case .androidStudio: return "phone"
        case .sublimeText: return "doc.text"
        case .vim: return "terminal"
        case .nova: return "diamond"
        case .fleet: return "bolt.fill"
        }
    }

    public var bundleIdentifier: String {
        rawValue
    }

    public var cliCommand: String? {
        switch self {
        case .vscode: return "code"
        case .cursor: return "cursor"
        case .xcode: return "xed"
        case .intellij: return "idea"
        case .androidStudio: return "studio"
        case .sublimeText: return "subl"
        case .vim: return "vim"
        case .nova: return "nova"
        case .fleet: return "fleet"
        }
    }

    public func applicationURL() -> URL? {
        let fm = FileManager.default
        let appNames = applicationNames()

        let searchPaths = [
            "/Applications",
            NSHomeDirectory() + "/Applications"
        ]

        for searchPath in searchPaths {
            for appName in appNames {
                let appPath = "\(searchPath)/\(appName)"
                if fm.fileExists(atPath: appPath) {
                    return URL(fileURLWithPath: appPath)
                }
            }
        }

        return nil
    }

    private func applicationNames() -> [String] {
        switch self {
        case .vscode: return ["Visual Studio Code.app", "VSCode.app"]
        case .cursor: return ["Cursor.app"]
        case .xcode: return ["Xcode.app"]
        case .intellij: return ["IntelliJ IDEA.app", "IntelliJ IDEA CE.app"]
        case .androidStudio: return ["Android Studio.app"]
        case .sublimeText: return ["Sublime Text.app"]
        case .vim: return ["Terminal.app"]
        case .nova: return ["Nova.app"]
        case .fleet: return ["Fleet.app"]
        }
    }

    public func isInstalled() -> Bool {
        applicationURL() != nil
    }

    public func open(_ directory: URL) throws {
        let fm = FileManager.default

        if let cli = cliCommand, isCLIInPath(cli) {
            try openWithCLI(cli, directory: directory)
            return
        }

        guard let appURL = applicationURL() else {
            throw EditorError.notInstalled(displayName)
        }

        let configuration = NSWorkspace.OpenConfiguration()
        configuration.arguments = [directory.path]

        let workspace = NSWorkspace.shared
        workspace.openApplication(
            at: appURL,
            configuration: configuration
        )
    }

    private func openWithCLI(_ command: String, directory: URL) throws {
        let process = Process()
        process.executableURL = URL(fileURLWithPath: "/usr/bin/env")
        process.arguments = [command, directory.path]
        process.standardOutput = FileHandle.nullDevice
        process.standardError = Pipe()

        do {
            try process.run()
            process.waitUntilExit()
            if process.terminationStatus != 0 {
                throw EditorError.launchFailed(displayName)
            }
        } catch {
            throw EditorError.launchFailed(displayName)
        }
    }

    private func isCLIInPath(_ command: String) -> Bool {
        let process = Process()
        process.executableURL = URL(fileURLWithPath: "/usr/bin/which")
        process.arguments = [command]

        let pipe = Pipe()
        process.standardOutput = pipe
        process.standardError = FileHandle.nullDevice

        do {
            try process.run()
            process.waitUntilExit()
            let data = pipe.fileHandleForReading.readDataToEndOfFile()
            let path = String(data: data, encoding: .utf8)?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
            return !path.isEmpty && process.terminationStatus == 0
        } catch {
            return false
        }
    }
}

public enum EditorError: LocalizedError {
    case notInstalled(String)
    case launchFailed(String)

    public var errorDescription: String? {
        switch self {
        case .notInstalled(let name):
            return "\(name) is not installed on this system."
        case .launchFailed(let name):
            return "Failed to launch \(name)."
        }
    }
}
