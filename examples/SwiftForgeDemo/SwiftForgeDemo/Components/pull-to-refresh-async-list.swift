import SwiftUI

struct Article: Identifiable, Hashable {
    let id = UUID()
    let title: String
    let summary: String
    let timestamp: Date
}

/// Replace the body of `fetch()` with your real network call.
@Observable
final class ArticleFeed {
    enum Phase: Equatable { case idle, loading, loaded, failed(String) }

    private(set) var phase: Phase = .idle
    private(set) var articles: [Article] = []

    @MainActor
    func load(initial: Bool = false) async {
        if initial { phase = .loading }
        do {
            let fetched = try await fetch()
            articles = fetched
            phase = .loaded
        } catch is CancellationError {
            // Ignore cancellation (e.g. view dismissed mid-refresh).
        } catch {
            phase = .failed(error.localizedDescription)
        }
    }

    private func fetch() async throws -> [Article] {
        try await Task.sleep(for: .seconds(1.2))
        let now = Date()
        return (1...12).map { i in
            Article(
                title: "Headline \(i)",
                summary: "A short, dark-mode-friendly summary line for item number \(i).",
                timestamp: now.addingTimeInterval(Double(-i) * 540)
            )
        }
    }
}

struct PullToRefreshAsyncList: View {
    @State private var feed = ArticleFeed()

    var body: some View {
        NavigationStack {
            Group {
                if feed.articles.isEmpty {
                    // No content yet: pick the right state from the phase.
                    switch feed.phase {
                    case .failed(let message):
                        ContentUnavailableView {
                            Label("Couldn\u{2019}t Load", systemImage: "wifi.exclamationmark")
                        } description: {
                            Text(message)
                        } actions: {
                            Button("Retry") { Task { await feed.load(initial: true) } }
                                .buttonStyle(.borderedProminent)
                        }
                    case .loaded:
                        ContentUnavailableView(
                            "No Articles",
                            systemImage: "tray",
                            description: Text("Pull down to refresh.")
                        )
                    case .idle, .loading:
                        ProgressView("Loading\u{2026}")
                            .frame(maxWidth: .infinity, maxHeight: .infinity)
                    }
                } else {
                    // We already have content: keep it on screen across refreshes.
                    list
                }
            }
            .navigationTitle("Feed")
        }
        .task { await feed.load(initial: true) }
    }

    private var list: some View {
        List(feed.articles) { article in
            VStack(alignment: .leading, spacing: 4) {
                Text(article.title)
                    .font(.headline)
                Text(article.summary)
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                Text(article.timestamp, format: .relative(presentation: .named))
                    .font(.caption)
                    .foregroundStyle(.tertiary)
            }
            .padding(.vertical, 4)
            .accessibilityElement(children: .combine)
        }
        .listStyle(.plain)
        .refreshable { await feed.load() }
    }
}

#Preview {
    PullToRefreshAsyncList()
}
