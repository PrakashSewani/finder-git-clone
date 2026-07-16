import SwiftUI
import FinderGitCloneCore

@main
struct FinderGitCloneApp: App {
    @NSApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    @State private var appState = AppState()

    var body: some Scene {
        WindowGroup {
            ContentView(appState: appState)
                .frame(minWidth: 400, minHeight: 300)
        }
        .defaultSize(width: 420, height: 340)

        Settings {
            PreferencesView(appState: appState)
        }
    }
}
