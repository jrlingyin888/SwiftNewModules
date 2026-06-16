import SwiftUI

/// A card whose body expands/collapses with a spring animation and rotating chevron.
/// Pass any detail view via the trailing closure.
struct ExpandableDisclosureCard<Detail: View>: View {
    let icon: String?
    let title: String
    let subtitle: String?
    @ViewBuilder var detail: () -> Detail

    @State private var isExpanded = false

    init(
        icon: String? = nil,
        title: String,
        subtitle: String? = nil,
        @ViewBuilder detail: @escaping () -> Detail
    ) {
        self.icon = icon
        self.title = title
        self.subtitle = subtitle
        self.detail = detail
    }

    var body: some View {
        VStack(spacing: 0) {
            Button {
                withAnimation(.spring(response: 0.38, dampingFraction: 0.82)) {
                    isExpanded.toggle()
                }
            } label: {
                header
            }
            .buttonStyle(.plain)
            // Let the Button own the accessibility semantics for the whole header.
            .accessibilityElement(children: .combine)
            .accessibilityLabel(accessibilityLabel)
            .accessibilityValue(isExpanded ? "Expanded" : "Collapsed")
            .accessibilityHint(isExpanded ? "Collapses details" : "Expands details")

            if isExpanded {
                VStack(alignment: .leading, spacing: 0) {
                    Divider()
                    detail()
                        .padding(16)
                        .frame(maxWidth: .infinity, alignment: .leading)
                }
                .transition(.move(edge: .top).combined(with: .opacity))
            }
        }
        .background(.background.secondary, in: RoundedRectangle(cornerRadius: 18))
        .overlay(
            RoundedRectangle(cornerRadius: 18)
                .strokeBorder(Color(.separator).opacity(0.5), lineWidth: 0.5)
        )
        .clipShape(RoundedRectangle(cornerRadius: 18))
        .accessibilityElement(children: .contain)
    }

    private var accessibilityLabel: String {
        if let subtitle {
            return "\(title), \(subtitle)"
        }
        return title
    }

    private var header: some View {
        HStack(spacing: 12) {
            if let icon {
                Image(systemName: icon)
                    .font(.callout.weight(.semibold))
                    .foregroundStyle(.tint)
                    .frame(width: 32, height: 32)
                    .background(.tint.opacity(0.15), in: Circle())
                    .accessibilityHidden(true)
            }
            VStack(alignment: .leading, spacing: 2) {
                Text(title)
                    .font(.headline)
                    .foregroundStyle(.primary)
                    .multilineTextAlignment(.leading)
                if let subtitle {
                    Text(subtitle)
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                        .multilineTextAlignment(.leading)
                }
            }
            Spacer(minLength: 8)
            Image(systemName: "chevron.down")
                .font(.footnote.weight(.bold))
                .foregroundStyle(.secondary)
                .rotationEffect(.degrees(isExpanded ? 180 : 0))
                .accessibilityHidden(true)
        }
        .padding(16)
        .contentShape(Rectangle())
    }
}

#Preview {
    ScrollView {
        VStack(spacing: 14) {
            ExpandableDisclosureCard(
                icon: "creditcard.fill",
                title: "Billing & Payments",
                subtitle: "Manage your plan and invoices"
            ) {
                Text("Your Pro plan renews on July 1, 2026. Update your card or download past invoices anytime from this section.")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
            }

            ExpandableDisclosureCard(
                icon: "bell.badge.fill",
                title: "Notifications"
            ) {
                VStack(alignment: .leading, spacing: 10) {
                    Toggle("Product updates", isOn: .constant(true))
                    Toggle("Weekly summary", isOn: .constant(false))
                }
                .font(.subheadline)
            }
        }
        .padding()
        .tint(.indigo)
    }
    .background(Color(.systemGroupedBackground))
}
