import SwiftUI
import FinderGitCloneCore

struct PreferencesView: View {
    @Bindable var appState: AppState

    var body: some View {
        Form {
            Section {
                Picker("Default Editor", selection: Binding(
                    get: { appState.preferences.preferredEditor },
                    set: { appState.preferences.preferredEditor = $0 }
                )) {
                    Text("Auto-detect").tag(nil as Editor?)
                    ForEach(appState.installedEditors) { editor in
                        Label(editor.displayName, systemImage: editor.sfSymbol)
                            .tag(editor as Editor?)
                    }
                }
            } header: {
                Text("Editor")
            } footer: {
                Text("Choose which editor to open cloned projects in, or let the app auto-detect.")
            }

            Section {
                Toggle("Auto-open in editor after cloning", isOn: Binding(
                    get: { appState.preferences.autoOpenInEditor },
                    set: { appState.preferences.autoOpenInEditor = $0 }
                ))

                Toggle("Install dependencies after cloning", isOn: Binding(
                    get: { appState.preferences.installDependencies },
                    set: { appState.preferences.installDependencies = $0 }
                ))
            } header: {
                Text("Automation")
            }

            Section {
                VStack(alignment: .leading, spacing: 8) {
                    Text("How to enable the Finder extension:")
                        .font(.subheadline)
                        .fontWeight(.medium)

                    StepView(number: 1, text: "Open System Settings")
                    StepView(number: 2, text: "Go to Privacy & Security → Extensions → Finder Extensions")
                    StepView(number: 3, text: "Enable FinderGitClone")
                }
                .padding(.vertical, 4)
            } header: {
                Text("Finder Extension")
            }
        }
        .formStyle(.grouped)
        .frame(width: 460, height: 380)
    }
}

private struct StepView: View {
    let number: Int
    let text: String

    var body: some View {
        HStack(spacing: 8) {
            Text("\(number)")
                .font(.caption)
                .fontWeight(.bold)
                .frame(width: 20, height: 20)
                .background(Color.accentColor)
                .foregroundStyle(.white)
                .clipShape(Circle())
            Text(text)
                .font(.caption)
                .foregroundStyle(.secondary)
        }
    }
}
