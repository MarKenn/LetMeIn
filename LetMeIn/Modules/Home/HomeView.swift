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
    @State private var isDeleting: Bool = true
    @State private var showPassword: Bool = false

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
                    PasswordFieldView(text: $viewModel.password)

                    if let error = viewModel.error {
                        Text("\(error.localizedDescription)")
                            .foregroundStyle(.red)
                            .padding(.vertical, 10)
                    }
                }
            }

            Spacer()

            Button(action: {
                if isDeleting {
                    viewModel.user = nil
                    viewModel.password = ""
                    resetError()
                    isDeleting.toggle()
                } else {
                    userSession.logout()
                }
            }) {
                Text(firstButtonTitle)
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .frame(height: 60)
                    .background(Color(uiColor: .lightGray))
            }
            .cornerRadius(10)

            Button(action: {
                if isDeleting {
                    guard !viewModel.password.isEmpty else { return }
                    deleteUser()
                } else {
                    isDeleting.toggle()
                }
            }) {
                Text("Leave forever")
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .frame(height: 60)
                    .background(.pink)
            }
            .cornerRadius(10)
        }
        .padding()
        .onChange(of: viewModel.password) { resetError() }
    }
}

extension HomeView {
    func resetError() {
        guard viewModel.error != nil else { return }
        viewModel.error = nil
    }

    func deleteUser() {
        Task {
            viewModel.user = userSession.user
            if await viewModel.deleteAccount() {
                userSession.logout()
            }
        }
    }
}

#Preview {
    @Previewable @State var userSession = UserSession()
    
    HomeView().environment(userSession)
}
