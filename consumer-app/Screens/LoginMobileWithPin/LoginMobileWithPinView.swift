//
//  LoginMobileWithPinView.swift
//  consumer-app
//
//  Created by UTTAM KUMAR DEY on 12/02/26.
//

import SwiftUI

struct LoginMobileWithPinView: View {
    @Bindable var loginVM: LoginMobileWithPinViewModel
    @State var mobileNumber: String = ""
    @State var pin: String = ""
    var body: some View {
        ZStack {
            Image(ImageConstants.loginBG)
                .resizable()
                .scaledToFill()
                .ignoresSafeArea()
            VStack {
                Image(ImageConstants.globalPayLogo)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 200, height: 80)
                Text("Welcome to Global Pay")
                    .font(.title3)
                    .fontWeight(.medium)
                    .foregroundColor(.white)
                Text("Login")
                    .font(.title)
                    .fontWeight(.semibold)
                    .foregroundColor(.white)
            }
            VStack {
                TextField(text: $mobileNumber) {
                    Text("Mobile number")
                }
                TextField(text: $pin) {
                    Text("Enter Pin")
                }
            }
                
        }
    }
    
}


#Preview {
    LoginMobileWithPinView(loginVM: LoginMobileWithPinViewModel())
}
