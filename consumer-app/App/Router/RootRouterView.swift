import SwiftUI

struct RootRouterView: View {
  @State private var router = AppRouter.shared
  @State private var loginViewModel = LoginViewModel()

  var body: some View {
    NavigationStack(path: $router.path) {
      LandingView()
        .navigationDestination(for: AppRoute.self, destination: destination)
    }
    .environment(router)
  }

  @ViewBuilder
  private func destination(for route: AppRoute) -> some View {
    switch route {
    case .home(let homeRoute):
      switch homeRoute {
      case .home:
        HomeView(viewModel: HomeViewModel())
      }
    case .login(let loginRoute):
      switch loginRoute {
      case .mobileAndPin:
        LoginView(viewModel: loginViewModel)
      }
    }
  }
}
