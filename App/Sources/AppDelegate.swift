import Foundation
import AppKit
import SwiftUI
import FinderGitCloneCore

@MainActor
final class AppDelegate: NSObject, NSApplicationDelegate {
    var appState: AppState?
    var cloneWindow: NSWindow?

    func applicationDidFinishLaunching(_ notification: Notification) {
        setupURLHandler()
    }

    func application(_ application: NSApplication, open urls: [URL]) {
        for url in urls {
            handleURL(url)
        }
    }

    func applicationShouldTerminateAfterLastWindowClosed(_ sender: NSApplication) -> Bool {
        false
    }

    func applicationSupportsSecureRestorableState(_ app: NSApplication) -> Bool {
        true
    }

    private func setupURLHandler() {
        NSAppleEventManager.shared().setEventHandler(
            self,
            andSelector: #selector(handleURLEvent(_:withEvent:)),
            forEventClass: AEEventClass(kInternetEventClass),
            andEventID: AEEventID(kAEGetURL)
        )
    }

    @objc private func handleURLEvent(_ event: NSAppleEventDescriptor, withEvent reply: NSAppleEventDescriptor) {
        guard let urlString = event.paramDescriptor(forKeyword: keyDirectObject)?.stringValue,
              let url = URL(string: urlString) else { return }
        handleURL(url)
    }

    private func handleURL(_ url: URL) {
        guard url.scheme == "findergitclone" else { return }

        guard let components = URLComponents(url: url, resolvingAgainstBaseURL: false),
              let pathItem = components.queryItems?.first(where: { $0.name == "path" }),
              let encodedPath = pathItem.value,
              let path = encodedPath.removingPercentEncoding else { return }

        let targetPath = NSString(string: path).expandingTildeInPath

        showCloneWindow(targetPath: targetPath)
    }

    private func showCloneWindow(targetPath: String) {
        let state = AppState()

        if let existing = cloneWindow {
            state.showCloneDialog(targetPath: targetPath)
            appState = state
            existing.makeKeyAndOrderFront(nil)
            NSApp.activate(ignoringOtherApps: true)
            return
        }

        let contentView = ContentView(appState: state)
        let hostingView = NSHostingView(rootView: contentView)

        let window = NSWindow(
            contentRect: NSRect(x: 0, y: 0, width: 520, height: 400),
            styleMask: [.titled, .closable, .miniaturizable],
            backing: .buffered,
            defer: false
        )
        window.title = "FinderGitClone"
        window.contentView = hostingView
        window.center()
        window.isReleasedWhenClosed = false
        window.makeKeyAndOrderFront(nil)

        cloneWindow = window
        appState = state
        state.showCloneDialog(targetPath: targetPath)

        NSApp.activate(ignoringOtherApps: true)
    }
}
