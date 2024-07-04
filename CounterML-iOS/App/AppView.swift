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
import Debug 

struct AppView: View {
    init() { }
    
    @StateObject private var sessionListener = SessionListener()
    
#if DEBUG
    @State private var isDebugShown: Bool = false
#endif
    
    var body: some View {
        Group {
            if self.sessionListener.isAuthenticated {
                
                /// User is signed in.
                
#if os(macOS)
                SidebarCounterView()
#else
                self.tabView
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
        
        //MARK: - Debug
        
#if DEBUG
        
        .onTapGesture(count: 4) {
            self.isDebugShown.toggle()
        }
        
        .sheet(isPresented: self.$isDebugShown) {
            DebugView()
        }
        
#endif
        
        .animation(.default, value: Auth.auth().currentUser == nil)
        
        .onAppear { self.sessionListener.startListener() }
    }
    
    private var tabView: some View {
        TabView {
            CounterView()
                .tabItem {
                    Label("Today", systemImage: "calendar")
                }
        }
    }
}


#if DEBUG
struct AppView_Previews: PreviewProvider {
    static var previews: some View {
        AppView()
    }
}
#endif
