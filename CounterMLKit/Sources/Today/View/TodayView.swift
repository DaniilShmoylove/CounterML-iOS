//
//  TodayView.swift
//  
//
//  Created by Daniil Shmoylove on 08.04.2023.
//

import SwiftUI
import CoreUI
import SharedModels
import Services

public struct TodayView: View {
    public init() { }
    
    @StateObject private var viewModel = SummaryViewModel()
    @StateObject private var coordinator = Coordinator()
    
    @State private var text: String = .init()
    
    public var body: some View {
        NavigationStack(path: self.$coordinator.path) {
            List {
                
                //MARK: - Fetch request view
                
                FetchRequestView(
                    withFetchRequest: MealEntity.fetch()
                ) { result in
                    
                    //MARK: - Summary chart view
                    
                    Section {
                        SummaryChartView()
                    } header: {
                        SectionHeaderView("Dashboard")
                    }
                    
                    //MARK: - Content
                    
                    Section {
                        ForEach(
                            Array(result.enumerated()),
                            id: \.offset
                        ) { (index, item) in
                            NavigationLink(
                                value: Route.mealNote(
                                    item.asModel
                                )
                            ) {
                                MealCellView(
                                    data: item.asModel,
                                    index: index
                                )
                            }
                            
                            .contextMenu {
                                Text("See more")
                                
                                Label(
                                    "Use to create new",
                                    systemImage: "square.and.pencil"
                                )
                                
                                Label(
                                    "Add to favourite",
                                    systemImage: "heart"
                                )
                                
                                Label(
                                    "Duplicate",
                                    systemImage: "plus.square.on.square"
                                )
                                
                                Section {
                                    Button(role: .destructive) {
                                        
                                    } label: {
                                        Label(
                                            "Delete",
                                            systemImage: "trash"
                                        )
                                    }
                                }
                            }
                        }
                        
                        //MARK: - On delete
                        
                        .onDelete { indexSet in
                            for index in indexSet {
                                let item = result[index]
                                self.viewModel.delete(item)
                            }
                        }
                    } header: {
                        if !result.isEmpty {
                            SectionHeaderView("Meals")
                        }
                    }
                }
            }
            .scrollIndicators(.hidden)
            .navigationTitle("Summary")
            
            //MARK: - Toolbar
            
            .toolbar {
                ToolbarItem(placement: .primaryAction) {
                    Menu {
                        Button {
                            self.coordinator.path.append(.addItem)
                        } label: {
                            Label(
                                "Add meal",
                                systemImage: "square.and.pencil"
                            )
                        }
                        
                        Button {
                            self.coordinator.path.append(.classificationCamera)
                        } label: {
                            Label(
                                "Scan meal",
                                systemImage: "camera.viewfinder"
                            )
                        }
                    } label: {
                        Image(systemName: "plus")
                    } primaryAction: {
//                        self.coordinator.path.append(.mealNote)
                        self.viewModel.addMock()
                    }
                }
                
//                ToolbarItem(placement: .cancellationAction) {
//                    Button {
//                        
//                    } label: {
//                        Text("Out")
//                    }
//                }
            }
            
            //MARK: - Navigations
            
            .navigationDestination(for: Route.self) { route in
                switch route {
                case .mealNote: Text("Add item")
                case .classificationCamera: Text("Camera")
                case .classificationNote: Text("Classification")
                case .addItem: Text("Add item")
                }
            }
            
            //MARK: - Search bar
            
            .searchable(text: self.$text)
            
            //MARK: - Refresh
            
            .refreshable { self.viewModel.refresh() }
        }
        
//#if os(iOS)
//        .tint(self.coordinator.path.last == .addItem ? .white : .accentColor)
        //        .statusBarHidden(self.coordinator.path.last == .addItem)
//        .animation(.default, value: self.coordinator.path.last == .addItem)
//#endif
        
        //MARK: - Environments
        
        .environmentObject(self.coordinator)
    }
}

#if DEBUG
struct TodayView_Previews: PreviewProvider {
    static var previews: some View {
        TodayView()
    }
}
#endif
