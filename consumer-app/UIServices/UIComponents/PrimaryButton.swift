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
    var isSuccess: Bool = false
    
    var body: some View {
        Button(action: action) {
            HStack(spacing: 8) {
                if isLoading {
                    ProgressView()
                        .tint(.white)
                    Text("Processing...")
                        .font(.headline)
                } else if isSuccess {
                    Image(systemName: "checkmark.circle.fill")
                    Text("Success")
                        .font(.headline)
                } else {
                    Text(title)
                        .font(.headline)
                }
            }
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 12)
        .background(isSuccess ? Color.green : Color.blue)
        .foregroundColor(.white)
        .cornerRadius(8)
        .disabled(isLoading)
    }
}
#Preview {
    PrimaryButton(title: "Demo", action: {
        print("Demo")
    }, isLoading: true, isSuccess: false)
}
