import Foundation

public struct ProjectDetector: Sendable {
    private let detectors: [Sendable] = [
        XcodeDetector(),
        VSCodeDetector(),
        CursorDetector(),
        IntelliJDetector(),
        BuildSystemDetector()
    ]

    public init() {}

    public func detectProject(in directory: URL) -> ProjectType {
        for detector in detectors {
            if let result = detectWithDetector(detector, in: directory) {
                return result
            }
        }
        return .genericFolder
    }

    public func detectProjectWithDetails(in directory: URL) -> DetectionResult {
        let projectType = detectProject(in: directory)
        let features = detectFeatures(in: directory)
        return DetectionResult(type: projectType, features: features, directory: directory)
    }

    private func detectWithDetector(_ detector: Sendable, in directory: URL) -> ProjectType? {
        switch detector {
        case let d as XcodeDetector:
            return d.detect(in: directory)
        case let d as VSCodeDetector:
            return d.detect(in: directory)
        case let d as CursorDetector:
            return d.detect(in: directory)
        case let d as IntelliJDetector:
            return d.detect(in: directory)
        case let d as BuildSystemDetector:
            return d.detect(in: directory)
        default:
            return nil
        }
    }

    private func detectFeatures(in directory: URL) -> [ProjectFeature] {
        var features: [ProjectFeature] = []
        let fm = FileManager.default

        if fm.fileExists(atPath: directory.appendingPathComponent("Dockerfile").path) ||
           fm.fileExists(atPath: directory.appendingPathComponent("docker-compose.yml").path) ||
           fm.fileExists(atPath: directory.appendingPathComponent("docker-compose.yaml").path) {
            features.append(.docker)
        }

        if fm.fileExists(atPath: directory.appendingPathComponent(".devcontainer").path) {
            features.append(.devContainer)
        }

        if fm.fileExists(atPath: directory.appendingPathComponent(".gitignore").path) {
            features.append(.gitInitialized)
        }

        if fm.fileExists(atPath: directory.appendingPathComponent("README.md").path) ||
           fm.fileExists(atPath: directory.appendingPathComponent("README.rst").path) {
            features.append(.hasREADME)
        }

        if fm.fileExists(atPath: directory.appendingPathComponent("Makefile").path) {
            features.append(.hasMakefile)
        }

        if fm.fileExists(atPath: directory.appendingPathComponent(".env.example").path) ||
           fm.fileExists(atPath: directory.appendingPathComponent(".env.sample").path) {
            features.append(.hasEnvTemplate)
        }

        if fm.fileExists(atPath: directory.appendingPathComponent("LICENSE").path) ||
           fm.fileExists(atPath: directory.appendingPathComponent("LICENSE.md").path) ||
           fm.fileExists(atPath: directory.appendingPathComponent("LICENSE.txt").path) {
            features.append(.hasLicense)
        }

        return features
    }
}

public struct DetectionResult: Sendable, Equatable {
    public let type: ProjectType
    public let features: [ProjectFeature]
    public let directory: URL

    public var summary: String {
        var parts = [type.displayName]
        if !features.isEmpty {
            let featureNames = features.map(\.displayName).joined(separator: ", ")
            parts.append("Features: \(featureNames)")
        }
        return parts.joined(separator: " — ")
    }
}

public enum ProjectFeature: Sendable, Hashable {
    case docker
    case devContainer
    case gitInitialized
    case hasREADME
    case hasMakefile
    case hasEnvTemplate
    case hasLicense

    public var displayName: String {
        switch self {
        case .docker: return "Docker"
        case .devContainer: return "Dev Container"
        case .gitInitialized: return "Git"
        case .hasREADME: return "README"
        case .hasMakefile: return "Makefile"
        case .hasEnvTemplate: return ".env template"
        case .hasLicense: return "License"
        }
    }
}
