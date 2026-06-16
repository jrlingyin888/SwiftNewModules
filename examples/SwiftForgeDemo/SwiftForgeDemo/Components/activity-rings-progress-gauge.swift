import SwiftUI
import Charts

struct ActivityRingMetric: Identifiable {
    let id = UUID()
    let name: String
    let progress: Double // 0...1 (may exceed 1 for over-achievement)
    let tint: Color
}

struct ActivityRingsProgressGauge: View {
    let metrics: [ActivityRingMetric]
    var ringWidth: CGFloat = 18
    var ringSpacing: CGFloat = 6
    var centerTitle: String = ""
    @State private var animate = false

    private let fullTurn = 1.0

    var body: some View {
        ZStack {
            ForEach(Array(metrics.enumerated()), id: \.element.id) { index, metric in
                let inset = CGFloat(index) * (ringWidth + ringSpacing)
                ring(for: metric)
                    .padding(inset)
            }
            if !centerTitle.isEmpty {
                Text(centerTitle)
                    .font(.title3.bold())
                    .monospacedDigit()
            }
        }
        .frame(width: 200, height: 200)
        .onAppear { withAnimation(.easeOut(duration: 0.9)) { animate = true } }
        .accessibilityElement(children: .ignore)
        .accessibilityLabel("Activity rings")
        .accessibilityValue(
            metrics.map { "\($0.name) \(Int(($0.progress * 100).rounded())) percent" }
                .joined(separator: ", ")
        )
    }

    // Each ring is two stacked charts that share the same inner radius so they
    // align: a faint full-circle track behind, and the progress arc in front.
    private func ring(for metric: ActivityRingMetric) -> some View {
        ZStack {
            trackChart(tint: metric.tint)
            progressChart(for: metric)
        }
    }

    private func trackChart(tint: Color) -> some View {
        Chart {
            SectorMark(
                angle: .value("Track", fullTurn),
                innerRadius: .ratio(trackInnerRatio),
                angularInset: 0
            )
            .foregroundStyle(tint.opacity(0.18))
        }
        .chartLegend(.hidden)
    }

    private func progressChart(for metric: ActivityRingMetric) -> some View {
        // Clamp to one turn for the visual; the full value is reported to VoiceOver.
        let shown = animate ? max(0, min(metric.progress, fullTurn)) : 0
        let remainder = max(0, fullTurn - shown)
        // Two sectors that sum to a full turn so the visible arc spans exactly
        // `shown / fullTurn` of the circle. (SectorMark normalizes by the sum
        // of all sector angles, so the remainder must be present and transparent.)
        return Chart {
            SectorMark(
                angle: .value("Progress", shown),
                innerRadius: .ratio(trackInnerRatio),
                angularInset: 0
            )
            .foregroundStyle(metric.tint.gradient)
            .cornerRadius(ringWidth / 2)

            SectorMark(
                angle: .value("Remainder", remainder),
                innerRadius: .ratio(trackInnerRatio),
                angularInset: 0
            )
            .foregroundStyle(.clear)
        }
        .chartLegend(.hidden)
    }

    private var trackInnerRatio: Double {
        // Approximate inner radius so the stroke reads as ~ringWidth thick
        // against the 200pt frame (outer radius ~100pt).
        max(0, min(1, 1 - (Double(ringWidth) / 100)))
    }
}

#Preview {
    ActivityRingsProgressGauge(
        metrics: [
            .init(name: "Move", progress: 0.82, tint: .pink),
            .init(name: "Exercise", progress: 0.6, tint: .green),
            .init(name: "Stand", progress: 1.0, tint: .cyan)
        ],
        centerTitle: "81%"
    )
    .padding()
}
