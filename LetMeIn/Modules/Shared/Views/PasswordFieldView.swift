//
//  PasswordFieldView.swift
//  LetMeIn
//
//  Created by Mark Kenneth Bayona on 9/3/25.
//

import SwiftUI

struct PasswordFieldView: View {
    @State private var showPassword: Bool = false
    @Binding var text: String
    let error: Error?

    var fieldView: some View {
        HStack {
            Image(systemName: "lock")
                .foregroundColor(.gray)

            Group {
                if showPassword {
                    TextField("Enter password", text: $text)
                } else {
                    SecureField("Enter password", text: $text)
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
        .padding()
        .background(Color(.systemGray6))
    }

    var body: some View {
        VStack {
            fieldView

            if let error {
                Text("\(error.localizedDescription)")
                    .foregroundStyle(.red)
                    .padding(.vertical, 10)
            }
        }
    }
}
