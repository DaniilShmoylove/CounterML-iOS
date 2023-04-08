//
//  ClassifierView.swift
//  
//
//  Created by Daniil Shmoylove on 24.01.2023.
//

#if os(iOS)
import SwiftUI
import Core
import CoreUI
import Helpers
import SharedModels
import CoreData

//MARK: - ClassifierView

/// This is a view of the screen for adding and setting classification object data.
/// - Tag: ClassifierView
struct ClassifierView: View {
    
    //MARK: - ViewModel
    
    @State private var data: ClassificationModel
    
    //MARK: - Focused field
    
    @FocusState private var focusedField: FocusedField?
    
    //MARK: - Init
    
    init(data: ClassificationModel) {
        self._data = State(initialValue: data)
    }
    
    var body: some View {
        NavigationStack {
            List {
                
                /// Classifier Image
                
                if let imageData = self.data.imageData {
                    ClassifierImageView(imageData: imageData)
                }
                
                /// Name of dish with description
                
                self.nameView
                
                /// Grams, Calories and other information
                
                self.detailsView
                
                /// Classification option
                
                self.optionsView
            }
            
            //MARK: - Status bar view
            
            .toolbar {
                ToolbarItem(placement: .status) {
                    self.statusBarView
                }
            }
            
            //MARK: - Keyboard bar view
            
            .toolbar {
                ToolbarItemGroup(placement: .keyboard) {
                    self.keyboardBarView
                }
            }
            
            .scrollDismissesKeyboard(.interactively)
        }
        .tint(.accentColor)
    }
}

extension ClassifierView {
    
    //MARK: - Name view
    
    private var nameView: some View {
        Section {
            TextField("Dish", text: self.$data.name)
                .focused(self.$focusedField, equals: .dish)
                .font(.system(size: 22, weight: .bold, design: .rounded))
                .submitLabel(.next)
                .onSubmit { self.focusedField = .weight }
            
            if let description = self.data.description {
                Text(description)
                    .font(.system(.footnote, design: .rounded))
                    .foregroundColor(.secondary)
            }
        }
    }
    
    //MARK: - Details view
    
    private var detailsView: some View {
        Section {
            HStack {
                Text("Grams:")
                    .foregroundColor(.secondary)
                    .frame(width: 68, alignment: .leading)
                
                TextField("Enter", text: .constant("100"))
                    .focused(self.$focusedField, equals: .weight)
                    .keyboardType(.numberPad)
            }
            
            HStack {
                Text("Calories:")
                    .foregroundColor(.secondary)
                    .frame(width: 68, alignment: .leading)
                
                TextField("Enter", text: .constant("387"))
                    .focused(self.$focusedField, equals: .calories)
                    .keyboardType(.numberPad)
                
                //TODO: - Change color if disabled
                
                .foregroundColor(.secondary)
                
                ZStack {
                    Circle()
                        .fill(.green.opacity(0.35))
                        .frame(width: 20, height: 20)
                    
                    Circle()
                        .fill(.green.opacity(0.85))
                        .frame(width: 10, height: 10)
                }
                .pulsate(scale: (1.1, 0.85), duration: 1.5)
            }
        }
    }
    
    //MARK: - Options view
    
    private var optionsView: some View {
        Section {
            Toggle(isOn: .constant(true)) {
                Text("Count automatically")
                    .font(.system(.body, design: .rounded))
            }
        } footer: {
            Text("If you turn on the \"Count automatically\" toggle switch, then automatic calorie, carbs, protein, fat counting will be performed depending on weight.")
                .font(.system(.footnote, design: .rounded))
        }
    }
    
    //MARK: - Status bar view
    
    private var statusBarView: some View {
        HStack(spacing: 18) {
            Button {
                HapticCenter.notification(type: .success)
            } label: {
                Image(systemName: "heart")
                    .foregroundColor(.primary)
                    .font(.system(size: 16, weight: .semibold, design: .rounded))
                    .frame(width: 48, height: 48)
                    .background(Color(uiColor: .secondarySystemGroupedBackground))
                    .clipShape(Circle())
            }
            .buttonStyle(.capture)
            
            Button {
                HapticCenter.impact(style: .heavy)
            } label: {
                Text("Save")
                    .foregroundColor(.white)
                    .font(.system(size: 16, weight: .semibold, design: .rounded))
                    .frame(minWidth: 128, idealWidth: 196, maxWidth: 384)
                    .frame(height: 48)
                    .background(Color.accentColor)
                    .clipShape(Capsule())
            }
            .buttonStyle(.capture)
        }
        .padding()
    }
    
    //MARK: - Keyboard var view
    
    private var keyboardBarView: some View {
        Group {
            Spacer()
            Button("Done") {
                self.focusedField = nil
            }
            .fontWeight(.medium)
            .foregroundColor(.primary)
        }
    }
    
    //MARK: - Focused field
    
    private enum FocusedField: Hashable {
        case dish, weight, calories
    }
}
#endif
