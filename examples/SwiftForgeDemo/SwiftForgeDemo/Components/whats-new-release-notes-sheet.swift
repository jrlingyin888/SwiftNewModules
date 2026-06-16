import SwiftUI

struct ReleaseNoteEntry: Identifiable {
    let id = UUID()
    let symbol: String
    let title: String
    let summary: String
    var tint: Color = .accentColor
}

struct WhatsNewReleaseNotesSheet: View {
    var appName: String = "Aurora"
    var versionLabel: String = "Version 3.0"
    var headerSymbol: String = "sparkles"
    var accent: Color = .pink
    var entries: [ReleaseNoteEntry]
    var continueTitle: String = "Continue"
    var onContinue: () -> Void = {}

    var body: some View {
        VStack(spacing: 0) {
            ScrollView {
                VStack(spacing: 28) {
                    VStack(spacing: 12) {
                        Image(systemName: headerSymbol)
                            .font(.system(size: 44, weight: .bold))
                            .symbolRenderingMode(.hierarchical)
                            .foregroundStyle(accent)
                            .frame(width: 84, height: 84)
                            .background(accent.opacity(0.15), in: .rect(cornerRadius: 22, style: .continuous))
                            .accessibilityHidden(true)

                        Text("What's New in \(appName)")
                            .font(.largeTitle.bold())
                            .multilineTextAlignment(.center)
                            .fixedSize(horizontal: false, vertical: true)
                            .accessibilityAddTraits(.isHeader)

                        Text(versionLabel)
                            .font(.subheadline.weight(.semibold))
                            .foregroundStyle(.secondary)
                    }
                    .padding(.top, 32)

                    VStack(alignment: .leading, spacing: 22) {
                        ForEach(entries) { entry in
                            ReleaseNoteRowItem(entry: entry)
                        }
                    }
                }
                .padding(.horizontal, 28)
                .padding(.bottom, 24)
            }

            VStack(spacing: 0) {
                Divider()
                Button(action: onContinue) {
                    Text(continueTitle)
                        .font(.headline)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 6)
                }
                .buttonStyle(.borderedProminent)
                .controlSize(.large)
                .tint(accent)
                .padding(.horizontal, 28)
                .padding(.vertical, 16)
            }
            .background(.bar)
        }
        .background(Color(.systemBackground))
    }
}

private struct ReleaseNoteRowItem: View {
    let entry: ReleaseNoteEntry

    var body: some View {
        HStack(alignment: .top, spacing: 16) {
            Image(systemName: entry.symbol)
                .font(.title2.weight(.semibold))
                .symbolRenderingMode(.hierarchical)
                .foregroundStyle(entry.tint)
                .frame(width: 36)
                .accessibilityHidden(true)

            VStack(alignment: .leading, spacing: 4) {
                Text(entry.title)
                    .font(.headline)
                    .fixedSize(horizontal: false, vertical: true)
                Text(entry.summary)
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                    .fixedSize(horizontal: false, vertical: true)
            }
            Spacer(minLength: 0)
        }
        .accessibilityElement(children: .combine)
    }
}

#Preview {
    Color.clear
        .sheet(isPresented: .constant(true)) {
            WhatsNewReleaseNotesSheet(
                appName: "Aurora",
                versionLabel: "Version 3.0",
                headerSymbol: "sparkles",
                accent: .pink,
                entries: [
                    ReleaseNoteEntry(symbol: "paintbrush.pointed.fill", title: "Fresh New Look", summary: "A redesigned home screen that puts today front and center.", tint: .pink),
                    ReleaseNoteEntry(symbol: "bolt.fill", title: "Twice as Fast", summary: "Launch and sync times have been cut in half.", tint: .orange),
                    ReleaseNoteEntry(symbol: "square.and.arrow.up.fill", title: "Easy Sharing", summary: "Share any project with a single tap.", tint: .blue),
                    ReleaseNoteEntry(symbol: "lock.fill", title: "Locked Down", summary: "Optional Face ID lock keeps your data private.", tint: .green)
                ]
            )
        }
}
