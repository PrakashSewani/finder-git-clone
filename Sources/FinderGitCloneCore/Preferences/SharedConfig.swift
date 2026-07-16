import Foundation

public enum SharedConfig {
    public static let appGroupIdentifier = "group.com.findergitclone.app"

    public static var sharedDefaults: UserDefaults? {
        UserDefaults(suiteName: appGroupIdentifier)
    }

    public enum Keys {
        public static let preferredEditor = "preferredEditor"
        public static let autoOpenInEditor = "autoOpenInEditor"
        public static let installDependencies = "installDependencies"
        public static let cloneDepth = "cloneDepth"
        public static let defaultCloneDirectory = "defaultCloneDirectory"
        public static let hasCompletedOnboarding = "hasCompletedOnboarding"
    }
}
