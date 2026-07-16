import Foundation

public struct GitProgress: Sendable, Equatable {
    public let phase: Phase
    public let percentage: Double?
    public let objectCount: String?
    public let totalObjects: String?

    public var displayText: String {
        switch phase {
        case .counting:
            return "Counting objects..."
        case .compressing:
            return "Compressing objects..."
        case .receiving:
            if let percentage = percentage {
                return "Receiving objects... \(Int(percentage))%"
            }
            return "Receiving objects..."
        case .resolving:
            return "Resolving deltas..."
        case .cloning:
            return "Cloning..."
        case .done:
            return "Done"
        case .error:
            return "Error"
        }
    }

    public var progressValue: Double {
        percentage.map { $0 / 100.0 } ?? 0.0
    }

    public enum Phase: String, Sendable {
        case counting
        case compressing
        case receiving
        case resolving
        case cloning
        case done
        case error

        public var order: Int {
            switch self {
            case .counting: return 0
            case .compressing: return 1
            case .receiving: return 2
            case .resolving: return 3
            case .cloning: return 4
            case .done: return 5
            case .error: return -1
            }
        }
    }

    public init(phase: Phase, percentage: Double? = nil, objectCount: String? = nil, totalObjects: String? = nil) {
        self.phase = phase
        self.percentage = percentage
        self.objectCount = objectCount
        self.totalObjects = totalObjects
    }

    public static func parse(line: String) -> GitProgress? {
        if line.contains("Counting objects:") {
            let percentage = extractPercentage(from: line)
            return GitProgress(phase: .counting, percentage: percentage)
        } else if line.contains("Compressing objects:") {
            let percentage = extractPercentage(from: line)
            return GitProgress(phase: .compressing, percentage: percentage)
        } else if line.contains("Receiving objects:") {
            let percentage = extractPercentage(from: line)
            let counts = extractObjectCounts(from: line)
            return GitProgress(phase: .receiving, percentage: percentage, objectCount: counts.0, totalObjects: counts.1)
        } else if line.contains("Resolving deltas:") {
            let percentage = extractPercentage(from: line)
            return GitProgress(phase: .resolving, percentage: percentage)
        } else if line.isEmpty {
            return nil
        } else {
            return nil
        }
    }

    private static func extractPercentage(from line: String) -> Double? {
        guard let range = line.range(of: #"(\d+)%"#, options: .regularExpression) else { return nil }
        let number = String(line[range]).replacingOccurrences(of: "%", with: "")
        return Double(number)
    }

    private static func extractObjectCounts(from line: String) -> (String?, String?) {
        guard let range = line.range(of: #"\d+/\d+"#, options: .regularExpression) else { return (nil, nil) }
        let counts = String(line[range])
        let parts = counts.split(separator: "/")
        return (parts.first.map(String.init), parts.dropFirst().first.map(String.init))
    }
}
