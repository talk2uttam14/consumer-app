import SwiftUI

struct RootRouterView: View {
  @State private var router = AppRouter.shared

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
    case .login:
        LoginView(viewModel: LoginViewModel())
    case .tenatID:
        TenantID()
    }
  }
}
