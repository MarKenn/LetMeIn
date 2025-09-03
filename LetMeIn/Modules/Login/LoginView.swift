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

    var mainBtnTitle: String { isSignup ? "Sign me up" : "Let me in" }
    var mainBtnBackgroundColor: Color { isSignup ? .blue : .mint }
    var secondaryBtnTitle: String { isSignup ? "Have an existing account?" : "Create new account?" }
    var secondaryBtnForegroundColor: Color { isSignup ? .mint : .blue }

    var usernameFieldView: some View {
        HStack {
            Image(systemName: "person")
                .foregroundColor(.gray)

            TextField("Enter username", text: $viewModel.username)
                .padding(.leading, 5)
        }
        .padding()
        .background(Color(.systemGray6))
    }

    var body: some View {
        VStack {
            VStack {
                usernameFieldView

                PasswordFieldView(text: $viewModel.password)

                if let error = viewModel.error {
                    Text("\(error.localizedDescription)")
                        .foregroundStyle(.red)
                        .padding(.vertical, 10)
                }

                BasicButtonView(
                    text: mainBtnTitle,
                    foregroundColor: .white,
                    backgroundColor: mainBtnBackgroundColor,
                    action: mainButtonAction
                )
            }
            .cornerRadius(10)
            .padding(.horizontal, 20)

            BasicButtonView(
                text: secondaryBtnTitle,
                foregroundColor: secondaryBtnForegroundColor,
                backgroundColor: .clear,
                action: { isSignup.toggle() }
            )
        }
        .onChange(of: viewModel.username) { viewModel.resetError() }
        .onChange(of: viewModel.password) { viewModel.resetError() }
        .onChange(of: isSignup) { viewModel.resetError() }
        .onAppear {
            viewModel.didLogin = { authenticatedUser in

                hideKeyBoard()
                self.userSession.login(authenticatedUser)
            }
        }
    }
}

extension LoginView {
    func mainButtonAction() {
        Task {
            await isSignup ? viewModel.register() : viewModel.login()
        }
    }
}

#Preview {
    @Previewable @State var userSession = UserSession()

    LoginView().environment(userSession)
}
