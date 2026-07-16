import Testing
import Foundation
@testable import FinderGitCloneCore

@Suite("ProjectDetector Tests")
struct ProjectDetectorTests {
    let detector = ProjectDetector()
    let fm = FileManager.default

    func createTempDirectory(named name: String) throws -> URL {
        let tmp = fm.temporaryDirectory.appendingPathComponent("test-\(name)-\(UUID().uuidString)")
        try fm.createDirectory(at: tmp, withIntermediateDirectories: true)
        return tmp
    }

    func cleanup(_ url: URL) {
        try? fm.removeItem(at: url)
    }

    @Test("Detect Xcode Workspace")
    func detectXcodeWorkspace() throws {
        let dir = try createTempDirectory(named: "xcode-workspace")
        defer { cleanup(dir) }

        let workspaceDir = dir.appendingPathComponent("MyApp.xcworkspace")
        try fm.createDirectory(at: workspaceDir, withIntermediateDirectories: true)

        let result = detector.detectProject(in: dir)
        #expect(result == .xcodeWorkspace)
    }

    @Test("Detect Xcode Project")
    func detectXcodeProject() throws {
        let dir = try createTempDirectory(named: "xcode-project")
        defer { cleanup(dir) }

        try fm.createDirectory(at: dir.appendingPathComponent("MyApp.xcodeproj"), withIntermediateDirectories: true)

        let result = detector.detectProject(in: dir)
        #expect(result == .xcodeProject)
    }

    @Test("Detect VS Code workspace")
    func detectVSCodeWorkspace() throws {
        let dir = try createTempDirectory(named: "vscode-workspace")
        defer { cleanup(dir) }

        try "{}".write(to: dir.appendingPathComponent("project.code-workspace"), atomically: true, encoding: .utf8)

        let result = detector.detectProject(in: dir)
        #expect(result == .vscodeWorkspace)
    }

    @Test("Detect VS Code project")
    func detectVSCodeProject() throws {
        let dir = try createTempDirectory(named: "vscode-project")
        defer { cleanup(dir) }

        try fm.createDirectory(at: dir.appendingPathComponent(".vscode"), withIntermediateDirectories: true)

        let result = detector.detectProject(in: dir)
        #expect(result == .vscodeProject)
    }

    @Test("Detect Cursor workspace")
    func detectCursor() throws {
        let dir = try createTempDirectory(named: "cursor")
        defer { cleanup(dir) }

        try fm.createDirectory(at: dir.appendingPathComponent(".cursor"), withIntermediateDirectories: true)

        let result = detector.detectProject(in: dir)
        #expect(result == .cursorWorkspace)
    }

    @Test("Detect Rust project")
    func detectRust() throws {
        let dir = try createTempDirectory(named: "rust")
        defer { cleanup(dir) }

        try "[package]\nname = \"myapp\"".write(to: dir.appendingPathComponent("Cargo.toml"), atomically: true, encoding: .utf8)

        let result = detector.detectProject(in: dir)
        #expect(result == .rustProject)
    }

    @Test("Detect Node.js project")
    func detectNode() throws {
        let dir = try createTempDirectory(named: "node")
        defer { cleanup(dir) }

        try "{}".write(to: dir.appendingPathComponent("package.json"), atomically: true, encoding: .utf8)

        let result = detector.detectProject(in: dir)
        #expect(result == .nodeProject)
    }

    @Test("Detect Swift package")
    func detectSwift() throws {
        let dir = try createTempDirectory(named: "swift")
        defer { cleanup(dir) }

        try "// swift-tools-version: 5.9".write(to: dir.appendingPathComponent("Package.swift"), atomically: true, encoding: .utf8)

        let result = detector.detectProject(in: dir)
        #expect(result == .swiftProject)
    }

    @Test("Detect Python project")
    func detectPython() throws {
        let dir = try createTempDirectory(named: "python")
        defer { cleanup(dir) }

        try "requests==2.28.0".write(to: dir.appendingPathComponent("requirements.txt"), atomically: true, encoding: .utf8)

        let result = detector.detectProject(in: dir)
        #expect(result == .pythonProject)
    }

    @Test("Empty directory is generic folder")
    func emptyDirectory() throws {
        let dir = try createTempDirectory(named: "empty")
        defer { cleanup(dir) }

        let result = detector.detectProject(in: dir)
        #expect(result == .genericFolder)
    }

    @Test("IntelliJ project detection")
    func detectIntelliJ() throws {
        let dir = try createTempDirectory(named: "intellij")
        defer { cleanup(dir) }

        try fm.createDirectory(at: dir.appendingPathComponent(".idea"), withIntermediateDirectories: true)
        try "content".write(to: dir.appendingPathComponent("MyApp.iml"), atomically: true, encoding: .utf8)

        let result = detector.detectProject(in: dir)
        #expect(result == .intellijProject)
    }

    @Test("Android Studio project detection")
    func detectAndroid() throws {
        let dir = try createTempDirectory(named: "android")
        defer { cleanup(dir) }

        try fm.createDirectory(at: dir.appendingPathComponent(".idea"), withIntermediateDirectories: true)
        try "plugins {}".write(to: dir.appendingPathComponent("build.gradle"), atomically: true, encoding: .utf8)

        let result = detector.detectProject(in: dir)
        #expect(result == .androidStudioProject)
    }

    @Test("Features detection - Docker")
    func detectDocker() throws {
        let dir = try createTempDirectory(named: "docker")
        defer { cleanup(dir) }

        try "FROM ubuntu".write(to: dir.appendingPathComponent("Dockerfile"), atomically: true, encoding: .utf8)

        let result = detector.detectProjectWithDetails(in: dir)
        #expect(result.features.contains(.docker))
    }

    @Test("Features detection - README")
    func detectREADME() throws {
        let dir = try createTempDirectory(named: "readme")
        defer { cleanup(dir) }

        try "# My Project".write(to: dir.appendingPathComponent("README.md"), atomically: true, encoding: .utf8)

        let result = detector.detectProjectWithDetails(in: dir)
        #expect(result.features.contains(.hasREADME))
    }

    @Test("Features detection - multiple")
    func detectMultiple() throws {
        let dir = try createTempDirectory(named: "multiple")
        defer { cleanup(dir) }

        try "FROM ubuntu".write(to: dir.appendingPathComponent("Dockerfile"), atomically: true, encoding: .utf8)
        try "# README".write(to: dir.appendingPathComponent("README.md"), atomically: true, encoding: .utf8)
        try "MIT License".write(to: dir.appendingPathComponent("LICENSE"), atomically: true, encoding: .utf8)

        let result = detector.detectProjectWithDetails(in: dir)
        #expect(result.features.contains(.docker))
        #expect(result.features.contains(.hasREADME))
        #expect(result.features.contains(.hasLicense))
    }
}
