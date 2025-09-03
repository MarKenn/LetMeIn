//
//  ContentView.swift
//  LetMeIn
//
//  Created by Mark Kenneth Bayona on 1/28/25.
//

import SwiftUI

struct HomeView: View {
    @Environment(UserSession.self) private var userSession

    @State private var viewModel: HomeViewModel = Model()
    @State private var isDeleting: Bool = false

    var content: String {
        isDeleting
        ? "If you are sure about this, please confirm by typing your password in the textfield below, and then tapping the 'Leave forever' button."
        : "Welcome, \(userSession.user?.username ?? "guest")!"
    }

    var firstButtonTitle: String {
        isDeleting ? "Cancel" : "Let me go"
    }

    var body: some View {
        VStack(spacing: 20) {
            Spacer()

            Group {
                if isDeleting {
                    Text("YOU ARE DELETING YOUR ACCOUNT.\nTHIS CANNOT BE UNDONE.")
                        .fontWeight(.bold)
                        .foregroundStyle(.pink)
                }
                Text(content)
            }
            .multilineTextAlignment(.center)

            if isDeleting {
                PasswordFieldView(text: $viewModel.password, error: viewModel.error)
            }

            Spacer()

            Group {
                BasicButtonView(
                    text: firstButtonTitle,
                    foregroundColor: .white,
                    backgroundColor: Color(uiColor: .lightGray),
                    action: logoutAction
                )

                BasicButtonView(text: "Leave forever", foregroundColor: .white, backgroundColor: .pink) {
                    deleteAccountAction()
                }
            }
            .cornerRadius(10)
        }
        .padding()
        .onChange(of: viewModel.password) { viewModel.resetError() }
    }
}

extension HomeView {
    func logoutAction() {
        guard isDeleting else { return userSession.logout() }

        resetAccountDeletion()
    }

    func resetAccountDeletion() {
        viewModel.resetAccountDeletion()
        isDeleting = false
    }

    func deleteAccountAction() {
        guard isDeleting else { return isDeleting.toggle() }

        Task {
            if let user = userSession.user, await viewModel.delete(user: user) {
                userSession.logout()
            }
        }
    }
}

#Preview {
    @Previewable @State var userSession = UserSession()
    
    HomeView().environment(userSession)
}
