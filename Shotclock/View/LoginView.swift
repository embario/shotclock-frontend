//
//  LoginView.swift
//  Shotclock
//
//  Created by Mario Barrenechea on 9/8/22.
//

import SwiftUI

struct LoginView: View {
    @EnvironmentObject var appViewModel: AppViewModel
    @StateObject private var viewModel: LoginViewModel

    init(appViewModel: AppViewModel){
        _viewModel = StateObject(wrappedValue: LoginViewModel(appViewModel: appViewModel))
    }
    
    var body: some View {
        GeometryReader { geometry in
            ScrollView {
                VStack {
                    Spacer(minLength: geometry.size.height * 0.2) // Push content down

                    VStack(alignment: .center, spacing: 10) {
                        Text("Login")
                            .font(.system(.title, design: .rounded))
                            .fontWeight(.medium)

                        if let errorMessage = viewModel.errorMessage {
                            Text(errorMessage)
                                .foregroundColor(.red)
                                .font(.caption)
                                .multilineTextAlignment(.center)
                        }

                        TextField("Username", text: $viewModel.email)
                            .padding(12)
                            .background(Capsule().stroke(Color.accentColor))
                            .cornerRadius(12)
                            .textInputAutocapitalization(.never)
                            .disableAutocorrection(true)

                        SecureField("Password", text: $viewModel.password)
                            .padding(12)
                            .background(Capsule().stroke(Color.accentColor))
                            .cornerRadius(12)
                            .textInputAutocapitalization(.never)
                            .disableAutocorrection(true)

                        Button(action: {
                            viewModel.login()
                        }) {
                            Text("Sign in")
                                .padding(12)
                        }
                        .frame(minWidth: 150, minHeight: 50)
                        .foregroundColor(Color.black)
                        .background(Capsule().stroke(Color.accentColor))
                    }
                    .padding(25)

                    Spacer() // Fill remaining space below
                }
                .frame(minHeight: geometry.size.height)
            }
            .ignoresSafeArea(.keyboard, edges: .bottom)
        }
    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView(appViewModel: AppViewModel())
    }
}
