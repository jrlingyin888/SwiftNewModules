import SwiftUI
import Charts

struct LineTrendPoint: Identifiable {
    let id = UUID()
    let label: String
    let value: Double
    let series: String
}

struct MultiLineTrendChartCard: View {
    let title: String
    let data: [LineTrendPoint]
    var unit: String = ""

    private var orderedSeries: [String] {
        var seen = Set<String>()
        return data.compactMap { seen.insert($0.series).inserted ? $0.series : nil }
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text(title)
                .font(.headline)

            Chart(data) { point in
                LineMark(
                    x: .value("Period", point.label),
                    y: .value("Value", point.value)
                )
                .foregroundStyle(by: .value("Series", point.series))
                .symbol(by: .value("Series", point.series))
                .interpolationMethod(.catmullRom)
                .lineStyle(StrokeStyle(lineWidth: 2.5, lineCap: .round))

                PointMark(
                    x: .value("Period", point.label),
                    y: .value("Value", point.value)
                )
                .foregroundStyle(by: .value("Series", point.series))
                .symbolSize(36)
            }
            .chartLegend(position: .top, alignment: .leading, spacing: 8)
            .chartYAxis {
                AxisMarks(position: .leading) { value in
                    AxisGridLine()
                    AxisValueLabel {
                        if let number = value.as(Double.self) {
                            Text("\(number, format: .number.notation(.compactName))\(unit)")
                        }
                    }
                }
            }
            .frame(minHeight: 210, maxHeight: 320)
        }
        .padding(16)
        .background(.background.secondary, in: .rect(cornerRadius: 20))
        .accessibilityElement(children: .contain)
        .accessibilityLabel("\(title). \(orderedSeries.count) series line chart.")
    }
}

#Preview {
    let months = ["Jan", "Feb", "Mar", "Apr", "May", "Jun"]
    let mobile = [22.0, 28, 35, 33, 42, 51]
    let web = [40.0, 38, 36, 44, 41, 47]
    let api = [10.0, 14, 19, 25, 30, 38]
    var sample: [LineTrendPoint] = []
    for (index, month) in months.enumerated() {
        sample.append(.init(label: month, value: mobile[index], series: "Mobile"))
        sample.append(.init(label: month, value: web[index], series: "Web"))
        sample.append(.init(label: month, value: api[index], series: "API"))
    }
    return MultiLineTrendChartCard(title: "Active Users", data: sample, unit: "k")
        .padding()
}
