import SwiftUI

@Observable
final class SignInScreenModel {
    var email = ""
    var password = ""
    var isSubmitting = false

    var canSubmit: Bool {
        email.contains("@") && password.count >= 6 && !isSubmitting
    }

    @MainActor
    func signIn() async {
        isSubmitting = true
        defer { isSubmitting = false }
        try? await Task.sleep(for: .seconds(1.2))
    }
}

struct EmailPasswordSocialSignInScreen: View {
    @State private var model = SignInScreenModel()
    @FocusState private var focused: Field?

    private enum Field { case email, password }

    var body: some View {
        ScrollView {
            VStack(spacing: 24) {
                header
                fields
                forgotPassword
                primaryButton
                divider
                socialButtons
                signUpFooter
            }
            .padding(.horizontal, 24)
            .padding(.top, 48)
            .padding(.bottom, 32)
        }
        .scrollDismissesKeyboard(.interactively)
        .background(Color(.systemBackground))
    }

    private var header: some View {
        VStack(spacing: 8) {
            Image(systemName: "lock.shield.fill")
                .font(.system(size: 44))
                .foregroundStyle(.tint)
                .padding(.bottom, 4)
            Text("Welcome back")
                .font(.largeTitle.bold())
            Text("Sign in to continue")
                .font(.subheadline)
                .foregroundStyle(.secondary)
        }
        .multilineTextAlignment(.center)
        .padding(.bottom, 8)
    }

    private var fields: some View {
        VStack(spacing: 14) {
            labeledField(icon: "envelope.fill", placeholder: "Email", text: $model.email, field: .email)
                .textContentType(.emailAddress)
                .keyboardType(.emailAddress)
                .textInputAutocapitalization(.never)
                .autocorrectionDisabled()
                .submitLabel(.next)
                .onSubmit { focused = .password }
            labeledField(icon: "lock.fill", placeholder: "Password", text: $model.password, field: .password, secure: true)
                .textContentType(.password)
                .submitLabel(.go)
                .onSubmit { Task { await model.signIn() } }
        }
    }

    private func labeledField(icon: String, placeholder: String, text: Binding<String>, field: Field, secure: Bool = false) -> some View {
        HStack(spacing: 12) {
            Image(systemName: icon)
                .foregroundStyle(.secondary)
                .frame(width: 20)
            Group {
                if secure {
                    SecureField(placeholder, text: text)
                } else {
                    TextField(placeholder, text: text)
                }
            }
            .focused($focused, equals: field)
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 14)
        .background(Color(.secondarySystemBackground), in: .rect(cornerRadius: 14))
        .overlay(
            RoundedRectangle(cornerRadius: 14)
                .strokeBorder(focused == field ? AnyShapeStyle(.tint) : AnyShapeStyle(.clear), lineWidth: 1.5)
        )
        .animation(.easeInOut(duration: 0.15), value: focused)
    }

    private var forgotPassword: some View {
        HStack {
            Spacer()
            Button("Forgot password?") {}
                .font(.subheadline.weight(.medium))
        }
    }

    private var primaryButton: some View {
        Button {
            focused = nil
            Task { await model.signIn() }
        } label: {
            ZStack {
                Text("Sign In").opacity(model.isSubmitting ? 0 : 1)
                if model.isSubmitting {
                    ProgressView().tint(.white)
                }
            }
            .font(.headline)
            .foregroundStyle(.white)
            .frame(maxWidth: .infinity)
            .frame(height: 52)
            .background(.tint, in: .rect(cornerRadius: 14))
        }
        .disabled(!model.canSubmit)
        .opacity(model.canSubmit ? 1 : 0.5)
        .animation(.easeInOut(duration: 0.2), value: model.canSubmit)
    }

    private var divider: some View {
        HStack(spacing: 12) {
            Rectangle().fill(.quaternary).frame(height: 1)
            Text("or").font(.footnote).foregroundStyle(.secondary)
            Rectangle().fill(.quaternary).frame(height: 1)
        }
    }

    private var socialButtons: some View {
        VStack(spacing: 12) {
            socialButton(title: "Continue with Apple", icon: "apple.logo", foreground: .primary)
            socialButton(title: "Continue with Google", icon: "g.circle.fill", foreground: .primary)
        }
    }

    private func socialButton(title: String, icon: String, foreground: Color) -> some View {
        Button {} label: {
            HStack(spacing: 10) {
                Image(systemName: icon)
                Text(title).font(.headline)
            }
            .foregroundStyle(foreground)
            .frame(maxWidth: .infinity)
            .frame(height: 52)
            .background(Color(.secondarySystemBackground), in: .rect(cornerRadius: 14))
            .overlay(
                RoundedRectangle(cornerRadius: 14)
                    .strokeBorder(.quaternary, lineWidth: 1)
            )
        }
    }

    private var signUpFooter: some View {
        HStack(spacing: 4) {
            Text("Don't have an account?").foregroundStyle(.secondary)
            Button("Sign up") {}.fontWeight(.semibold)
        }
        .font(.subheadline)
        .padding(.top, 4)
    }
}

#Preview {
    EmailPasswordSocialSignInScreen()
        .tint(.indigo)
}
