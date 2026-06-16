import SwiftUI

enum SocialLoginProvider: String, Identifiable, CaseIterable {
    case apple, google, email
    var id: String { rawValue }
    var title: String {
        switch self {
        case .apple: "Sign in with Apple"
        case .google: "Continue with Google"
        case .email: "Continue with email"
        }
    }
    var symbol: String {
        switch self {
        case .apple: "apple.logo"
        case .google: "g.circle.fill"
        case .email: "envelope.fill"
        }
    }
}

/// Custom style that delivers the promised pressed-state, since `.plain`
/// strips the default press feedback that lets the brand backgrounds show.
private struct SocialLoginButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .frame(maxWidth: .infinity)
            .frame(height: 50)
            .contentShape(.rect(cornerRadius: 14))
            .opacity(configuration.isPressed ? 0.7 : 1)
            .scaleEffect(configuration.isPressed ? 0.98 : 1)
            .animation(.easeOut(duration: 0.15), value: configuration.isPressed)
    }
}

private struct SocialLoginButtonLabel: View {
    let provider: SocialLoginProvider
    var body: some View {
        HStack(spacing: 10) {
            Image(systemName: provider.symbol)
                .font(.headline)
            Text(provider.title)
                .font(.headline)
        }
    }
}

struct SocialLoginButtonsStack: View {
    var onSelect: (SocialLoginProvider) -> Void = { _ in }

    var body: some View {
        VStack(spacing: 12) {
            Button { onSelect(.apple) } label: { SocialLoginButtonLabel(provider: .apple) }
                .foregroundStyle(.white)
                .background(.black, in: .rect(cornerRadius: 14))
                .accessibilityLabel("Sign in with Apple")

            Button { onSelect(.google) } label: { SocialLoginButtonLabel(provider: .google) }
                .foregroundStyle(.primary)
                .background(.background, in: .rect(cornerRadius: 14))
                .overlay {
                    RoundedRectangle(cornerRadius: 14)
                        .stroke(.quaternary, lineWidth: 1)
                }
                .accessibilityLabel("Continue with Google")

            HStack {
                Rectangle().fill(.quaternary).frame(height: 1)
                Text("or")
                    .font(.footnote)
                    .foregroundStyle(.secondary)
                Rectangle().fill(.quaternary).frame(height: 1)
            }
            .padding(.vertical, 4)

            Button { onSelect(.email) } label: { SocialLoginButtonLabel(provider: .email) }
                .foregroundStyle(.tint)
                .background(.tint.opacity(0.12), in: .rect(cornerRadius: 14))
                .accessibilityLabel("Continue with email")
        }
        .buttonStyle(SocialLoginButtonStyle())
        .padding(.horizontal)
    }
}

#Preview {
    VStack(spacing: 32) {
        Image(systemName: "lock.shield.fill")
            .font(.system(size: 52))
            .foregroundStyle(.tint)
        Text("Welcome back")
            .font(.largeTitle.bold())
        SocialLoginButtonsStack { provider in
            print("Tapped \(provider.rawValue)")
        }
    }
    .padding()
}
