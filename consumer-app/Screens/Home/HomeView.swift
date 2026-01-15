//
//  HomeView.swift
//  consumer-app
//
//  Created by UTTAM KUMAR DEY on 08/11/25.
//

import SwiftUI

struct HomeView: View {
    @Environment(AppRouter.self) var appRouter
    @State var viewModel: HomeViewModel
    var body: some View {
        VStack {
            PrimaryButton(title: "Primary Button", action: {
                viewModel.loadLanguages()
                appRouter.pop()
            }, isLoading: false)
            .padding(30)
        }
    }
}

