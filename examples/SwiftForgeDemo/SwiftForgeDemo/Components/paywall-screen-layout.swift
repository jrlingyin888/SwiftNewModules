import SwiftUI

struct PaywallPlan: Identifiable {
    let id = UUID()
    let name: String
    let price: String
    let period: String
    var badge: String? = nil
}

struct PaywallScreen: View {
    let title: String
    let benefits: [String]
    let plans: [PaywallPlan]
    var onSubscribe: (PaywallPlan) -> Void = { _ in }
    var onRestore: () -> Void = {}

    @State private var selectedID: PaywallPlan.ID?

    private var selectedPlan: PaywallPlan? {
        plans.first { $0.id == selectedID } ?? plans.first
    }

    var body: some View {
        ScrollView {
            VStack(spacing: 28) {
                VStack(spacing: 14) {
                    Image(systemName: "crown.fill")
                        .font(.system(size: 52))
                        .foregroundStyle(.yellow.gradient)
                        .accessibilityHidden(true)
                    Text(title)
                        .font(.largeTitle.bold())
                        .multilineTextAlignment(.center)
                }
                .padding(.top, 24)

                VStack(alignment: .leading, spacing: 14) {
                    ForEach(benefits, id: \.self) { benefit in
                        Label(benefit, systemImage: "checkmark.circle.fill")
                            .font(.callout)
                            .labelStyle(.titleAndIcon)
                            .symbolRenderingMode(.palette)
                            .foregroundStyle(.primary, .green)
                    }
                }
                .frame(maxWidth: .infinity, alignment: .leading)

                VStack(spacing: 12) {
                    ForEach(plans) { plan in
                        PlanRow(plan: plan, isSelected: plan.id == (selectedID ?? plans.first?.id))
                            .contentShape(Rectangle())
                            .onTapGesture { withAnimation(.snappy) { selectedID = plan.id } }
                    }
                }

                VStack(spacing: 12) {
                    Button {
                        if let plan = selectedPlan { onSubscribe(plan) }
                    } label: {
                        Text("Continue")
                            .font(.headline)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 6)
                    }
                    .buttonStyle(.borderedProminent)
                    .controlSize(.large)

                    HStack(spacing: 20) {
                        Button("Restore", action: onRestore)
                        Link("Terms", destination: URL(string: "https://example.com/terms")!)
                        Link("Privacy", destination: URL(string: "https://example.com/privacy")!)
                    }
                    .font(.footnote)
                    .foregroundStyle(.secondary)
                }
            }
            .padding(24)
        }
        .onAppear { if selectedID == nil { selectedID = plans.first?.id } }
    }
}

private struct PlanRow: View {
    let plan: PaywallPlan
    let isSelected: Bool

    var body: some View {
        HStack(spacing: 14) {
            Image(systemName: isSelected ? "largecircle.fill.circle" : "circle")
                .font(.title3)
                .foregroundStyle(isSelected ? Color.accentColor : .secondary)
            VStack(alignment: .leading, spacing: 2) {
                Text(plan.name).font(.headline)
                Text("\(plan.price) / \(plan.period)")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
            }
            Spacer(minLength: 8)
            if let badge = plan.badge {
                Text(badge)
                    .font(.caption2.bold())
                    .padding(.horizontal, 8)
                    .padding(.vertical, 4)
                    .background(Color.accentColor, in: Capsule())
                    .foregroundStyle(.white)
            }
        }
        .padding(16)
        .background(
            RoundedRectangle(cornerRadius: 16, style: .continuous)
                .fill(.background.secondary)
        )
        .overlay(
            RoundedRectangle(cornerRadius: 16, style: .continuous)
                .strokeBorder(isSelected ? Color.accentColor : .clear, lineWidth: 2)
        )
        .accessibilityElement(children: .combine)
        .accessibilityAddTraits(isSelected ? [.isSelected, .isButton] : .isButton)
    }
}

#Preview {
    PaywallScreen(
        title: "Unlock Aurora Pro",
        benefits: [
            "Unlimited projects and storage",
            "Advanced AI suggestions",
            "Priority support",
            "No ads, ever"
        ],
        plans: [
            PaywallPlan(name: "Yearly", price: "$39.99", period: "year", badge: "Save 40%"),
            PaywallPlan(name: "Monthly", price: "$5.99", period: "month")
        ]
    )
}
