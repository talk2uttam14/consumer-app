import SwiftUI

struct PrimaryButton: View {

  let title: String
  var isLoading = false
  var isDisabled = false
  var variant: ButtonVariant = .primary
  var height: CGFloat = 52
  let action: () -> Void

  private var backgroundColor: Color {
    variant.backgroundColor.opacity(isLoading || isDisabled ? 0.6 : 1)
  }

  private var foregroundColor: Color {
    variant.foregroundColor.opacity(isLoading || isDisabled ? 0.8 : 1)
  }

  var body: some View {
    Button {
      guard !isLoading, !isDisabled else { return }
      UIImpactFeedbackGenerator(style: .medium).impactOccurred()
      action()
    } label: {
      ZStack {
        Text(title)
          .opacity(isLoading ? 0 : 1)
          .font(FontConstants.size18(.semiBold))

        if isLoading {
          ProgressView()
            .tint(foregroundColor)
        }
      }
      .frame(maxWidth: .infinity)
      .frame(height: height)
      .foregroundStyle(foregroundColor)
      .background(backgroundColor)
      .clipShape(RoundedRectangle(cornerRadius: RadiusConstants.md, style: .continuous))
    }
    .disabled(isLoading || isDisabled)
    .buttonStyle(PrimaryButtonPressStyle())
    .accessibilityLabel(title)
  }
}

private struct PrimaryButtonPressStyle: ButtonStyle {
  func makeBody(configuration: Configuration) -> some View {
    configuration.label
      .scaleEffect(configuration.isPressed ? 0.97 : 1)
      .animation(.easeOut(duration: 0.12), value: configuration.isPressed)
  }
}

enum ButtonVariant {
  case primary
  case secondary
  case destructive
  case warning
  case success

  var backgroundColor: Color {
    switch self {
    case .primary: ColorConstants.surfacePrimary
    case .secondary: ColorConstants.secondary
    case .destructive: ColorConstants.error
    case .warning: ColorConstants.warning
    case .success: ColorConstants.success
    }
  }

  var foregroundColor: Color {
    switch self {
    case .primary: ColorConstants.secondary
    case .secondary, .destructive, .warning, .success: ColorConstants.surfacePrimary
    }
  }
}
