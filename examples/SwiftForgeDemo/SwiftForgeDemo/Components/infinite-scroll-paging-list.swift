import SwiftUI

/// A page item for `InfiniteScrollPagingList`.
struct InfiniteFeedItem: Identifiable, Hashable {
    let id: Int
    var title: String
    var subtitle: String
}

/// An infinite-scroll List that appends the next page when the last row appears.
/// Replace `loadPage` with your real async paginated request.
struct InfiniteScrollPagingList: View {
    @State private var items: [InfiniteFeedItem] = []
    @State private var page = 0
    @State private var isLoading = false
    @State private var reachedEnd = false

    private let pageSize = 20
    private let maxPages = 6

    var body: some View {
        NavigationStack {
            List {
                ForEach(items) { item in
                    InfiniteFeedRow(item: item)
                        .onAppear {
                            if item == items.last {
                                Task { await loadNextPage() }
                            }
                        }
                }

                if isLoading {
                    HStack {
                        Spacer()
                        ProgressView()
                        Spacer()
                    }
                    .listRowSeparator(.hidden)
                } else if reachedEnd {
                    Text("You're all caught up")
                        .font(.footnote)
                        .foregroundStyle(.secondary)
                        .frame(maxWidth: .infinity, alignment: .center)
                        .listRowSeparator(.hidden)
                }
            }
            .listStyle(.plain)
            .navigationTitle("Activity")
            .task {
                if items.isEmpty { await loadNextPage() }
            }
        }
    }

    private func loadNextPage() async {
        guard !isLoading, !reachedEnd else { return }
        isLoading = true
        defer { isLoading = false }

        let next = await loadPage(page)
        items.append(contentsOf: next)
        page += 1
        if page >= maxPages { reachedEnd = true }
    }

    /// Simulated async data source. Swap for a real network request.
    private func loadPage(_ page: Int) async -> [InfiniteFeedItem] {
        try? await Task.sleep(for: .milliseconds(700))
        let start = page * pageSize
        return (start..<(start + pageSize)).map { index in
            InfiniteFeedItem(
                id: index,
                title: "Item #\(index + 1)",
                subtitle: "Loaded in page \(page + 1)"
            )
        }
    }
}

private struct InfiniteFeedRow: View {
    let item: InfiniteFeedItem

    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: "circle.grid.2x2.fill")
                .font(.title3)
                .foregroundStyle(.tint)
                .frame(width: 36, height: 36)
                .background(.tint.opacity(0.12), in: .rect(cornerRadius: 10))

            VStack(alignment: .leading, spacing: 2) {
                Text(item.title)
                    .font(.body.weight(.medium))
                Text(item.subtitle)
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
        }
        .padding(.vertical, 4)
        .accessibilityElement(children: .combine)
    }
}

#Preview {
    InfiniteScrollPagingList()
        .tint(.teal)
}
