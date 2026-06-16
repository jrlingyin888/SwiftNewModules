import SwiftUI

struct WelcomeHeroSplashScreen: View {
    var logoSymbol: String = "sparkles"
    var appName: String = "Aurora"
    var tagline: String = "Your day, beautifully organized."
    var accent: Color = .indigo
    var primaryTitle: String = "Get Started"
    var secondaryTitle: String = "I already have an account"
    var onPrimary: () -> Void = {}
    var onSecondary: () -> Void = {}

    @State private var appeared = false

    var body: some View {
        ZStack {
            LinearGradient(
                colors: [accent.opacity(0.85), accent.opacity(0.35), Color(.systemBackground)],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()

            VStack(spacing: 20) {
                Spacer()

                Image(systemName: logoSymbol)
                    .font(.system(size: 76, weight: .bold))
                    .symbolRenderingMode(.hierarchical)
                    .foregroundStyle(.white)
                    .padding(36)
                    .background(.ultraThinMaterial, in: .rect(cornerRadius: 32, style: .continuous))
                    .overlay(
                        RoundedRectangle(cornerRadius: 32, style: .continuous)
                            .strokeBorder(.white.opacity(0.25), lineWidth: 1)
                    )
                    .shadow(color: accent.opacity(0.5), radius: 24, y: 12)
                    .scaleEffect(appeared ? 1 : 0.6)
                    .opacity(appeared ? 1 : 0)
                    .accessibilityHidden(true)

                VStack(spacing: 10) {
                    Text("Welcome to")
                        .font(.headline)
                        .foregroundStyle(.white.opacity(0.85))
                    Text(appName)
                        .font(.system(size: 44, weight: .heavy, design: .rounded))
                        .foregroundStyle(.white)
                    Text(tagline)
                        .font(.title3)
                        .foregroundStyle(.white.opacity(0.85))
                        .multilineTextAlignment(.center)
                        .fixedSize(horizontal: false, vertical: true)
                }
                .padding(.horizontal, 32)
                .opacity(appeared ? 1 : 0)
                .offset(y: appeared ? 0 : 16)
                .accessibilityElement(children: .combine)
                .accessibilityAddTraits(.isHeader)

                Spacer()

                VStack(spacing: 14) {
                    Button(action: onPrimary) {
                        Text(primaryTitle)
                            .font(.headline)
                            .foregroundStyle(accent)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 6)
                    }
                    .buttonStyle(.borderedProminent)
                    .controlSize(.large)
                    .tint(.white)

                    Button(secondaryTitle, action: onSecondary)
                        .font(.subheadline.weight(.semibold))
                        .tint(.white)
                }
                .padding(.horizontal, 28)
                .padding(.bottom, 28)
                .opacity(appeared ? 1 : 0)
            }
        }
        .onAppear {
            withAnimation(.smooth(duration: 0.7)) { appeared = true }
        }
    }
}

#Preview {
    WelcomeHeroSplashScreen(
        logoSymbol: "sparkles",
        appName: "Aurora",
        tagline: "Your day, beautifully organized.",
        accent: .indigo
    )
}
