import Foundation

protocol Route: Hashable {}

public enum AppRoute: Route {
  case home(HomeRoute)
  case login
  case tenatID
}

public enum HomeRoute: Route {
  case home
}

