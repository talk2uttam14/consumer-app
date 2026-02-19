//
//  LoginMobileWithPinView.swift
//  consumer-app
//
//  Created by UTTAM KUMAR DEY on 12/02/26.
//

import SwiftUI

struct LoginMobileWithPinView: View {
    @Bindable var loginVM: LoginMobileWithPinViewModel
    var body: some View {
        ZStack {
            Image(ImageConstants.loginBG)
                .resizable()
                .scaledToFill()
                .ignoresSafeArea()
            Image(ImageConstants.loginBG)
                .resizable()
                .frame(width: 120, height: 80)
        }
    }
}

#Preview {
    LoginMobileWithPinView(loginVM: LoginMobileWithPinViewModel())
}
