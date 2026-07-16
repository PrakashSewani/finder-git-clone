import Foundation

struct CursorDetector: Sendable {
    func detect(in directory: URL) -> ProjectType? {
        let fm = FileManager.default

        if fm.fileExists(atPath: directory.appendingPathComponent(".cursor").path) {
            return .cursorWorkspace
        }

        if let contents = try? fm.contentsOfDirectory(atPath: directory.path) {
            for item in contents {
                if item.hasSuffix(".cursor-workspace") {
                    return .cursorWorkspace
                }
            }
        }

        return nil
    }
}
