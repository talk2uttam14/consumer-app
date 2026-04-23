//
//  ErrorAlert.swift
//  consumer-app
//
//  Reusable error alert component for displaying API errors
//

import SwiftUI

// MARK: - Error Alert Modifier
struct ErrorAlertModifier: ViewModifier {
    @Binding var error: AppError?
    var onDismiss: (() -> Void)?
    var onRetry: (() -> Void)?
    
    func body(content: Content) -> some View {
        content
            .alert(
                "Error",
                isPresented: .constant(error != nil),
                presenting: error
            ) { presentedError in
                // Primary action button
                Button("OK") {
                    onDismiss?()
                    error = nil
                }
                
                // Retry button for network errors
                if shouldShowRetry(for: presentedError) {
                    Button("Retry") {
                        error = nil
                        onRetry?()
                    }
                }
            } message: { presentedError in
                VStack(alignment: .leading, spacing: 8) {
                    Text(presentedError.userMessage)
                    
                    // Show error code for debugging (can be removed in production)
                    #if DEBUG
                    Text("Error Code: \(presentedError.errorCode)")
                        .font(.caption)
                        .foregroundColor(.secondary)
                    #endif
                }
            }
    }
    
    private func shouldShowRetry(for error: AppError) -> Bool {
        switch error {
        case .network(.noInternetConnection), .network(.timeout), .network(.serverError):
            return onRetry != nil
        default:
            return false
        }
    }
}

// MARK: - View Extension
extension View {
    /// Shows an error alert with optional retry functionality
    /// - Parameters:
    ///   - error: Binding to optional AppError
    ///   - onDismiss: Optional closure called when alert is dismissed
    ///   - onRetry: Optional closure called when retry button is tapped
    func errorAlert(
        error: Binding<AppError?>,
        onDismiss: (() -> Void)? = nil,
        onRetry: (() -> Void)? = nil
    ) -> some View {
        modifier(ErrorAlertModifier(error: error, onDismiss: onDismiss, onRetry: onRetry))
    }
}

// MARK: - Custom Error Alert View (Alternative Implementation)
/// A more customizable error popup that can be used as a sheet or overlay
struct ErrorAlertView: View {
    let error: AppError
    let onDismiss: () -> Void
    let onRetry: (() -> Void)?
    
    @State private var isAnimating = false
    
    var body: some View {
        VStack(spacing: 0) {
            // Error Icon
            errorIcon
                .padding(.top, 24)
            
            // Error Title
            Text("Oops!")
                .font(.title2)
                .fontWeight(.bold)
                .padding(.top, 16)
            
            // Error Code
            Text("Error Code: \(error.errorCode)")
                .font(.caption)
                .foregroundColor(.secondary)
                .padding(.top, 4)
            
            // Error Message
            Text(error.userMessage)
                .font(.body)
                .multilineTextAlignment(.center)
                .foregroundColor(.secondary)
                .padding(.horizontal, 24)
                .padding(.top, 12)
            
            // Action Buttons
            VStack(spacing: 12) {
                if let onRetry = onRetry, shouldShowRetry {
                    Button(action: {
                        onRetry()
                    }) {
                        Text("Retry")
                            .font(.headline)
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 14)
                            .background(Color.blue)
                            .cornerRadius(12)
                    }
                }
                
                Button(action: onDismiss) {
                    Text(onRetry != nil && shouldShowRetry ? "Cancel" : "OK")
                        .font(.headline)
                        .foregroundColor(.primary)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 14)
                        .background(Color.gray.opacity(0.2))
                        .cornerRadius(12)
                }
            }
            .padding(.horizontal, 24)
            .padding(.top, 24)
            .padding(.bottom, 24)
        }
        .frame(maxWidth: 340)
        .background(Color(.systemBackground))
        .cornerRadius(20)
        .shadow(color: .black.opacity(0.2), radius: 20, x: 0, y: 10)
        .scaleEffect(isAnimating ? 1.0 : 0.8)
        .opacity(isAnimating ? 1.0 : 0)
        .onAppear {
            withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                isAnimating = true
            }
        }
    }
    
    private var errorIcon: some View {
        ZStack {
            Circle()
                .fill(severityColor.opacity(0.2))
                .frame(width: 80, height: 80)
            
            Image(systemName: severityIconName)
                .font(.system(size: 40))
                .foregroundColor(severityColor)
        }
    }
    
    private var severityColor: Color {
        switch error.severity {
        case .low:
            return .yellow
        case .medium:
            return .orange
        case .high, .critical:
            return .red
        }
    }
    
    private var severityIconName: String {
        switch error.severity {
        case .low:
            return "exclamationmark.circle.fill"
        case .medium:
            return "exclamationmark.triangle.fill"
        case .high, .critical:
            return "xmark.circle.fill"
        }
    }
    
    private var shouldShowRetry: Bool {
        switch error {
        case .network(.noInternetConnection), .network(.timeout), .network(.serverError):
            return true
        default:
            return false
        }
    }
}

// MARK: - Custom Error Alert Modifier
struct CustomErrorAlertModifier: ViewModifier {
    @Binding var error: AppError?
    var onRetry: (() -> Void)?
    
    func body(content: Content) -> some View {
        ZStack {
            content
            
            if let error = error {
                Color.black.opacity(0.4)
                    .ignoresSafeArea()
                    .transition(.opacity)
                
                ErrorAlertView(
                    error: error,
                    onDismiss: {
                        withAnimation {
                            self.error = nil
                        }
                    },
                    onRetry: onRetry
                )
                .transition(.scale.combined(with: .opacity))
            }
        }
        .animation(.spring(response: 0.3, dampingFraction: 0.7), value: error != nil)
    }
}

// MARK: - Custom Error Alert Extension
extension View {
    /// Shows a custom styled error popup overlay
    /// - Parameters:
    ///   - error: Binding to optional AppError
    ///   - onRetry: Optional closure called when retry button is tapped
    func customErrorAlert(
        error: Binding<AppError?>,
        onRetry: (() -> Void)? = nil
    ) -> some View {
        modifier(CustomErrorAlertModifier(error: error, onRetry: onRetry))
    }
}
