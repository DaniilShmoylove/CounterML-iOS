//
//  CounterView.swift
//  
//
//  Created by Daniil Shmoylove on 20.01.2023.
//

import SwiftUI
import CoreUI
import Today

public struct CounterView: View {
    public init() { }
    
    public var body: some View {
        TabView {
            
            TodayView()
                .tabItem {
                    Label("Today", systemImage: "calendar")
                }
            
//            Text("Weight")
//                .tabItem {
//                    Label("Weight", systemImage: "figure.stand")
//                }
            
            Text("Charts")
                .tabItem {
                    Label("Charts", systemImage: "chart.bar.fill")
                }
            
            Text("Settings")
                .tabItem {
                    Label("Settings", systemImage: "gearshape.fill")
                }
        }
    }
}

#if DEBUG
struct CounterView_Previews: PreviewProvider {
    static var previews: some View {
        CounterView()
    }
}
#endif
