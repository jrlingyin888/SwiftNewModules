import SwiftUI
import Charts

struct SparklineTrendRow: View {
    let title: String
    let subtitle: String
    let value: String
    let series: [Double]
    let changePercent: Double

    private var isUp: Bool { changePercent >= 0 }
    private var trendColor: Color { isUp ? .green : .red }

    // Guard against a flat/degenerate series so chartYScale never receives
    // an empty or zero-height domain (which would collapse the line).
    private var yDomain: ClosedRange<Double> {
        guard let lo = series.min(), let hi = series.max() else {
            return 0...1
        }
        if lo == hi {
            // All values equal: pad by 1 (or 5% of magnitude) to keep a valid range.
            let pad = max(abs(lo) * 0.05, 1)
            return (lo - pad)...(hi + pad)
        }
        return lo...hi
    }

    var body: some View {
        HStack(spacing: 14) {
            VStack(alignment: .leading, spacing: 3) {
                Text(title)
                    .font(.subheadline.weight(.semibold))
                Text(subtitle)
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }

            Spacer(minLength: 8)

            Chart(Array(series.enumerated()), id: \.offset) { index, point in
                LineMark(
                    x: .value("Index", index),
                    y: .value("Value", point)
                )
                .interpolationMethod(.catmullRom)
                .foregroundStyle(trendColor)
                .lineStyle(StrokeStyle(lineWidth: 2, lineCap: .round))
            }
            .chartXAxis(.hidden)
            .chartYAxis(.hidden)
            .chartLegend(.hidden)
            .chartYScale(domain: yDomain)
            .frame(width: 72, height: 34)
            .accessibilityHidden(true)

            VStack(alignment: .trailing, spacing: 3) {
                Text(value)
                    .font(.subheadline.weight(.semibold))
                    .monospacedDigit()
                Text(changePercent.formatted(.percent.precision(.fractionLength(1)).sign(strategy: .always())))
                    .font(.caption.weight(.semibold))
                    .monospacedDigit()
                    .foregroundStyle(trendColor)
                    .padding(.horizontal, 6)
                    .padding(.vertical, 2)
                    .background(trendColor.opacity(0.14), in: .capsule)
            }
        }
        .padding(.vertical, 6)
        .contentShape(.rect)
        .accessibilityElement(children: .ignore)
        .accessibilityLabel("\(title), \(subtitle)")
        .accessibilityValue("\(value), \(isUp ? "up" : "down") \(abs(changePercent).formatted(.percent))")
    }
}

#Preview {
    NavigationStack {
        List {
            SparklineTrendRow(title: "AAPL", subtitle: "Apple Inc.", value: "$214.29", series: [180, 182, 179, 188, 192, 190, 201, 214], changePercent: 0.124)
            SparklineTrendRow(title: "TSLA", subtitle: "Tesla Inc.", value: "$176.40", series: [220, 210, 205, 198, 188, 182, 179, 176], changePercent: -0.085)
            SparklineTrendRow(title: "NVDA", subtitle: "NVIDIA Corp.", value: "$128.05", series: [95, 102, 110, 108, 118, 122, 125, 128], changePercent: 0.231)
            SparklineTrendRow(title: "FLAT", subtitle: "Flat Series", value: "$50.00", series: [50, 50, 50, 50], changePercent: 0.0)
        }
        .listStyle(.plain)
        .navigationTitle("Watchlist")
    }
}
