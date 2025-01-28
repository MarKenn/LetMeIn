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
                Group {
                    HStack {
                        Image(systemName: "person")
                            .foregroundColor(.gray)

                        TextField("Enter username", text: $viewModel.username)
                            .padding(.leading, 5)
                    }

                    HStack {
                        Image(systemName: "lock")
                            .foregroundColor(.gray)

                        Group {
                            if showPassword {
                                TextField("Enter username", text: $viewModel.password)
                            } else {
                                SecureField("Enter password", text: $viewModel.password)
                            }
                        }
                        .padding(.leading, 5)

                        Button(
                            action: { showPassword.toggle() },
                            label: {
                                Image(systemName: showPassword ? "eye.slash" : "eye.fill")
                                    .foregroundColor(.gray)
                            }
                        )
                    }
                }
                .padding()
                .background(Color(.systemGray6))

                if let error = viewModel.error {
                    Text("\(error.localizedDescription)")
                        .foregroundStyle(.red)
                        .padding(.vertical, 10)
                }

                Button(action: {
                    if isSignup {
                        viewModel.requestSignup()
                    } else {
                        viewModel.requestLogin()
                    }
                }) {
                    Text( isSignup ? "Sign Me Up" : "Let Me In")
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
        .onChange(of: viewModel.username) { viewModel.error = nil }
        .onChange(of: viewModel.password) { viewModel.error = nil }
        .onChange(of: isSignup) { viewModel.error = nil }
        .onAppear {
            viewModel.didLogin = { authenticatedUser in

                hideKeyBoard()
                self.userSession.login(authenticatedUser)
            }
        }
    }
}

#Preview {
    @Previewable @State var userSession = UserSession()

    LoginView().environment(userSession)
}
