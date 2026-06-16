//
//  PrimaryButton.swift
//  consumer-app
//
//  Created by UTTAM KUMAR DEY on 09/01/26.
//

import SwiftUI

struct PrimaryButton: View {

    // MARK: - Inputs
    let title: String
    
    var isLoading: Bool = false
    var isDisabled: Bool = false

    var variant: ButtonVariant = .primary
    
    private var backgroundColor: Color {
        variant.backgroundColor.opacity(
            (isLoading || isDisabled) ? 0.6 : 1.0
        )
    }

    private var foregroundColor: Color {
        variant.foregroundColor.opacity(
            (isLoading || isDisabled) ? 0.8 : 1.0
        )
    }

    var padding: EdgeInsets = EdgeInsets(
            top: 16,
            leading: 16,
            bottom: 16,
            trailing: 16
        )

    // MARK: - Style Config
    var height: CGFloat = 52
    var cornerRadius: CGFloat = 12
    let action: () -> Void

    // MARK: - Body
    var body: some View {
        Button(action: {
            guard !isLoading else { return }
            UIImpactFeedbackGenerator(style: .medium)
                .impactOccurred()
            action()
        })
        {
            ZStack {
                Text(title)
                    .opacity(isLoading ? 0 : 1)
                    .font(FontConstants.size18(.semiBold))
                if isLoading {
                    ProgressView()
                        .progressViewStyle(.circular)
                        .tint(foregroundColor)
                }
            }
            .frame(maxWidth: .infinity)
            .frame(height: height)
            .background(backgroundColor)
            .foregroundColor(foregroundColor)
            .clipShape(
                RoundedRectangle(
                    cornerRadius: cornerRadius,
                    style: .continuous
                )
            )
            .scaleEffect(1.0)
            .animation(.easeInOut(duration: 0.15), value: isLoading || isDisabled)
        }
        .disabled(isLoading || isDisabled)
        .buttonStyle(PrimaryButtonPressStyle())
        .accessibilityLabel(Text(title))
        .padding(padding)
    }
}
struct PrimaryButtonPressStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .scaleEffect(configuration.isPressed ? 0.95 : 1)
            .animation(.easeInOut(duration: 0.15),
                       value: configuration.isPressed)
    }
}
public enum ButtonVariant {
    case primary
    case secondary
    case destructive
    case warning
    case success

    var backgroundColor: Color {
        switch self {
        case .primary:
            return ColorConstants.surfacePrimary
        case .secondary:
            return ColorConstants.secondary
        case .destructive:
            return ColorConstants.error
        case .warning:
            return ColorConstants.warning
        case .success:
            return ColorConstants.success
        }
    }

    var foregroundColor: Color {
        switch self {
        case .primary:
            return ColorConstants.secondary
        case .secondary:
            return ColorConstants.surfacePrimary
        case .destructive:
            return ColorConstants.secondary
        case .warning:
            return ColorConstants.secondary
        case .success:
            return ColorConstants.secondary
        }
    }
}
