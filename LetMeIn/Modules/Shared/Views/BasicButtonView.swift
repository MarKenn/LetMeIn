//
//  BasicButton.swift
//  LetMeIn
//
//  Created by Mark Kenneth Bayona on 9/3/25.
//

import SwiftUI

struct BasicButtonView: View {
    let text: String
    let foregroundColor: Color
    let backgroundColor: Color

    let action: () -> Void

    var body: some View {
        Button(action: action) {
            Text(text)
                .fontWeight(.bold)
                .foregroundColor(foregroundColor)
                .frame(maxWidth: .infinity)
                .frame(height: 60)
                .background(backgroundColor)
        }
    }
}
