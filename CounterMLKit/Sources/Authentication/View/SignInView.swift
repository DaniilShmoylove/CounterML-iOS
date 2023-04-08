//
//  SignInView.swift
//  
//
//  Created by Daniil Shmoylove on 08.04.2023.
//

import SwiftUI
import CoreUI
import SharedModels

struct SignInView: View {
    
    //MARK: - Coordinator
    
    @StateObject private var coordinator = Coordinator()
    
    //MARK: - ViewModel
    
    @StateObject private var viewModel = AuthenticationViewModel()
    
    //MARK: - Focused field
    
    @FocusState private var focusedField: FocusedField?
    
    //MARK: - AuthenticationModel
    
    @State private var signCredential = SignCredential()
    
    var body: some View {
        NavigationStack(path: self.$coordinator.path) {
            ScrollView {
                VStack(alignment: .leading, spacing: 24) {
                    self.loginFields
                    self.signInWithGoogleButton
                }
                .padding()
            }
            .navigationTitle("Sign In")
            
            #if os(iOS)
            .navigationBarTitleDisplayMode(.large)
            #endif
            .navigationDestination(for: Route.self) { route in
                switch route {
                    
                    //MARK: - SignUp View
                    
                case .signUp: SignUpView()
                    
                    //MARK: - Support Authentication View
                    
                case .support: Text("Help")
                    
                    //MARK: - Terms of service View
                    
                case .terms: Text("Terms of service")
                }
            }
            
            .alert(
                .init("Authentication error"),
                isPresented: .constant(!self.viewModel.error.isEmpty)
            ) {
                Button("Ok") { self.viewModel.error.removeAll() }
            } message: {
                Text(self.viewModel.error)
            }
        }
        
        //MARK: - Environments
        
        .environmentObject(self.coordinator)
        .environmentObject(self.viewModel)
    }
}

//MARK: - Focused field

enum FocusedField: Hashable {
    case email, password
}

extension SignInView {
    private var registerMessage: AttributedString {
        var result = AttributedString("Don't have an account?")
        var prompt = AttributedString("Register")
        result.foregroundColor = .secondary
        prompt.foregroundColor = .accentColor
        return result + " " +  prompt
    }
    
    private var signInWithGoogleButton: some View {
        VStack(spacing: 18) {
            Button {
                self.viewModel.createGoogleCredential()
            } label: {
                HStack {
                    Image("google_icon")
                        .resizable()
                        .renderingMode(.template)
                        .frame(width: 20, height: 20)
                    
                    Text("Continue with Google")
                        .font(.system(size: 16, weight: .medium, design: .rounded))
                }
            }
            .buttonStyle(.largeBorder())
            
            NavigationLink(value: Route.signUp) {
                Text(self.registerMessage)
                    .font(.system(size: 14, weight: .regular, design: .rounded))
                    .multilineTextAlignment(.center)
            }
        }
        .bouncedAppearance(0.15)
        .disabled(self.viewModel.isCredentialLoading)
    }
    
    private var loginFields: some View {
        VStack(alignment: .leading, spacing: 18) {
            #if os(iOS)
            HStack {
                Image(systemName: "envelope")
                    .foregroundColor(.init(uiColor: .placeholderText))
                    .frame(width: 24)
                TextField("Email Adress", text: self.$signCredential.email)
                    .autocorrectionDisabled()
                    .focused(self.$focusedField, equals: .email)
                    .textContentType(.emailAddress)
                    .keyboardType(.emailAddress)
                    .submitLabel(.next)
                    .textInputAutocapitalization(.never)
                    .autocorrectionDisabled()
                    .onSubmit {
                        self.focusedField = .password
                    }

                CircleMarkView(self.signCredential.isValidEmail)
            }
            .padding(.horizontal, 24)
            .frame(height: 54)
            .background(Color(uiColor: .secondarySystemBackground))
            .cornerRadius(16)
            
            HStack {
                Image(systemName: "lock")
                    .foregroundColor(.init(uiColor: .placeholderText))
                    .frame(width: 24)
                SecureField("Password", text: self.$signCredential.password)
                    .focused(self.$focusedField, equals: .password)
                    .textContentType(.password)
                    .submitLabel(.continue)
                    .onSubmit {
                        guard self.signCredential.isValid else { return }
                        self.viewModel.signInWithEmail(credential: self.signCredential)
                    }
                
                CircleMarkView(self.signCredential.isValidPassword)
            }
            .padding(.horizontal, 24)
            .frame(height: 54)
            .background(Color(uiColor: .secondarySystemBackground))
            .cornerRadius(16)
            #endif
        }
        .font(.system(size: 16, weight: .medium, design: .rounded))
        .bouncedAppearance(0.3)
    }
}

#if DEBUG
struct SignInView_Previews: PreviewProvider {
    static var previews: some View {
        SignInView()
    }
}
#endif
