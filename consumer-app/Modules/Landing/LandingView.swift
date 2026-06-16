//
//  LandingView.swift
//  consumer-app
//
//  Created by COMVIVA on 14/06/26.
//

import SwiftUI

struct LandingView: View {
    @State private var isLoading: Bool = false
    
    var body: some View {
        ZStack {
            Color(ColorConstants.surfacePrimary)
                .ignoresSafeArea(.all)
                .zIndex(0)
            VStack {
                Spacer()
                Image(ImageConstants.launchLogo)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 250, height: 120, alignment: .center)
                Spacer()
                VStack {
                    HStack {
                        Text("Welcome to")
                            .font(FontConstants.size24(.regular))
                            .foregroundStyle(ColorConstants.secondary)
                        Text("BlueMarble Retail")
                            .font(FontConstants.size24(.bold))
                            .foregroundStyle(ColorConstants.secondary)
                    }
                    PrimaryButton(title: "Login",
                                  isLoading: isLoading,
                                  variant: .secondary,
                                  action: {
                        isLoading = true
                        Task {
                            try? await Task.sleep(for: .seconds(2))
                            isLoading = false
                        }
                    })
                    
                    
                }
            }
            .zIndex(1)
        }
    }
}

#Preview {
    LandingView()
}
