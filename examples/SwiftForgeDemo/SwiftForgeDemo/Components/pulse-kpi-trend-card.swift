import SwiftUI
import Charts

/// A hero KPI tile: a large headline value with a signed delta chip over a
/// comparison caption, sitting above a full-width gradient area mini-chart that
/// fills the bottom of the card. Trend color and arrow derive from `change`.
struct PulseKPITrendCard: View {
    let title: String
    let value: String
    /// Fractional change vs. the comparison period (0.124 == +12.4%).
    let change: Double
    let comparison: String
    /// Ordered data points driving the area trend chart.
    let series: [Double]
    let accent: Color

    private var isUp: Bool { change >= 0 }
    private var trendColor: Color { isUp ? .green : .red }

    // Pad a flat/empty series so the area scale is never zero-height.
    private var yDomain: ClosedRange<Double> {
        guard let lo = series.min(), let hi = series.max() else { return 0...1 }
        if lo == hi { return (lo - 1)...(hi + 1) }
        let pad = (hi - lo) * 0.15
        return (lo - pad)...(hi + pad)
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            header
            trendChart
                .frame(height: 70)
                .padding(.top, 14)
        }
        .padding(16)
        .background(.background.secondary, in: .rect(cornerRadius: 22))
        .overlay(
            RoundedRectangle(cornerRadius: 22, style: .continuous)
                .strokeBorder(.separator.opacity(0.5), lineWidth: 0.5)
        )
        .accessibilityElement(children: .ignore)
        .accessibilityLabel(title)
        .accessibilityValue("\(value), \(isUp ? "up" : "down") \(abs(change).formatted(.percent.precision(.fractionLength(0...1)))) \(comparison)")
    }

    private var header: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Text(title)
                    .font(.subheadline.weight(.medium))
                    .foregroundStyle(.secondary)
                Spacer(minLength: 8)
                deltaChip
            }
            Text(value)
                .font(.system(.largeTitle, design: .rounded).weight(.bold))
                .foregroundStyle(.primary)
                .contentTransition(.numericText())
                .lineLimit(1)
                .minimumScaleFactor(0.6)
            Text(comparison)
                .font(.caption)
                .foregroundStyle(.tertiary)
        }
    }

    private var deltaChip: some View {
        HStack(spacing: 2) {
            Image(systemName: isUp ? "arrow.up.right" : "arrow.down.right")
                .font(.caption2.weight(.bold))
            Text(abs(change), format: .percent.precision(.fractionLength(0...1)))
                .font(.caption.weight(.semibold))
                .contentTransition(.numericText())
        }
        .foregroundStyle(trendColor)
        .padding(.horizontal, 8)
        .padding(.vertical, 4)
        .background(trendColor.opacity(0.15), in: .capsule)
    }

    private var trendChart: some View {
        Chart(Array(series.enumerated()), id: \.offset) { index, point in
            AreaMark(
                x: .value("Index", index),
                yStart: .value("Min", yDomain.lowerBound),
                yEnd: .value("Value", point)
            )
            .interpolationMethod(.catmullRom)
            .foregroundStyle(
                LinearGradient(
                    colors: [accent.opacity(0.35), accent.opacity(0.02)],
                    startPoint: .top, endPoint: .bottom
                )
            )

            LineMark(
                x: .value("Index", index),
                y: .value("Value", point)
            )
            .interpolationMethod(.catmullRom)
            .foregroundStyle(accent.gradient)
            .lineStyle(StrokeStyle(lineWidth: 2.5, lineCap: .round))
        }
        .chartXAxis(.hidden)
        .chartYAxis(.hidden)
        .chartLegend(.hidden)
        .chartYScale(domain: yDomain)
        .accessibilityHidden(true)
    }
}

#Preview {
    ScrollView {
        VStack(spacing: 16) {
            PulseKPITrendCard(
                title: "Monthly Revenue",
                value: "$48.2K",
                change: 0.124,
                comparison: "vs. last month",
                series: [22, 28, 25, 31, 30, 38, 42, 40, 48],
                accent: .green
            )
            PulseKPITrendCard(
                title: "Churn Rate",
                value: "2.4%",
                change: -0.087,
                comparison: "vs. previous 30 days",
                series: [3.4, 3.2, 3.1, 2.9, 3.0, 2.7, 2.6, 2.4],
                accent: .orange
            )
        }
        .padding()
    }
    .background(Color(.systemGroupedBackground))
}
