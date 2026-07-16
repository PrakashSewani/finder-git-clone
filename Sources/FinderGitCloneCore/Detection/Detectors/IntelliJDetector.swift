import Foundation

struct IntelliJDetector: Sendable {
    func detect(in directory: URL) -> ProjectType? {
        let fm = FileManager.default

        if fm.fileExists(atPath: directory.appendingPathComponent(".idea").path) {
            if hasGradleFiles(in: directory, fm: fm) {
                return .androidStudioProject
            }
            return .intellijProject
        }

        if let contents = try? fm.contentsOfDirectory(atPath: directory.path) {
            for item in contents {
                if item.hasSuffix(".iml") {
                    return .intellijProject
                }
            }
        }

        return nil
    }

    private func hasGradleFiles(in directory: URL, fm: FileManager) -> Bool {
        let gradleFiles = ["build.gradle", "build.gradle.kts", "settings.gradle", "settings.gradle.kts"]
        for file in gradleFiles {
            if fm.fileExists(atPath: directory.appendingPathComponent(file).path) {
                return true
            }
        }
        return false
    }
}
