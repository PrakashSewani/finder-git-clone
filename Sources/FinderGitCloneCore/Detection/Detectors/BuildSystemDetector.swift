import Foundation

struct BuildSystemDetector: Sendable {
    func detect(in directory: URL) -> ProjectType? {
        let fm = FileManager.default

        if fm.fileExists(atPath: directory.appendingPathComponent("Cargo.toml").path) {
            return .rustProject
        }

        if fm.fileExists(atPath: directory.appendingPathComponent("package.json").path) {
            return .nodeProject
        }

        if let contents = try? fm.contentsOfDirectory(atPath: directory.path) {
            for item in contents {
                if item.hasSuffix(".sln") || item.hasSuffix(".csproj") || item.hasSuffix(".fsproj") {
                    return .dotnetProject
                }
            }
        }

        if fm.fileExists(atPath: directory.appendingPathComponent("Package.swift").path) {
            return .swiftProject
        }

        if fm.fileExists(atPath: directory.appendingPathComponent("setup.py").path) ||
           fm.fileExists(atPath: directory.appendingPathComponent("pyproject.toml").path) ||
           fm.fileExists(atPath: directory.appendingPathComponent("requirements.txt").path) {
            return .pythonProject
        }

        return nil
    }
}
