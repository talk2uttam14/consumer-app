//
//  HomeView.swift
//  consumer-app
//
//  Created by UTTAM KUMAR DEY on 08/11/25.
//

import SwiftUI

struct HomeView: View {
    
    private let profileRouter = ProfileRouter()

    var body: some View {
        VStack {
            Button("Send ₹500") {
                profileRouter.openSettings()
            }
        }
    }
}
