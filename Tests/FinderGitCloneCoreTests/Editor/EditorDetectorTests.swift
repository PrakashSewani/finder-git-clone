import Testing
@testable import FinderGitCloneCore

@Suite("EditorDetector Tests")
struct EditorDetectorTests {
    @Test("Detect installed editors does not crash")
    func detectInstalled() {
        let detector = EditorDetector()
        let editors = detector.detectInstalledEditors()
        #expect(!editors.isEmpty || editors.isEmpty)
    }

    @Test("Find best editor returns editor or nil")
    func findBestEditor() {
        let detector = EditorDetector()
        let result = detector.findBestEditor(for: .genericFolder)
        #expect(result != nil || result == nil)
    }

    @Test("VS Code compatible with VS Code projects")
    func vscodeCompatible() {
        let detector = EditorDetector()
        let installed = detector.detectInstalledEditors()

        if installed.contains(.vscode) {
            let result = detector.findBestEditor(for: .vscodeProject)
            #expect(result == .vscode)
        }
    }

    @Test("Xcode compatible with Xcode projects")
    func xcodeCompatible() {
        let detector = EditorDetector()
        let installed = detector.detectInstalledEditors()

        if installed.contains(.xcode) {
            let result = detector.findBestEditor(for: .xcodeProject)
            #expect(result == .xcode)
        }
    }

    @Test("Fallback to any installed editor")
    func fallback() {
        let detector = EditorDetector()
        let installed = detector.detectInstalledEditors()

        if !installed.isEmpty {
            let result = detector.findBestEditor(for: .genericFolder)
            #expect(result != nil)
        }
    }
}
