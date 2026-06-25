import SwiftUI

struct LoginView: View {
    @State private var form = PrimaryTextFieldForm()
    @State private var isChecked = true
    @State private var isTenantFocused = false
    @State private var showTenantScreen = false
    @Environment(AppRouter.self) private var router
    @Bindable var viewModel: LoginViewModel

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
            Text("Log in")
              .font(FontConstants.size18(.medium))
              .foregroundStyle(ColorConstants.primary)
            Spacer()
          }

          PrimaryTextField(
            key: "userid",
            form: form,
            placeholder: "User ID",
            regex: "^[A-Za-z0-9 _-]{3,30}$",
            errorMessage: "Enter a valid user ID",
            keyboardType: .asciiCapable,
            textInputAutocapitalization: .never,
            autocorrectionDisabled: true,
            leftIcon: "person.fill",
            leftIconColor: ColorConstants.primary
          )
            PrimaryTextField(
              key: "password",
              form: form,
              placeholder: "Password",
              regex: "^[A-Za-z0-9 _-]{3,30}$",
              errorMessage: "Enter a valid password",
              isSecure: true,
              keyboardType: .asciiCapable,
              textInputAutocapitalization: .never,
              autocorrectionDisabled: true,
              leftIcon: "lock.fill",
              leftIconColor: ColorConstants.primary
            )
            HStack {
                Spacer()
                Text("Forgot Passowrd ?")
                    .font(FontConstants.size16(.medium))
                    .foregroundStyle(ColorConstants.surfacePrimary)
            }

          PrimaryButton(title: "Continue", isDisabled: !isChecked) {
            print(form["tenantId"])
              showTenantScreen = true
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
      .navigationDestination(isPresented: $showTenantScreen) {
                  PrimaryTextFieldShowcaseView()
              }
    }
  }

#Preview {
  NavigationStack {
    LoginView(viewModel: LoginViewModel())
      .environment(AppRouter.shared)
  }
}
