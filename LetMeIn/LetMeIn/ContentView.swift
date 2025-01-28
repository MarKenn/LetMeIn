//
//  ContentView.swift
//  LetMeIn
//
//  Created by Mark Kenneth Bayona on 1/28/25.
//

import SwiftUI

struct ContentView: View {
    @Environment(UserSession.self) private var userSession

    var body: some View {
        VStack {
            Text("Welcome, world!")

            Button(action: {
                userSession.logout()
            }) {
                Text("Let Me Go")
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .frame(height: 60)
                    .background(.pink)
            }
        }
        .padding()
    }
}

#Preview {
    ContentView()
}
