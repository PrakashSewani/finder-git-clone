import SwiftUI
import FinderGitCloneCore

struct CloneProgressView: View {
    let progress: GitProgress
    let onCancel: () -> Void

    var body: some View {
        VStack(spacing: 20) {
            Spacer()

            VStack(spacing: 16) {
                Image(systemName: "arrow.down.circle")
                    .font(.system(size: 48))
                    .foregroundStyle(.tint)
                    .symbolEffect(.variableColor.iterative)

                Text("Cloning Repository...")
                    .font(.title3)
                    .fontWeight(.medium)
            }

            VStack(spacing: 12) {
                ProgressView(value: progress.progressValue)
                    .progressViewStyle(.linear)
                    .frame(maxWidth: 300)

                Text(progress.displayText)
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                    .animation(.easeInOut, value: progress.phase)

                if let objects = progress.objectCount, let total = progress.totalObjects {
                    Text("\(objects)/\(total) objects")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
            }

            Spacer()

            Button("Cancel", role: .destructive) {
                onCancel()
            }
            .keyboardShortcut(.cancelAction)
            .padding(.bottom, 16)
        }
        .frame(width: 400, height: 300)
    }
}
