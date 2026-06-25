import SwiftUI

struct TenantID: View {
  @State private var form = PrimaryTextFieldForm()
  @State private var isChecked = true
  @State private var isTenantFocused = false
  @State private var showLoginScreen = false
  @Environment(AppRouter.self) private var router

  var body: some View {
    VStack {
      Spacer().frame(height: isTenantFocused ? 20 : nil)

      Image(ImageConstants.launchLogo)
        .resizable()
        .scaledToFit()
        .frame(width: isTenantFocused ? 200 : 250, height: isTenantFocused ? 100 : 70)
        .animation(.easeInOut(duration: 0.25), value: isTenantFocused)

      Spacer().frame(height: isTenantFocused ? 20 : nil)

      VStack(alignment: .leading, spacing: 20) {
        HStack {
          Spacer()
          Text("Tenant ID")
            .font(FontConstants.size18(.medium))
            .foregroundStyle(ColorConstants.primary)
          Spacer()
        }

        PrimaryTextField(
          key: "tenantId",
          form: form,
          placeholder: "Tenant ID",
          regex: "^[A-Za-z0-9 _-]{3,30}$",
          errorMessage: "Enter a valid tenant ID",
          keyboardType: .asciiCapable,
          textInputAutocapitalization: .never,
          autocorrectionDisabled: true,
          leftIcon: "person.fill",
          leftIconColor: ColorConstants.primary,
          onTap: {
              print("Do nothing")
          }
        )

        Text("Enter your registered tenat id")
          .font(FontConstants.size16())
          .foregroundStyle(ColorConstants.primary)

        PrimaryCheckBox(
          isChecked: $isChecked,
          leadingText: "I agree to the",
          linkText: "Terms & Privacy Statement",
          trailingText: ".",
          onLinkTapped: { print("hyper text clicked") }
        )

        PrimaryButton(title: "Continue", isDisabled: !isChecked) {
            router.push(.login)
        }
        .padding(.bottom, 25)
      }
      .padding(24)
      .background(Color.white)
      .clipShape(RoundedRectangle(cornerRadius: 24))
      .shadow(radius: 10)
    }
    .frame(maxWidth: .infinity, maxHeight: .infinity)
    .background(ColorConstants.surfacePrimary)
    .ignoresSafeArea()
    .navigationBarBackButtonHidden()
    .task { form["tenantId"] = "SND Tenant" }
  }
}

#Preview {
  TenantID()
}
