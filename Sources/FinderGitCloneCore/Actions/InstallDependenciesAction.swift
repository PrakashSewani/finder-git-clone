import Foundation

@MainActor
public struct InstallDependenciesAction: PostCloneAction {
    public let name = "Install Dependencies"
    public let description = "Automatically installs project dependencies"
    public let priority = 50
    public let requiresConfirmation = true

    public init() {}

    public nonisolated func shouldRun(for result: DetectionResult) -> Bool {
        switch result.type {
        case .nodeProject, .rustProject, .pythonProject, .swiftProject:
            return true
        default:
            return false
        }
    }

    public func execute(for result: DetectionResult) async throws {
        let fm = FileManager.default
        let dir = result.directory

        switch result.type {
        case .nodeProject:
            if fm.fileExists(atPath: dir.appendingPathComponent("yarn.lock").path) {
                try await runCommand("yarn", arguments: ["install"], in: dir)
            } else if fm.fileExists(atPath: dir.appendingPathComponent("pnpm-lock.yaml").path) {
                try await runCommand("pnpm", arguments: ["install"], in: dir)
            } else {
                try await runCommand("npm", arguments: ["install"], in: dir)
            }
        case .rustProject:
            try await runCommand("cargo", arguments: ["fetch"], in: dir)
        case .pythonProject:
            if fm.fileExists(atPath: dir.appendingPathComponent("pyproject.toml").path) {
                try await runCommand("pip", arguments: ["install", "-e", "."], in: dir)
            } else if fm.fileExists(atPath: dir.appendingPathComponent("requirements.txt").path) {
                try await runCommand("pip", arguments: ["install", "-r", "requirements.txt"], in: dir)
            }
        case .swiftProject:
            if fm.fileExists(atPath: dir.appendingPathComponent("Package.swift").path) {
                try await runCommand("swift", arguments: ["package", "resolve"], in: dir)
            }
        default:
            break
        }
    }

    private func runCommand(_ command: String, arguments: [String], in directory: URL) async throws {
        let process = Process()
        process.executableURL = URL(fileURLWithPath: "/usr/bin/env")
        process.arguments = [command] + arguments
        process.currentDirectoryURL = directory
        process.standardOutput = FileHandle.nullDevice
        process.standardError = FileHandle.nullDevice

        try process.run()
        process.waitUntilExit()

        if process.terminationStatus != 0 {
            throw ActionError.commandFailed(command, process.terminationStatus)
        }
    }
}

public enum ActionError: LocalizedError {
    case commandFailed(String, Int32)

    public var errorDescription: String? {
        switch self {
        case .commandFailed(let cmd, let code):
            return "\(cmd) failed with exit code \(code)"
        }
    }
}
