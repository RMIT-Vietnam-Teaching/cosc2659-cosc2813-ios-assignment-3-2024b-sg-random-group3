import SwiftUI

struct UserDetailView: View {
    @State var user: User
    @ObservedObject var viewModel: AdminDashboardViewModel
    @State private var isEditing = false
    @State private var showingDeleteConfirmation = false
    @Environment(\.presentationMode) var presentationMode

    var body: some View {
        Form {
            Section(header: Text("User Information")) {
                if isEditing {
                    TextField("Full Name", text: $user.fullname)
                    TextField("Email", text: $user.email)
                    TextField("Phone", text: $user.phone)
                } else {
                    Text("Full Name: \(user.fullname)")
                    Text("Email: \(user.email)")
                    Text("Phone: \(user.phone)")
                }
                Text("Role: \(user.role.rawValue)")
                Text("Created: \(user.createdDate, formatter: DateFormatter.shortDate)")
                Text("Last Active: \(user.lastActive, formatter: DateFormatter.shortDate)")
            }

            if viewModel.authViewModel.currentUser?.role == .admin && user.role != .admin {
                Section {
                    Button(isEditing ? "Save" : "Edit") {
                        if isEditing {
                            saveChanges()
                        } else {
                            isEditing = true
                        }
                    }

                    Button("Delete User") {
                        showingDeleteConfirmation = true
                    }
                    .foregroundColor(.red)
                }
            }
        }
        .navigationTitle("User Details")
        .alert(isPresented: $showingDeleteConfirmation) {
            Alert(
                title: Text("Delete User"),
                message: Text("Are you sure you want to delete this user?"),
                primaryButton: .destructive(Text("Delete")) {
                    deleteUser()
                },
                secondaryButton: .cancel()
            )
        }
    }

    private func saveChanges() {
        viewModel.updateUser(user: user) { success in
            if success {
                isEditing = false
            }
        }
    }

    private func deleteUser() {
        viewModel.deleteUser(userId: user.id) { success in
            if success {
                presentationMode.wrappedValue.dismiss()
            }
        }
    }
}

extension DateFormatter {
    static let shortDate: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        formatter.timeStyle = .short
        return formatter
    }()
}
