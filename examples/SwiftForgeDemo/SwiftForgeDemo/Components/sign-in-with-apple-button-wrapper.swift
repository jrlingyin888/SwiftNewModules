import SwiftUI
import AuthenticationServices

struct AppleSignInButtonWrapper: View {
    /// Wording shown on the button. Maps to `SignInWithAppleButton.Label`.
    enum ButtonLabel {
        case signIn, signUp, continueText

        var systemLabel: SignInWithAppleButton.Label {
            switch self {
            case .signIn: return .signIn
            case .signUp: return .signUp
            case .continueText: return .continue
            }
        }
    }

    var label: ButtonLabel = .continueText
    var cornerRadius: CGFloat = 14
    var height: CGFloat = 52
    var requestedScopes: [ASAuthorization.Scope] = [.fullName, .email]
    var onSuccess: (ASAuthorizationAppleIDCredential) -> Void = { _ in }
    var onError: (any Error) -> Void = { _ in }

    @Environment(\.colorScheme) private var colorScheme

    var body: some View {
        SignInWithAppleButton(label.systemLabel) { request in
            request.requestedScopes = requestedScopes
        } onCompletion: { result in
            switch result {
            case .success(let auth):
                if let credential = auth.credential as? ASAuthorizationAppleIDCredential {
                    onSuccess(credential)
                }
            case .failure(let error):
                onError(error)
            }
        }
        .signInWithAppleButtonStyle(colorScheme == .dark ? .white : .black)
        .frame(maxWidth: .infinity)
        .frame(height: height)
        .clipShape(.rect(cornerRadius: cornerRadius))
        .accessibilityLabel("Sign in with Apple")
    }
}

#Preview {
    VStack(spacing: 16) {
        AppleSignInButtonWrapper(label: .signIn) { _ in } onError: { _ in }
        AppleSignInButtonWrapper(label: .continueText, cornerRadius: 26)
        AppleSignInButtonWrapper(label: .signUp)
    }
    .padding(24)
}
