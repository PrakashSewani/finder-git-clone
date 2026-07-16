import Foundation

public struct GitURL: Equatable, Sendable {
    public let original: String
    public let url: URL?
    public let scheme: GitProtocol
    public let host: String?
    public let path: String
    public let isSSH: Bool

    public var repositoryName: String {
        let lastComponent = (url?.lastPathComponent ?? path) as String
        return lastComponent
            .replacingOccurrences(of: ".git", with: "")
            .split(separator: "/")
            .last.map(String.init) ?? lastComponent
    }

    public var displayName: String {
        if let host = host {
            return "\(host)/\(repositoryName)"
        }
        return repositoryName
    }

    public var normalizedHTTPS: String? {
        guard scheme == .https || scheme == .git else { return nil }
        return url?.absoluteString
    }

    public var sshURL: String? {
        guard let host = host else { return nil }
        let sshPath = path
            .replacingOccurrences(of: ".git", with: "")
            .replacingOccurrences(of: "/", with: ":")
            .trimmingCharacters(in: CharacterSet(charactersIn: ":"))
        return "git@\(host):\(sshPath).git"
    }

    public init(string: String) {
        self.original = string.trimmingCharacters(in: .whitespacesAndNewlines)

        if original.hasPrefix("git@") {
            self.isSSH = true
            let parts = original
                .replacingOccurrences(of: "git@", with: "")
                .split(separator: ":", maxSplits: 1)
            self.host = parts.first.map(String.init)
            self.path = parts.dropFirst().first.map(String.init) ?? ""
            self.scheme = .ssh
            self.url = nil
        } else if original.hasPrefix("ssh://") {
            self.isSSH = true
            if let parsedURL = URL(string: original) {
                self.host = parsedURL.host
                self.path = parsedURL.path
                self.url = parsedURL
            } else {
                self.host = nil
                self.path = original
                self.url = nil
            }
            self.scheme = .ssh
        } else if original.hasPrefix("/") || original.hasPrefix("~") || original.hasPrefix("./") || original.hasPrefix("../") {
            self.isSSH = false
            self.host = nil
            self.path = original
            self.scheme = .file
            self.url = URL(fileURLWithPath: NSString(string: original).expandingTildeInPath)
        } else {
            self.isSSH = false
            self.url = URL(string: original)
            self.host = self.url?.host
            self.path = self.url?.path ?? original

            switch self.url?.scheme {
            case "https":
                self.scheme = .https
            case "http":
                self.scheme = .http
            case "git":
                self.scheme = .git
            case "ssh":
                self.scheme = .ssh
            case "file":
                self.scheme = .file
            default:
                self.scheme = .unknown
            }
        }
    }

    public var isValid: Bool {
        switch scheme {
        case .https, .http, .git, .ssh:
            return host != nil && !path.isEmpty && path != "/"
        case .file:
            return !path.isEmpty
        case .unknown:
            return false
        }
    }

    public var validationError: GitError? {
        guard !isValid else { return nil }
        return .invalidURL(original)
    }
}

public enum GitProtocol: String, Sendable, CaseIterable {
    case https = "https"
    case http = "http"
    case ssh = "ssh"
    case git = "git"
    case file = "file"
    case unknown

    public var displayName: String {
        switch self {
        case .https: return "HTTPS"
        case .http: return "HTTP"
        case .ssh: return "SSH"
        case .git: return "Git"
        case .file: return "Local"
        case .unknown: return "Unknown"
        }
    }
}
