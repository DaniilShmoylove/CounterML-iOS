//
//  SidebarCounterView.swift
//  
//
//  Created by Daniil Shmoylove on 20.01.2023.
//

import SwiftUI
import CoreUI 

public struct SidebarCounterView: View {
    
    @State private var selectedSidebarItem: SidebarItems = .home
    
    public init() { }
    public var body: some View {
        HStack(spacing: .zero) {
            
            //MARK: - Sidebar
            
            SidebarView(
                content: [
                    .init(caption: "Home", imageString: "house"),
                    .init(caption: "Charts", imageString: "chart.pie"),
                    .init(caption: "Settings", imageString: "gearshape"),
                    .init(caption: "Notification", imageString: "bell"),
                    .init(caption: "Account", imageString: "person"),
                ],
                selected: self.$selectedSidebarItem
            )
            .listStyle(.sidebar)
            
            //MARK: - Content
            
            NavigationStack {
                ZStack {
                    switch self.selectedSidebarItem {
                    case .home: Text("Home")
                    case .stats: Text("Charts")
                    case .settings: Text("Settings")
                    case .notification: Text("Notification")
                    case .account: Text("Account")
                    }
                }
                .toolbar {
                    ToolbarItem(placement: .principal) {
                        Text("Home")
                            .fontWeight(.medium)
                    }
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
        
        //MARK: - MacOS window frame
        
        .frame(
            minWidth: 512,
            idealWidth: 768,
            maxWidth: .infinity,
            minHeight: 512,
            idealHeight: 640,
            maxHeight: .infinity,
            alignment: .leading
        )
    }
}

extension SidebarCounterView {
    
    //MARK: - Sidebar view
    
    private struct SidebarView: View {
        
        private let content: [SidebarItem]
        
        // Selected by index
        
        @Binding private var selected: SidebarItems
        
        @State private var isOnHoverItem: [Bool]
        
        init(
            content: [SidebarItem],
            selected: Binding<SidebarItems>
        ) {
            self._selected = selected
            self.content = content
            self.isOnHoverItem = Array(
                (0...content.count)
                    .map { _ in return false }
            )
        }
        
        var body: some View {
            VStack(spacing: .zero) {
                ForEach(
                    Array(
                        self.content.enumerated()),
                    id: \.offset
                ) { index, element in
                    Button {
                        self.selected = SidebarItems(rawValue: index) ?? .home
                    } label: {
                        HStack {
                            Image(systemName: self.selected.rawValue == index ? element.imageString + ".fill" : element.imageString)
                                .help(element.caption)
                            //TODO: - is full screen
                        }
                        .frame(height: 44)
                        .frame(maxWidth: .infinity)
#if canImport(AppKit)
                        .background(
                            self.selected == SidebarItems(rawValue: index) ?
                            Color(nsColor: .controlBackgroundColor).opacity(0.4)
                            : .gray.opacity(0.0001)
                        )
#endif
                        .font(.system(size: self.isOnHoverItem[index] ? 12 : 16))
                    }
                    .buttonStyle(.plain)
                    .accessibilityLabel(Text(element.caption))
                    
                    .onHover { isOnHover in
                        withAnimation(.easeIn(duration: 0.175)) {
                            self.isOnHoverItem[index] = isOnHover
                        }
                    }
                }
            }
            .fontWeight(.medium)
            .padding(.vertical, 10)
            .frame(width: 72)
            .frame(maxHeight: .infinity, alignment: .top)
            .sidebarBackground()
        }
    }
    
    //MARK: - Sidebar item
    
    private struct SidebarItem: Identifiable {
        
        // Identifiable
        
        var id: String { self.caption }
        
        // Сaption under the image
        
        let caption: String
        
        // Image name
        
        let imageString: String
    }
    
    //MARK: - Sidebar items enum
    
    private enum SidebarItems: Int, Hashable {
        case home, stats, settings, notification, account
    }
}

#if DEBUG
struct SidebarCounterView_Previews: PreviewProvider {
    static var previews: some View {
        SidebarCounterView()
    }
}
#endif
