//
//  LoginMobileView.swift
//  consumer-app
//
//  Created by UTTAM KUMAR DEY on 12/02/26.
//

import SwiftUI

struct LoginWithPinView: View {
    @Bindable var loginVM: LoginMobileWithPinViewModel
    
    var body: some View {
        ZStack {
            Image(ImageConstants.loginBG)
                .resizable()
                .scaledToFill()
                .ignoresSafeArea()
            ScrollView {
                VStack {
                    Text("Login")
                        .font(.largeTitle)
                        .fontWeight(.semibold)
                        .foregroundColor(.white)
                        .padding()
                    
                    Text(loginVM.userData?.name ?? "Loading...")
                        .font(.largeTitle)
                        .fontWeight(.semibold)
                        .foregroundColor(.white)
                        .padding()
                    Text(loginVM.userData?.bio ?? "Loading...")
                        .font(.largeTitle)
                        .fontWeight(.semibold)
                        .foregroundColor(.white)
                        .padding()
                    if let language = loginVM.language {
                        ForEach(language.languageList) { item in
                            VStack(alignment: .leading, spacing: 8) {
                                Text(item.question)
                                    .font(.headline)
                                
                                Text(item.answers)
                                    .font(.subheadline)
                            }
                            .padding()
                            .background(Color.white.opacity(0.1))
                            .cornerRadius(10)
                        }
                    }
                }
            }
        }
        .task {
            async let userTask = loginVM.getUserData()
            async let languageTask = loginVM.fetchLanguage()
            await userTask
            await languageTask
        }
        
    }
}

#Preview {
    LoginWithPinView(loginVM: LoginMobileWithPinViewModel())
}
