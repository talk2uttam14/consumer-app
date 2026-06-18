import SwiftUI

struct AppTextField: View {

  let label: String
  @Binding var text: String
  var isSecure = false
  var keyboardType: UIKeyboardType = .default

  var body: some View {
    VStack(alignment: .leading, spacing: SpacingConstants.xs) {
      Text(label)
        .font(FontConstants.size14(.medium))
        .foregroundStyle(ColorConstants.textSecondary)

      Group {
        if isSecure {
          SecureField("", text: $text)
        } else {
          TextField("", text: $text)
            .keyboardType(keyboardType)
        }
      }
      .font(FontConstants.size16(.regular))
      .foregroundStyle(ColorConstants.textPrimary)
      .padding(.horizontal, SpacingConstants.lg)
      .padding(.vertical, SpacingConstants.md)
      .background(ColorConstants.surfacePrimary)
      .clipShape(RoundedRectangle(cornerRadius: RadiusConstants.sm, style: .continuous))
    }
  }
}
