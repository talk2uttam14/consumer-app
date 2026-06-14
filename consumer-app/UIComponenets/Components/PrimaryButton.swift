//
//  PrimaryButton.swift
//  consumer-app
//
//  Created by UTTAM KUMAR DEY on 09/01/26.
//

import SwiftUI

struct PrimaryButton: View {
    let title: String
    let action: () -> Void
    var isLoading: Bool = false

    var body: some View {
        Button(action: action) {
            HStack(spacing: 8) {
                if isLoading {
                    ProgressView().tint(.white)
                } else {
                    Text(title).font(.headline)
                }
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, 12)
            .background( isLoading ? Color.gray : Color.blue)
            .foregroundColor(.white)
            .cornerRadius(8)
            .contentShape(Rectangle())
        }
        .disabled(isLoading)
    }
}
#Preview {
    PrimaryButton(title: "Demo", action: {
        print("Demo")
    }, isLoading: true)
}
