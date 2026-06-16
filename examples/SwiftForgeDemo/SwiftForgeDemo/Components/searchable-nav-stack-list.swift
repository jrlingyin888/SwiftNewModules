import SwiftUI

/// A model item shown in the searchable list.
struct Contact: Identifiable, Hashable {
    let id = UUID()
    var name: String
    var role: String
    var isFavorite: Bool = false
}

/// A NavigationStack with a `.searchable` list that filters live and pushes
/// a type-safe detail view via `navigationDestination(for:)`.
struct SearchableNavStackList: View {
    @State private var contacts: [Contact]
    @State private var query = ""

    init(contacts: [Contact]) {
        _contacts = State(initialValue: contacts)
    }

    private var filtered: [Contact] {
        guard !query.isEmpty else { return contacts }
        return contacts.filter {
            $0.name.localizedCaseInsensitiveContains(query) ||
            $0.role.localizedCaseInsensitiveContains(query)
        }
    }

    var body: some View {
        NavigationStack {
            List {
                ForEach(filtered) { contact in
                    NavigationLink(value: contact) {
                        row(contact)
                    }
                    .swipeActions(edge: .leading, allowsFullSwipe: true) {
                        Button {
                            toggleFavorite(contact)
                        } label: {
                            Label(contact.isFavorite ? "Unfavorite" : "Favorite",
                                  systemImage: contact.isFavorite ? "star.slash" : "star")
                        }
                        .tint(.yellow)
                    }
                }
            }
            .navigationTitle("Contacts")
            .navigationDestination(for: Contact.self) { contact in
                detail(contact)
            }
            .searchable(text: $query, prompt: "Name or role")
            .overlay {
                if filtered.isEmpty {
                    if query.isEmpty {
                        ContentUnavailableView(
                            "No Contacts",
                            systemImage: "person.crop.circle.badge.questionmark",
                            description: Text("Contacts you add will appear here.")
                        )
                    } else {
                        ContentUnavailableView.search(text: query)
                    }
                }
            }
        }
    }

    private func row(_ contact: Contact) -> some View {
        HStack(spacing: 12) {
            Image(systemName: "person.circle.fill")
                .font(.title2)
                .foregroundStyle(.tint)
            VStack(alignment: .leading, spacing: 2) {
                Text(contact.name).font(.body.weight(.medium))
                Text(contact.role).font(.caption).foregroundStyle(.secondary)
            }
            Spacer()
            if contact.isFavorite {
                Image(systemName: "star.fill")
                    .font(.footnote)
                    .foregroundStyle(.yellow)
                    .accessibilityLabel("Favorite")
            }
        }
    }

    private func detail(_ contact: Contact) -> some View {
        VStack(spacing: 16) {
            Image(systemName: "person.circle.fill")
                .font(.system(size: 72))
                .foregroundStyle(.tint)
            Text(contact.name).font(.title.bold())
            Text(contact.role).font(.headline).foregroundStyle(.secondary)
        }
        .padding()
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
        .navigationTitle(contact.name)
        .navigationBarTitleDisplayMode(.inline)
    }

    private func toggleFavorite(_ contact: Contact) {
        guard let idx = contacts.firstIndex(of: contact) else { return }
        withAnimation { contacts[idx].isFavorite.toggle() }
    }
}

#Preview {
    SearchableNavStackList(contacts: [
        Contact(name: "Ada Lovelace", role: "Mathematician", isFavorite: true),
        Contact(name: "Alan Turing", role: "Computer Scientist"),
        Contact(name: "Grace Hopper", role: "Rear Admiral"),
        Contact(name: "Katherine Johnson", role: "Aerospace Engineer")
    ])
    .tint(.blue)
}
