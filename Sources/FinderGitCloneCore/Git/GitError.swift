import Foundation

public enum GitError: LocalizedError, Equatable {
    case invalidURL(String)
    case authenticationFailed(String)
    case repositoryNotFound(String)
    case networkError(String)
    case diskSpaceError
    case destinationExists(String)
    case cloneFailed(String)
    case gitNotFound
    case cancelled
    case permissionDenied(String)
    case sshError(String)
    case unknown(String)

    public var errorDescription: String? {
        switch self {
        case .invalidURL(let url):
            return "Invalid repository URL: \(url)"
        case .authenticationFailed(let message):
            return "Authentication failed: \(message)"
        case .repositoryNotFound(let url):
            return "Repository not found: \(url)"
        case .networkError(let message):
            return "Network error: \(message)"
        case .diskSpaceError:
            return "Not enough disk space to clone the repository"
        case .destinationExists(let path):
            return "A folder already exists at: \(path)"
        case .cloneFailed(let message):
            return "Clone failed: \(message)"
        case .gitNotFound:
            return "Git is not installed or not found in PATH"
        case .cancelled:
            return "Clone was cancelled"
        case .permissionDenied(let message):
            return "Permission denied: \(message)"
        case .sshError(let message):
            return "SSH error: \(message)"
        case .unknown(let message):
            return message
        }
    }

    public var recoverySuggestion: String? {
        switch self {
        case .invalidURL:
            return "Please enter a valid Git repository URL (HTTPS, SSH, or git://)."
        case .authenticationFailed:
            return "Check your credentials or SSH key configuration."
        case .repositoryNotFound:
            return "Verify the repository URL is correct and the repository exists."
        case .networkError:
            return "Check your internet connection and try again."
        case .diskSpaceError:
            return "Free up disk space and try again."
        case .destinationExists:
            return "A folder with this name already exists. The clone will use a unique name."
        case .gitNotFound:
            return "Install Git: xcode-select --install"
        case .cancelled:
            return nil
        case .permissionDenied:
            return "Check file permissions for the destination directory."
        case .sshError:
            return "Verify your SSH key is configured and added to the SSH agent."
        case .cloneFailed, .unknown:
            return "Try cloning manually in Terminal to diagnose the issue."
        }
    }
}
