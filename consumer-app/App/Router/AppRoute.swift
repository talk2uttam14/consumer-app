import Foundation

protocol Route: Hashable {}

public enum AppRoute: Route {
  case home(HomeRoute)
  case login(LoginRoute)
}

public enum HomeRoute: Route {
  case home
}

public enum LoginRoute: Route {
  case mobileAndPin
}
