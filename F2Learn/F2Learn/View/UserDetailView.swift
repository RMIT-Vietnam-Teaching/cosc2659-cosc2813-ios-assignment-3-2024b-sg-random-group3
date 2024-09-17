import SwiftUI

struct UserDetailView: View {
    @State var user: User
    @ObservedObject var viewModel: AdminDashboardViewModel
    @State private var isEditing = false
    @State private var showingDeleteConfirmation = false
    @Environment(\.presentationMode) var presentationMode

    var body: some View {
        Form {
            // User Information Section
            Section(header: Text("User Information")) {
                if isEditing {
                    TextField("Full Name", text: $user.fullname)
                        .foregroundColor(Color("primarycolor")) // Primary color for editable fields
                    TextField("Email", text: $user.email)
                        .foregroundColor(Color("primarycolor"))
                    TextField("Phone", text: $user.phone)
                        .foregroundColor(Color("primarycolor"))
                } else {
                    Text("Full Name: \(user.fullname)")
                        .foregroundColor(.primary)
                    Text("Email: \(user.email)")
                        .foregroundColor(.secondary)
                    Text("Phone: \(user.phone)")
                        .foregroundColor(.secondary)
                }
                Text("Role: \(user.role.rawValue)")
                    .foregroundColor(.secondary)
                Text("Created: \(user.createdDate, formatter: DateFormatter.shortDate)")
                    .foregroundColor(.secondary)
                Text("Last Active: \(user.lastActive, formatter: DateFormatter.shortDate)")
                    .foregroundColor(.secondary)
            }

            // Admin Actions Section
            if viewModel.authViewModel.currentUser?.role == .admin && user.role != .admin {
                Section {
                    Button(action: {
                        if isEditing {
                            saveChanges()
                        } else {
                            isEditing = true
                        }
                    }) {
                        Text(isEditing ? "Save" : "Edit")
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color("primarycolor"))
                            .foregroundColor(.white)
                            .cornerRadius(8)
                    }

                    Button(action: {
                        showingDeleteConfirmation = true
                    }) {
                        Text("Delete User")
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.red)
                            .foregroundColor(.white)
                            .cornerRadius(8)
                    }
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

    // Save Changes
    private func saveChanges() {
        viewModel.updateUser(user: user) { success in
            if success {
                isEditing = false
            }
        }
    }

    // Delete User
    private func deleteUser() {
        viewModel.deleteUser(userId: user.id) { success in
            if success {
                presentationMode.wrappedValue.dismiss()
            }
        }
    }
}

// Date Formatter for displaying dates
extension DateFormatter {
    static let shortDate: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        formatter.timeStyle = .short
        return formatter
    }()
}
