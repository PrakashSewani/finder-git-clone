import SwiftUI
import FinderGitCloneCore

struct CloneDialogView: View {
    @Bindable var appState: AppState
    @State private var urlInput: String = ""
    @State private var branchInput: String = ""
    @State private var isURLValid: Bool = false
    @State private var detectedProtocol: String?
    @State private var showAdvanced: Bool = false

    var body: some View {
        VStack(spacing: 0) {
            headerSection
            Divider()
            urlSection
            if showAdvanced {
                advancedSection
            }
            Divider()
            footerSection
        }
        .frame(width: 520)
        .onAppear {
            urlInput = ""
            branchInput = ""
        }
    }

    private var headerSection: some View {
        VStack(spacing: 8) {
            HStack {
                Image(systemName: "arrow.down.doc.fill")
                    .font(.system(size: 28))
                    .foregroundStyle(.tint)
                VStack(alignment: .leading, spacing: 2) {
                    Text("Clone Repository")
                        .font(.headline)
                    Text("Paste a Git repository URL to clone into the selected folder.")
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                }
                Spacer()
            }
            if let target = targetPath {
                HStack(spacing: 4) {
                    Image(systemName: "folder.fill")
                        .foregroundStyle(.secondary)
                    Text(target)
                        .font(.caption)
                        .foregroundStyle(.secondary)
                        .lineLimit(1)
                        .truncationMode(.middle)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.horizontal, 4)
                .padding(.vertical, 6)
                .background(Color.secondary.opacity(0.1))
                .clipShape(RoundedRectangle(cornerRadius: 6))
            }
        }
        .padding(20)
    }

    private var urlSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack(spacing: 8) {
                Image(systemName: "link")
                    .foregroundStyle(.secondary)
                TextField("https://github.com/user/repo.git", text: $urlInput)
                    .textFieldStyle(.plain)
                    .font(.system(.body, design: .monospaced))
                    .onChange(of: urlInput) { _, newValue in
                        validateURL(newValue)
                    }
                    .onSubmit {
                        if isURLValid {
                            Task { await appState.startClone() }
                        }
                    }

                if !urlInput.isEmpty {
                    Button(action: { urlInput = "" }) {
                        Image(systemName: "xmark.circle.fill")
                            .foregroundStyle(.secondary)
                    }
                    .buttonStyle(.plain)
                }

                Button(action: pasteFromClipboard) {
                    Image(systemName: "doc.on.clipboard")
                        .foregroundStyle(.secondary)
                }
                .buttonStyle(.plain)
                .help("Paste from clipboard")
            }
            .padding(10)
            .background(Color(nsColor: .controlBackgroundColor))
            .clipShape(RoundedRectangle(cornerRadius: 8))
            .overlay(
                RoundedRectangle(cornerRadius: 8)
                    .stroke(isURLValid ? Color.green.opacity(0.5) : Color.clear, lineWidth: 1.5)
            )

            HStack(spacing: 12) {
                if let proto = detectedProtocol {
                    Label(proto, systemImage: "checkmark.circle.fill")
                        .font(.caption)
                        .foregroundStyle(.green)
                }

                if !urlInput.isEmpty && !isURLValid {
                    Label("Invalid URL", systemImage: "exclamationmark.triangle.fill")
                        .font(.caption)
                        .foregroundStyle(.orange)
                }

                Spacer()

                Button(showAdvanced ? "Hide Options" : "More Options") {
                    withAnimation(.easeInOut(duration: 0.2)) {
                        showAdvanced.toggle()
                    }
                }
                .buttonStyle(.plain)
                .font(.caption)
                .foregroundStyle(.secondary)
            }
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 12)
    }

    private var advancedSection: some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack {
                Label("Branch (optional)", systemImage: "git.branch")
                    .font(.caption)
                    .foregroundStyle(.secondary)
                TextField("main", text: $branchInput)
                    .textFieldStyle(.roundedBorder)
                    .frame(maxWidth: 200)
            }

            if !installedEditors.isEmpty {
                HStack {
                    Label("Open with", systemImage: "app.badge")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                    Spacer()
                    ForEach(installedEditors.prefix(4)) { editor in
                        Button(action: { appState.preferences.preferredEditor = editor }) {
                            Image(systemName: editor.sfSymbol)
                                .font(.caption)
                                .padding(4)
                                .background(
                                    appState.preferences.preferredEditor == editor
                                        ? Color.accentColor.opacity(0.2)
                                        : Color.clear
                                )
                                .clipShape(RoundedRectangle(cornerRadius: 4))
                        }
                        .buttonStyle(.plain)
                        .help(editor.displayName)
                    }
                }
            }
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 8)
    }

    private var footerSection: some View {
        HStack {
            Button("Cancel") {
                appState.dismiss()
            }
            .keyboardShortcut(.cancelAction)

            Spacer()

            Button(action: {
                Task { await appState.startClone() }
            }) {
                HStack(spacing: 6) {
                    Image(systemName: "arrow.down.circle.fill")
                    Text("Clone")
                }
            }
            .buttonStyle(.borderedProminent)
            .disabled(!isURLValid)
            .keyboardShortcut(.defaultAction)
        }
        .padding(16)
    }

    private var targetPath: String? {
        if case .input(let path) = appState.state {
            return path
        }
        return nil
    }

    private var installedEditors: [Editor] {
        appState.installedEditors
    }

    private func validateURL(_ url: String) {
        let gitURL = GitURL(string: url)
        isURLValid = gitURL.isValid
        if isURLValid {
            detectedProtocol = gitURL.scheme.displayName
            appState.repositoryURL = url
        } else {
            detectedProtocol = nil
        }
    }

    private func pasteFromClipboard() {
        if let string = NSPasteboard.general.string(forType: .string) {
            urlInput = string.trimmingCharacters(in: .whitespacesAndNewlines)
        }
    }
}
