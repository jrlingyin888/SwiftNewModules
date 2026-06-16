import SwiftUI

struct DashboardStatTile: Identifiable {
    let id = UUID()
    var title: String
    var value: String
    var systemImage: String
    var tint: Color
    var delta: Double? = nil // positive = up, negative = down, nil = no trend
}

struct DashboardStatTileGrid: View {
    var tiles: [DashboardStatTile]
    var minTileWidth: CGFloat = 150
    var spacing: CGFloat = 12

    private var columns: [GridItem] {
        [GridItem(.adaptive(minimum: minTileWidth), spacing: spacing)]
    }

    var body: some View {
        LazyVGrid(columns: columns, spacing: spacing) {
            ForEach(tiles) { tile in
                DashboardStatTileView(tile: tile)
            }
        }
    }
}

private struct DashboardStatTileView: View {
    let tile: DashboardStatTile

    private var trendColor: Color {
        guard let d = tile.delta else { return .secondary }
        return d >= 0 ? .green : .red
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Image(systemName: tile.systemImage)
                    .font(.system(size: 18, weight: .semibold))
                    .foregroundStyle(tile.tint)
                    .frame(width: 34, height: 34)
                    .background(tile.tint.opacity(0.15), in: .rect(cornerRadius: 9))
                Spacer()
                if let delta = tile.delta {
                    Label("\(abs(delta), format: .number.precision(.fractionLength(1)))%",
                          systemImage: delta >= 0 ? "arrow.up.right" : "arrow.down.right")
                        .font(.caption2.weight(.semibold))
                        .labelStyle(.titleAndIcon)
                        .foregroundStyle(trendColor)
                }
            }
            Text(tile.value)
                .font(.title2.weight(.bold))
                .foregroundStyle(.primary)
                .lineLimit(1)
                .minimumScaleFactor(0.7)
            Text(tile.title)
                .font(.footnote)
                .foregroundStyle(.secondary)
                .lineLimit(1)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(14)
        .background(.background.secondary, in: .rect(cornerRadius: 16))
        .overlay(
            RoundedRectangle(cornerRadius: 16)
                .strokeBorder(.separator.opacity(0.6), lineWidth: 0.5)
        )
        .accessibilityElement(children: .combine)
        .accessibilityLabel("\(tile.title), \(tile.value)")
    }
}

#Preview {
    ScrollView {
        DashboardStatTileGrid(tiles: [
            DashboardStatTile(title: "Revenue", value: "$48.2K", systemImage: "dollarsign.circle.fill", tint: .green, delta: 12.4),
            DashboardStatTile(title: "Active Users", value: "3,910", systemImage: "person.2.fill", tint: .blue, delta: 4.1),
            DashboardStatTile(title: "Churn", value: "1.8%", systemImage: "arrow.uturn.down", tint: .orange, delta: -0.6),
            DashboardStatTile(title: "Sessions", value: "12.4K", systemImage: "chart.bar.fill", tint: .purple),
            DashboardStatTile(title: "Avg. Order", value: "$62", systemImage: "cart.fill", tint: .pink, delta: 2.0),
            DashboardStatTile(title: "Uptime", value: "99.9%", systemImage: "bolt.heart.fill", tint: .teal, delta: 0.1)
        ])
        .padding()
    }
}
