//
//  CheckBoxView.swift
//  consumer-app
//
//  Created by COMVIVA on 23/06/26.
//

import SwiftUI

struct PrimaryCheckBox: View {
    
    @Binding var isChecked: Bool
    
    let leadingText: String
    let linkText: String
    let trailingText: String
    
    let checkboxSize: CGFloat = 20
        
    var onLinkTapped: (() -> Void)?
    
    private var termsText: AttributedString {
        var text = AttributedString(
            "\(leadingText) \(linkText) \(trailingText)"
        )

        if let range = text.range(of: linkText) {
            text[range].foregroundColor = ColorConstants.surfaceSecondary
            text[range].link = URL(string: "app://terms")
        }

        return text
    }
    
    var body: some View {
        HStack(alignment: .center, spacing: 10) {
            
            Button {
                withAnimation(.spring(response: 0.25, dampingFraction: 0.8)) {
                    isChecked.toggle()
                }
            } label: {
                Image(systemName: isChecked
                      ? "checkmark.square.fill"
                      : "square")
                .font(.system(size: checkboxSize))
                .foregroundColor(ColorConstants.surfacePrimary)
            }
            .buttonStyle(.plain)
            
            Text(termsText)
                .font(FontConstants.size16())
                .foregroundColor(ColorConstants.primary)
                .environment(\.openURL, OpenURLAction(handler: { url in
                    if url.absoluteString == "app://terms" {
                        onLinkTapped?()
                        return .handled
                    }
                    return .systemAction
                }))
        }
    }
}

#Preview {
    PrimaryCheckBox(isChecked: .constant(true), leadingText: "I prefer", linkText: "to be", trailingText: "a hero")
}

