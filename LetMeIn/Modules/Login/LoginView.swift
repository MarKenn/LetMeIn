//
//  LoginView.swift
//  LetMeIn
//
//  Created by Mark Kenneth Bayona on 1/28/25.
//

import SwiftUI

struct LoginView: View {
    @Environment(UserSession.self) private var userSession

    @State private var viewModel: LoginViewModel = Model()
    @State private var showPassword: Bool = false
    @State private var isSignup: Bool = false

    var body: some View {
        VStack {
            VStack {
                HStack {
                    Image(systemName: "person")
                        .foregroundColor(.gray)

                    TextField("Enter username", text: $viewModel.username)
                        .padding(.leading, 5)
                }
                .padding()
                .background(Color(.systemGray6))

                PasswordFieldView(text: $viewModel.password)

                if let error = viewModel.error {
                    Text("\(error.localizedDescription)")
                        .foregroundStyle(.red)
                        .padding(.vertical, 10)
                }

                Button(action: {
                    if isSignup {
                        register()
                    } else {
                        login()
                    }
                }) {
                    Text( isSignup ? "Sign me up" : "Let me in")
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .frame(height: 60)
                        .background(isSignup ? .blue : .mint)
                }
            }
            .cornerRadius(10)
            .padding(.horizontal, 20)

            Button(action: {
                isSignup.toggle()
            }) {
                Text( isSignup ? "Have an existing account?" : "Create new account?")
                    .fontWeight(.bold)
                    .foregroundColor(isSignup ? .mint : .blue)
                    .frame(maxWidth: .infinity)
                    .frame(height: 60)
            }
        }
        .onChange(of: viewModel.username) { resetError() }
        .onChange(of: viewModel.password) { resetError() }
        .onChange(of: isSignup) { resetError() }
        .onAppear {
            viewModel.didLogin = { authenticatedUser in

                hideKeyBoard()
                self.userSession.login(authenticatedUser)
            }
        }
    }
}

extension LoginView {
    func resetError() {
        guard viewModel.error != nil else { return }
        viewModel.error = nil
    }

    func register() {
        Task {
            await viewModel.register()
        }
    }

    func login() {
        Task {
            await viewModel.login()
        }
    }
}

#Preview {
    @Previewable @State var userSession = UserSession()

    LoginView().environment(userSession)
}
