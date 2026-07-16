import SwiftUI
import FinderGitCloneCore

struct ErrorView: View {
    let error: GitError
    let onRetry: () -> Void
    let onDismiss: () -> Void

    var body: some View {
        VStack(spacing: 20) {
            Spacer()

            VStack(spacing: 12) {
                Image(systemName: "exclamationmark.triangle.fill")
                    .font(.system(size: 48))
                    .foregroundStyle(.orange)

                Text("Clone Failed")
                    .font(.title3)
                    .fontWeight(.medium)
            }

            VStack(spacing: 8) {
                Text(error.localizedDescription)
                    .font(.body)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 20)

                if let suggestion = error.recoverySuggestion {
                    Text(suggestion)
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, 20)
                }
            }

            Spacer()

            HStack(spacing: 12) {
                Button("Copy Error") {
                    let text = "\(error.localizedDescription)\n\(error.recoverySuggestion ?? "")"
                    NSPasteboard.general.clearContents()
                    NSPasteboard.general.setString(text, forType: .string)
                }
                .buttonStyle(.bordered)

                Spacer()

                Button("Cancel") {
                    onDismiss()
                }
                .buttonStyle(.bordered)
                .keyboardShortcut(.cancelAction)

                Button("Try Again") {
                    onRetry()
                }
                .buttonStyle(.borderedProminent)
                .keyboardShortcut(.defaultAction)
            }
            .padding(.horizontal, 20)
            .padding(.bottom, 16)
        }
        .frame(width: 440, height: 340)
    }
}
