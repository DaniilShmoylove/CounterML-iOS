//
//  AppView.swift
//  CounterML-iOS
//
//  Created by Daniil Shmoylove on 03.03.2023.
//

import SwiftUI
import FirebaseAuth
import Authentication
import CounterMLKit
import Helpers

struct AppView: View {
    init() { }
    
    @StateObject private var sessionListener = SessionListener()
    
    var body: some View {
        Group {
            if self.sessionListener.isAuthenticated {

                /// User is signed in.

    #if os(macOS)
                SidebarCounterView()
    #else
                CounterView()
                    .overlay {
                        Button("Sign out") {
                            do {
                                try Auth.auth().signOut()
                            } catch {
                                
                            }
                        }
                    }
    #endif
            } else {

                /// No user is signed in.

                AuthenticationView()
                    .transition(.push(from: .bottom))
            }
        }
        .animation(.default, value: Auth.auth().currentUser == nil)
        
        .onAppear { self.sessionListener.startListener() }
    }
}


#if DEBUG
struct AppView_Previews: PreviewProvider {
    static var previews: some View {
        AppView()
    }
}
#endif 
