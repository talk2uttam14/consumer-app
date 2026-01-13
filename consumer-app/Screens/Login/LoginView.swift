//
//  LoginView.swift
//  consumer-app
//
//  Created by UTTAM KUMAR DEY on 29/10/25.
//

import SwiftUI

struct LoginView: View {
    @EnvironmentObject var appRouter: AppRouter
    
    var body: some View {
        VStack(spacing: 20) {
            Text("Login")
                .font(.title)
            
            Button("Go to Profile") {
                appRouter.push(.profile(.settings))
            }
            .buttonStyle(.borderedProminent)
            
            Button("Dismiss") {
                appRouter.dismissSheet()
            }
            .buttonStyle(.bordered)
        }
        .padding()
    }
}

#Preview {
    LoginView()
        .environmentObject(AppRouter.shared)
}
