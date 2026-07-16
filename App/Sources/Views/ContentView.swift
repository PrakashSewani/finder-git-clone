import SwiftUI
import FinderGitCloneCore

struct ContentView: View {
    @Bindable var appState: AppState

    var body: some View {
        Group {
            switch appState.state {
            case .idle:
                idleView
            case .input:
                CloneDialogView(appState: appState)
            case .validating:
                CloneProgressView(
                    progress: GitProgress(phase: .cloning),
                    onCancel: { appState.cancel() }
                )
            case .cloning(let progress):
                CloneProgressView(
                    progress: progress,
                    onCancel: { appState.cancel() }
                )
            case .success(let result):
                CloneSuccessView(
                    result: result,
                    onOpen: {
                        try? appState.editorService.openProject(
                            at: result.directory,
                            projectType: result.type,
                            preferredEditor: appState.preferences.preferredEditor
                        )
                    },
                    onDone: { appState.dismiss() }
                )
            case .error(let error):
                ErrorView(
                    error: error,
                    onRetry: { appState.retry() },
                    onDismiss: { appState.dismiss() }
                )
            }
        }
        .animation(.easeInOut(duration: 0.25), value: appState.state)
    }

    private var idleView: some View {
        VStack(spacing: 16) {
            Image(systemName: "arrow.down.doc.fill")
                .font(.system(size: 48))
                .foregroundStyle(.tint)

            Text("FinderGitClone")
                .font(.title2)
                .fontWeight(.semibold)

            Text("Right-click any folder in Finder and select\n\"Clone Repository...\" to get started.")
                .font(.subheadline)
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.center)

            Button("Preferences...") {
                openPreferences()
            }
            .buttonStyle(.bordered)
            .padding(.top, 8)
        }
        .frame(width: 380, height: 280)
    }

    private func openPreferences() {
        if #available(macOS 14.0, *) {
            NSApp.sendAction(Selector(("showSettingsWindow:")), to: nil, from: nil)
        } else {
            NSApp.sendAction(Selector(("showPreferencesWindow:")), to: nil, from: nil)
        }
    }
}

extension AppState {
    var editorService: EditorService {
        EditorService()
    }
}
