//
//  View+Extension.swift
//  LetMeIn
//
//  Created by Mark Kenneth Bayona on 1/29/25.
//

import SwiftUI

extension View {
    func hideKeyBoard() {
        DispatchQueue.main.async {
            UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
        }
    }
}
