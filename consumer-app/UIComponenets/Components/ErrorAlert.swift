import SwiftUI

struct ErrorAlertModifier: ViewModifier {
  @Binding var error: AppError?
  var onRetry: (() -> Void)?

  func body(content: Content) -> some View {
    content
      .alert(
        "Something went wrong",
        isPresented: Binding(
          get: { error != nil },
          set: { if !$0 { error = nil } }
        ),
        presenting: error
      ) { presentedError in
        if let onRetry, shouldShowRetry(for: presentedError) {
          Button("Try again", action: onRetry)
        }
        Button("OK", role: .cancel) {
          error = nil
        }
      } message: { presentedError in
        Text(presentedError.userMessage)
      }
  }

  private func shouldShowRetry(for error: AppError) -> Bool {
    switch error {
    case .network(.noInternetConnection), .network(.timeout), .network(.serverError):
      return true
    default:
      return false
    }
  }
}

extension View {
  func errorAlert(
    error: Binding<AppError?>,
    onRetry: (() -> Void)? = nil
  ) -> some View {
    modifier(ErrorAlertModifier(error: error, onRetry: onRetry))
  }
}
