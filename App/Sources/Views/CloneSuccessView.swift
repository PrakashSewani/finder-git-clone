import SwiftUI
import FinderGitCloneCore

struct CloneSuccessView: View {
    let result: DetectionResult
    let onOpen: () -> Void
    let onDone: () -> Void

    var body: some View {
        VStack(spacing: 20) {
            Spacer()

            VStack(spacing: 12) {
                Image(systemName: "checkmark.circle.fill")
                    .font(.system(size: 56))
                    .foregroundStyle(.green)

                Text("Repository Cloned!")
                    .font(.title2)
                    .fontWeight(.semibold)
            }

            VStack(spacing: 8) {
                Label(result.type.displayName, systemImage: result.type.sfSymbol)
                    .font(.headline)

                Text(result.directory.path)
                    .font(.caption)
                    .foregroundStyle(.secondary)
                    .lineLimit(2)
                    .truncationMode(.middle)

                if !result.features.isEmpty {
                    HStack(spacing: 6) {
                        ForEach(result.features, id: \.self) { feature in
                            Text(feature.displayName)
                                .font(.caption2)
                                .padding(.horizontal, 6)
                                .padding(.vertical, 2)
                                .background(Color.secondary.opacity(0.15))
                                .clipShape(Capsule())
                        }
                    }
                }
            }

            Spacer()

            HStack(spacing: 12) {
                Button("Show in Finder") {
                    NSWorkspace.shared.selectFile(
                        nil,
                        inFileViewerRootedAtPath: result.directory.path
                    )
                }
                .buttonStyle(.bordered)

                Button(action: onOpen) {
                    HStack(spacing: 6) {
                        Image(systemName: "arrow.up.right.square")
                        Text("Open in Editor")
                    }
                }
                .buttonStyle(.borderedProminent)
                .keyboardShortcut(.defaultAction)
            }
            .padding(.bottom, 16)
        }
        .frame(width: 420, height: 340)
        .onAppear {
            Task {
                try? await Task.sleep(for: .seconds(0.5))
                onOpen()
            }
        }
    }
}
