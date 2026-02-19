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
        }
    }
}

#Preview {
    LoginWithPinView(loginVM: LoginMobileWithPinViewModel())
}
