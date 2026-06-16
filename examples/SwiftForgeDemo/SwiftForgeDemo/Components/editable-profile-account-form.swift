import SwiftUI

struct EditableProfileAccount: Equatable {
    var fullName: String
    var email: String
    var bio: String
    var initials: String
}

struct EditableProfileAccountForm: View {
    @State private var draft: EditableProfileAccount
    private let original: EditableProfileAccount
    var onSave: (EditableProfileAccount) -> Void

    init(account: EditableProfileAccount, onSave: @escaping (EditableProfileAccount) -> Void = { _ in }) {
        _draft = State(initialValue: account)
        self.original = account
        self.onSave = onSave
    }

    private var isDirty: Bool { draft != original }

    private var isEmailValid: Bool {
        let email = draft.email.trimmingCharacters(in: .whitespaces)
        guard !email.isEmpty else { return false }
        // Case-insensitive pattern (a-z and A-Z) so lowercase input validates
        // without relying on a post-hoc .ignoresCase() chain on a regex literal.
        let pattern = #/^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,}$/#
        return (try? pattern.wholeMatch(in: email)) != nil
    }

    private var isNameValid: Bool {
        !draft.fullName.trimmingCharacters(in: .whitespaces).isEmpty
    }

    private var canSave: Bool { isDirty && isNameValid && isEmailValid }

    var body: some View {
        NavigationStack {
            Form {
                Section {
                    VStack(spacing: 12) {
                        ZStack(alignment: .bottomTrailing) {
                            Circle()
                                .fill(Color.accentColor.gradient)
                                .frame(width: 84, height: 84)
                                .overlay(
                                    Text(draft.initials)
                                        .font(.title)
                                        .fontWeight(.semibold)
                                        .foregroundStyle(.white)
                                )
                            Image(systemName: "camera.fill")
                                .font(.caption)
                                .padding(7)
                                .background(.background, in: Circle())
                                .overlay(Circle().stroke(.quaternary))
                                .foregroundStyle(.tint)
                        }
                        Text("Change photo")
                            .font(.footnote)
                            .foregroundStyle(.tint)
                    }
                    .frame(maxWidth: .infinity)
                    .listRowBackground(Color.clear)
                }

                Section("Identity") {
                    LabeledContent("Name") {
                        TextField("Full name", text: $draft.fullName)
                            .multilineTextAlignment(.trailing)
                            .textContentType(.name)
                    }
                    LabeledContent("Email") {
                        TextField("you@example.com", text: $draft.email)
                            .multilineTextAlignment(.trailing)
                            .textContentType(.emailAddress)
                            .keyboardType(.emailAddress)
                            .textInputAutocapitalization(.never)
                            .autocorrectionDisabled()
                    }
                    if !draft.email.isEmpty && !isEmailValid {
                        Label("Enter a valid email address", systemImage: "exclamationmark.circle")
                            .font(.caption)
                            .foregroundStyle(.red)
                    }
                }

                Section("Bio") {
                    TextField("A short description", text: $draft.bio, axis: .vertical)
                        .lineLimit(3...6)
                }
            }
            .navigationTitle("Edit Profile")
            .navigationBarTitleDisplayMode(.inline)
            .safeAreaInset(edge: .bottom) {
                Button {
                    onSave(draft)
                } label: {
                    Text("Save changes")
                        .font(.headline)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 6)
                }
                .buttonStyle(.borderedProminent)
                .disabled(!canSave)
                .padding()
                .background(.bar)
            }
        }
    }
}

#Preview {
    EditableProfileAccountForm(account: .init(
        fullName: "Maya Rodriguez",
        email: "maya@example.com",
        bio: "Product designer. Coffee enthusiast.",
        initials: "MR"))
}
