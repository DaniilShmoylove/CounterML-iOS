//
//  SignUpView.swift
//  
//
//  Created by Daniil Shmoylove on 02.03.2023.
//

import SwiftUI
import CoreUI
import SharedModels

struct SignUpView: View {
    
    //MARK: - ViewModel
    
    @EnvironmentObject private var viewModel: AuthenticationViewModel
    
    //MARK: - Focused field
    
    @FocusState private var focusedField: FocusedField?
    
    //MARK: - AuthenticationModel
    
    @State private var signCredential = SignCredential()
    
    var body: some View {
        ScrollView {
            VStack(spacing: 24) {
                self.loginFields
                self.signInWithGoogleButton
            }
            .navigationTitle("Sign Up")
            .navigationBarTitleDisplayMode(.large)
            .animation(.easeIn(duration: 0.15), value: self.focusedField)
            .padding()
        }
    }
}

extension SignUpView {
    private var title: some View {
        Group {
            if self.focusedField == nil {
                VStack(spacing: .zero) {
                    Image("signup_promo_art")
                        .resizable()
                        .scaledToFit()
                    
                    Text("Sign up on Cheatty.")
                        .font(.system(size: 42, weight: .black, design: .rounded))
                        .multilineTextAlignment(.center)
                        .frame(height: 108)
                }
                .transition(.opacity)
            }
        }
        .bouncedAppearance(0.3)
    }
    
    private var loginFields: some View {
        VStack(spacing: 18) {
            HStack {
                Image(systemName: "envelope")
                    .foregroundColor(.init(uiColor: .placeholderText))
                    .frame(width: 20)
                TextField("Email Adress", text: self.$signCredential.email)
                    .autocorrectionDisabled()
                    .focused(self.$focusedField, equals: .email)
                    .textContentType(.emailAddress)
                    .keyboardType(.emailAddress)
                    .submitLabel(.next)
                    .textInputAutocapitalization(.never)
                    .autocorrectionDisabled()
                    .onSubmit { self.focusedField = .password }

                CircleMarkView(self.signCredential.isValidEmail)
            }
            .font(.system(size: 16, weight: .semibold, design: .rounded))
            .padding(.horizontal, 24)
            .frame(height: 54)
            .background(Color(uiColor: .secondarySystemBackground))
//            .clipShape(Capsule())
            .cornerRadius(15)
            
            HStack {
                Image(systemName: "lock")
                    .foregroundColor(.init(uiColor: .placeholderText))
                    .frame(width: 20)
                SecureField("Password", text: self.$signCredential.password)
                    .focused(self.$focusedField, equals: .password)
                    .textContentType(.newPassword)
                    .submitLabel(.continue)
                    .onSubmit { self.viewModel.signUp(credential: self.signCredential) }
//
                CircleMarkView(self.signCredential.isValidPassword)
            }
            .font(.system(size: 16, weight: .medium, design: .rounded))
            .padding(.horizontal, 24)
            .frame(height: 54)
            .background(Color(uiColor: .secondarySystemBackground))
//            .clipShape(Capsule())
            .cornerRadius(15)
        }
        .bouncedAppearance(0.3)
    }
    
    private var termsrMessage: AttributedString {
        var result = AttributedString("By creating an account, you are agreeting to our")
        var prompt = AttributedString("Terms of Service")
        result.foregroundColor = .secondary
        prompt.foregroundColor = .accentColor
        return result + " " +  prompt
    }
    
    private var signInWithGoogleButton: some View {
        VStack(spacing: 18) {
            Button("Continue") { self.viewModel.signUp(credential: self.signCredential) }
            .buttonStyle(.largeBorder())
            .font(.system(size: 16, weight: .medium, design: .rounded))
            .disabled(!self.signCredential.isValid)
            
            NavigationLink(value: Route.terms) {
                Text(self.termsrMessage)
                    .foregroundColor(.secondary)
                    .font(.system(size: 14, weight: .regular, design: .rounded))
                    .multilineTextAlignment(.center)
                    .frame(height: 34)
                    .padding(.horizontal)
            }
        }
        .bouncedAppearance(0.15)
    }
}

#if DEBUG
struct SignUpView_Previews: PreviewProvider {
    static var previews: some View {
        SignUpView()
    }
}
#endif
