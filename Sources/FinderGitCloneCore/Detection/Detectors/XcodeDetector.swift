import Foundation

struct XcodeDetector: Sendable {
    func detect(in directory: URL) -> ProjectType? {
        let fm = FileManager.default

        if let contents = try? fm.contentsOfDirectory(atPath: directory.path) {
            for item in contents {
                if item.hasSuffix(".xcworkspace") {
                    return .xcodeWorkspace
                }
            }
            for item in contents {
                if item.hasSuffix(".xcodeproj") {
                    return .xcodeProject
                }
            }
        }

        if directory.pathExtension == "xcworkspace" {
            return .xcodeWorkspace
        }
        if directory.pathExtension == "xcodeproj" {
            return .xcodeProject
        }

        return nil
    }
}
