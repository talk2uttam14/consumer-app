//
//  HomeView.swift
//  consumer-app
//
//  Created by UTTAM KUMAR DEY on 08/11/25.
//

import SwiftUI

struct HomeView: View {
    @EnvironmentObject
    var appRouter: AppRouter
    var body: some View {
        VStack {
            PrimaryButton(title: "Primary Button", action: {
                dump(PrimaryButton.self)
                appRouter.pop()
            }, isLoading: false)
            .padding(30)
        }
    }
}

