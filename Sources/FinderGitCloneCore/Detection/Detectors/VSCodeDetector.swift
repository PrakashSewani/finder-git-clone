import Foundation

struct VSCodeDetector: Sendable {
    func detect(in directory: URL) -> ProjectType? {
        let fm = FileManager.default

        if fm.fileExists(atPath: directory.appendingPathComponent(".vscode").path) {
            return .vscodeProject
        }

        if let contents = try? fm.contentsOfDirectory(atPath: directory.path) {
            for item in contents {
                if item.hasSuffix(".code-workspace") {
                    return .vscodeWorkspace
                }
            }
        }

        return nil
    }
}
