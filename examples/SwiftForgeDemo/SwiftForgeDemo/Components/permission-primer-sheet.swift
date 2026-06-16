import SwiftUI

struct PermissionPrimerBenefit: Identifiable {
    let id = UUID()
    let icon: String
    let text: String
}

struct PermissionPrimerSheet: View {
    let icon: String
    let tint: Color
    let title: String
    let message: String
    let benefits: [PermissionPrimerBenefit]
    var allowTitle: String = "Allow Access"
    let onAllow: () -> Void
    let onSkip: () -> Void

    @Environment(\.dismiss) private var dismiss

    var body: some View {
        VStack(spacing: 0) {
            VStack(spacing: 16) {
                Image(systemName: icon)
                    .font(.system(size: 38, weight: .semibold))
                    .foregroundStyle(.white)
                    .frame(width: 84, height: 84)
                    .background(tint.gradient, in: .rect(cornerRadius: 22))
                    .padding(.top, 32)
                Text(title)
                    .font(.title2.bold())
                    .multilineTextAlignment(.center)
                Text(message)
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                    .multilineTextAlignment(.center)
            }
            .padding(.horizontal, 28)

            VStack(alignment: .leading, spacing: 18) {
                ForEach(benefits) { benefit in
                    HStack(spacing: 14) {
                        Image(systemName: benefit.icon)
                            .font(.body.weight(.semibold))
                            .foregroundStyle(tint)
                            .frame(width: 26)
                        Text(benefit.text)
                            .font(.callout)
                            .fixedSize(horizontal: false, vertical: true)
                        Spacer(minLength: 0)
                    }
                }
            }
            .padding(24)
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(Color(.secondarySystemBackground), in: .rect(cornerRadius: 18))
            .padding(.horizontal, 24)
            .padding(.top, 28)

            Spacer(minLength: 16)

            VStack(spacing: 12) {
                Button {
                    dismiss()
                    onAllow()
                } label: {
                    Text(allowTitle)
                        .font(.headline)
                        .foregroundStyle(.white)
                        .frame(maxWidth: .infinity)
                        .frame(height: 52)
                        .background(tint, in: .rect(cornerRadius: 14))
                }
                Button {
                    dismiss()
                    onSkip()
                } label: {
                    Text("Not Now")
                        .font(.headline)
                        .frame(maxWidth: .infinity)
                        .frame(height: 44)
                }
                .tint(Color.secondary)
            }
            .padding(.horizontal, 24)
            .padding(.bottom, 20)
        }
        .presentationDetents([.height(560), .large])
        .presentationDragIndicator(.visible)
        .presentationCornerRadius(28)
    }
}

extension View {
    func permissionPrimer(
        isPresented: Binding<Bool>,
        icon: String,
        tint: Color = .blue,
        title: String,
        message: String,
        benefits: [PermissionPrimerBenefit],
        allowTitle: String = "Allow Access",
        onAllow: @escaping () -> Void,
        onSkip: @escaping () -> Void = {}
    ) -> some View {
        sheet(isPresented: isPresented) {
            PermissionPrimerSheet(
                icon: icon, tint: tint, title: title, message: message,
                benefits: benefits, allowTitle: allowTitle,
                onAllow: onAllow, onSkip: onSkip
            )
        }
    }
}

#Preview {
    struct PermissionPrimerDemo: View {
        @State private var showPrimer = true
        var body: some View {
            Button("Show Primer") { showPrimer = true }
                .permissionPrimer(
                    isPresented: $showPrimer,
                    icon: "bell.badge.fill",
                    tint: .orange,
                    title: "Stay in the loop",
                    message: "Turn on notifications so you never miss what matters.",
                    benefits: [
                        PermissionPrimerBenefit(icon: "clock.fill", text: "Timely reminders for your tasks"),
                        PermissionPrimerBenefit(icon: "sparkles", text: "Alerts when new features arrive"),
                        PermissionPrimerBenefit(icon: "hand.raised.fill", text: "You're always in control — change anytime in Settings")
                    ],
                    allowTitle: "Enable Notifications",
                    onAllow: { /* request the real system permission here */ },
                    onSkip: {}
                )
        }
    }
    return PermissionPrimerDemo()
}
