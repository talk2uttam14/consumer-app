import SwiftUI

struct LoginView: View {
  @Bindable var viewModel: LoginViewModel
  @Environment(AppRouter.self) private var router

  var body: some View {
    ZStack {
      Image(ImageConstants.loginBackground)
        .resizable()
        .scaledToFill()
        .ignoresSafeArea()

      ScrollView {
        VStack(spacing: SpacingConstants.xl) {
          Image(ImageConstants.launchLogo)
            .resizable()
            .scaledToFit()
            .frame(height: 72)
            .padding(.top, SpacingConstants.xl)

          VStack(spacing: SpacingConstants.xs) {
            Text("Sign in")
              .font(FontConstants.size24(.bold))
              .foregroundStyle(ColorConstants.surfacePrimary)
            Text("Enter your mobile number and PIN")
              .font(FontConstants.size14(.regular))
              .foregroundStyle(ColorConstants.surfacePrimary.opacity(0.85))
          }

          VStack(spacing: SpacingConstants.lg) {
            AppTextField(
              label: "Mobile number",
              text: $viewModel.mobile,
              keyboardType: .phonePad
            )
            AppTextField(label: "PIN", text: $viewModel.pin, isSecure: true)
          }

          PrimaryButton(
            title: "Continue",
            isLoading: viewModel.isLoading,
            action: { Task { await viewModel.login() } }
          )
          .padding(.top, SpacingConstants.sm)
        }
        .padding(.horizontal, SpacingConstants.xl)
        .padding(.bottom, SpacingConstants.xl)
      }
    }
    .navigationBarTitleDisplayMode(.inline)
    .onChange(of: viewModel.isLoggedIn) { _, loggedIn in
      guard loggedIn else { return }
      router.popToRoot()
      router.push(.home(.home))
    }
    .errorAlert(error: $viewModel.error) {
      Task { await viewModel.login() }
    }
  }
}

#Preview {
  NavigationStack {
    LoginView(viewModel: LoginViewModel())
      .environment(AppRouter.shared)
  }
}
