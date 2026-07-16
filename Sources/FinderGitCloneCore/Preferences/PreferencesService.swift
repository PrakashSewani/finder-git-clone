import Foundation

@MainActor
public final class PreferencesService {
    private let defaults: UserDefaults

    public init(defaults: UserDefaults? = nil) {
        self.defaults = defaults ?? UserDefaults.standard
    }

    public var preferredEditor: Editor? {
        get {
            guard let raw = defaults.string(forKey: SharedConfig.Keys.preferredEditor),
                  let editor = Editor(rawValue: raw) else {
                return nil
            }
            return editor
        }
        set {
            defaults.set(newValue?.rawValue, forKey: SharedConfig.Keys.preferredEditor)
        }
    }

    public var autoOpenInEditor: Bool {
        get { defaults.bool(forKey: SharedConfig.Keys.autoOpenInEditor) }
        set { defaults.set(newValue, forKey: SharedConfig.Keys.autoOpenInEditor) }
    }

    public var installDependencies: Bool {
        get { defaults.bool(forKey: SharedConfig.Keys.installDependencies) }
        set { defaults.set(newValue, forKey: SharedConfig.Keys.installDependencies) }
    }

    public var defaultCloneDirectory: URL? {
        get {
            guard let path = defaults.string(forKey: SharedConfig.Keys.defaultCloneDirectory) else {
                return nil
            }
            return URL(fileURLWithPath: path)
        }
        set {
            defaults.set(newValue?.path, forKey: SharedConfig.Keys.defaultCloneDirectory)
        }
    }

    public var hasCompletedOnboarding: Bool {
        get { defaults.bool(forKey: SharedConfig.Keys.hasCompletedOnboarding) }
        set { defaults.set(newValue, forKey: SharedConfig.Keys.hasCompletedOnboarding) }
    }
}
