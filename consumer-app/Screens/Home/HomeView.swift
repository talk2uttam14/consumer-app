//
//  HomeView.swift
//  consumer-app
//
//  Created by UTTAM KUMAR DEY on 08/11/25.
//

import SwiftUI

struct HomeView: View {
    @Environment(AppRouter.self) var appRouter
    @Bindable var viewModel: HomeViewModel
    @State private var loadTask: Task<Void, Never>?
    var body: some View {
        VStack {
            PrimaryButton(title: "Primary Button", action: {
            loadTask = Task {
                    await viewModel.loadLanguages()
                }
//                appRouter.pop()
            }, isLoading: viewModel.isLoading)
            .padding(30)
        }
        .errorAlert(error: $viewModel.error, onRetry:  {
            Task {
                await viewModel.loadLanguages()
            }
        }
        
    )
        .onDisappear {
            loadTask?.cancel()
        }
    }
}

