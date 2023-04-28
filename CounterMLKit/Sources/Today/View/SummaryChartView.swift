//
//  SummaryChartView.swift
//  
//
//  Created by Daniil Shmoylove on 08.04.2023.
//

import SwiftUI
import Charts

struct SummaryChartView: View {
    
    @State private var meals: [Meal] = Meal.mock()
    @State private var style: SummaryChartStyle = .nutrition
    @State private var period: SummaryChartPeriod = .today
    
    var body: some View {
        VStack(alignment: .leading, spacing: .zero) {
            HStack {
                Text("Avg. \(self.style.rawValue)")
                Spacer()
                Menu {
                    Section {
                        Picker("", selection: self.$style) {
                            Label("Nutrition", systemImage: "carrot")
                                .tag(SummaryChartStyle.nutrition)
                            Label("Macronutrients", systemImage: "bubbles.and.sparkles")
                                .tag(SummaryChartStyle.macronutrients)
                        }
                        .labelsHidden()
                    }
                    
                    Menu {
                        Picker("", selection: self.$period) {
                            ForEach(
                                SummaryChartPeriod.allCases,
                                id: \.self
                            ) { period in
                                Text(period.rawValue)
                            }
                        }
                        .labelsHidden()
                    } label: {
                        Label("Period", systemImage: "calendar.badge.clock")
                    }
                    
                    Section {
                        Label("Preferences", systemImage: "paintpalette")
                    }
                } label: {
                    Image(systemName: "ellipsis")
                        .padding(6)
                }
                .tint(.primary)
            }
            .font(.system(size: 14, weight: .medium, design: .rounded))
            
            HStack(alignment: .firstTextBaseline, spacing: 4) {
                Text("2,589")
                    .font(.system(size: 30, weight: .semibold, design: .rounded))
                    .textSelection(.enabled)
                Text("kcal")
                    .foregroundColor(.secondary)
                    .font(.system(size: 22, weight: .medium, design: .rounded))
            }
            .padding(.bottom, 12)
            
//            self.charts
            self.secondCharts
        }
        .padding(.vertical)
    }
}

extension SummaryChartView {
    
    private var charts: some View {
        Chart(self.meals.prefix(7)) { item in
            ForEach(
                SummaryChartStyle.CFP.allCases,
                id: \.self
            ) { compose in
                BarMark(
                    x: .value("Week", item.date, unit: .day),
                    y: .value("Per day", item.calories)
                )
                .foregroundStyle(
                    by: .value(
                        "Composition of the product",
                        compose.rawValue
                    )
                )
            }
            .cornerRadius(8)
        }
        .chartForegroundStyleScale([
            "Carbs": Color.accentColor, "Fat": .orange, "Protein": .green
        ])
        .chartYAxis(.hidden)
    }
    
    private var secondCharts: some View {
        Chart(self.meals.prefix(7)) { item in
            BarMark(
                x: .value("Week", item.date, unit: .day),
                y: .value("Per day", item.calories),
                width: .inset(8)
            )
            .cornerRadius(8)
            .foregroundStyle(Color.accentColor.gradient)
            .foregroundStyle(
                by: .value(
                    "Composition of the product",
                    "Total meals"
                )
            )
            
            /// if less than limit
            
            let limit = 1750
                BarMark(
                    x: .value("Week", item.date, unit: .day),
                    y: .value("Per day", item.calories < limit ? limit - item.calories : .zero),
                    width: .inset(8)
                )
                .cornerRadius(8)
                .foregroundStyle(Color.grayBackground)
                .foregroundStyle(
                    by: .value(
                        "Composition of the product",
                        "Goal calories"
                    )
                )
        }
        .chartForegroundStyleScale([
            "Total meals": Color.accentColor, "Goal calories": .secondary.opacity(0.6)
        ])
    }
}

import CoreUI
import SharedModels

struct MealCellView: View {
    init(
        data: MealModel,
        index: Int
    ) {
        self.data = data
        self.index = index
    }
    
    private let index: Int
    private let data: MealModel
    
    var body: some View {
        HStack(spacing: 16) {
            Text("\(index + 1)")
                .foregroundColor(.secondary)
                .font(.system(size: 14, weight: .medium, design: .rounded))
                .frame(width: 28, height: 28)
                .background(Color.grayBackground)
                .clipShape(Circle())
            
            VStack(
                alignment: .leading,
                spacing: 4
            ) {
                Text(self.title)
                    .foregroundColor(.primary)
                    .font(.system(size: 16, weight: .semibold, design: .rounded))
                Text(self.date)
                    .foregroundColor(.secondary)
                    .font(.system(size: 12, weight: .regular, design: .rounded))
            }
        }
        .padding(.vertical, 2)
    }
    
    //MARK: - Title
    
    /// - Tag: Title
    private var title: AttributedString {
        
        /// Name AttributedString
        
        let nameString = AttributedString(self.data.name)
        
        /// Calories AttributedString
        
        let number = self.data.calories
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .decimal
        let formattedNumber = numberFormatter.string(
            from: NSNumber(value: number)
        ) ?? "\(number)"
        let valueString = AttributedString("\(formattedNumber) calories")
        
        /// Addition of AttributedString values
        
        return nameString + ", " + valueString
    }
    
    //MARK: - Date
    
    private var date: AttributedString {
        
        /// Date AttributedString
        
        let date = self.data.date
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm"
        let formattedTime = dateFormatter.string(from: date)
        let dateString = AttributedString(formattedTime)
        return "Today" + " " + dateString
    }
    
    //MARK: - Subtitle
    
    /// - Tag: Subtitle
    private var subtitle: AttributedString {
        
        /// Name AttributedString
        
        let nameString = AttributedString(self.data.name)
        
        /// Weight AttributedString
        
        let weight = Double(self.data.weight)
        let weightFormatter = MeasurementFormatter()
        weightFormatter.unitOptions = .providedUnit
        let measurement = Measurement(value: weight, unit: UnitMass.grams)
        let formattedWeight = weightFormatter.string(from: measurement)
        let weightString = AttributedString(formattedWeight)

        /// Addition of AttributedString values
        
        return nameString + " " + weightString
    }
}

struct Meal: Identifiable {
    let id = UUID()
    let date: Date
    let calories: Int
}

enum SummaryChartStyle: String, CaseIterable {
    case nutrition = "Nutrition"
    case macronutrients = "Macronutrients"
    
    enum CFP: String, CaseIterable {
        case carbs = "Carbs"
        case fat = "Fat"
        case protein = "Protein"
    }
}

enum SummaryChartPeriod: String, CaseIterable {
    case today = "Today"
    case week = "Last Week"
    case month = "Last Month"
    case year = "Last Year"
}

extension Meal {
    static func mock() -> [Meal] {
        [
            .init(
                date: .fromComponents(
                    year: 2023,
                    month: 1,
                    day: 1
                ),
                calories: 1237
            ),
            .init(
                date: .fromComponents(
                    year: 2023,
                    month: 1,
                    day: 2
                ),
                calories: 1566
            ),
            .init(
                date: .fromComponents(
                    year: 2023,
                    month: 1,
                    day: 3
                ),
                calories: 1200
            ),
            .init(
                date: .fromComponents(
                    year: 2023,
                    month: 1,
                    day: 4
                ),
                calories: 1150
            ),
            .init(
                date: .fromComponents(
                    year: 2023,
                    month: 1,
                    day: 5
                ),
                calories: 1670
            ),
            .init(
                date: .fromComponents(
                    year: 2023,
                    month: 1,
                    day: 6
                ),
                calories: 2135
            ),
            .init(
                date: .fromComponents(
                    year: 2023,
                    month: 1,
                    day: 7
                ),
                calories: 1550
            ),
            .init(
                date: .fromComponents(
                    year: 2023,
                    month: 1,
                    day: 8
                ),
                calories: 1133
            ),
        ]
    }
}

extension Date {
    static func fromComponents(
        year: Int,
        month: Int,
        day: Int = 1,
        hour: Int = 0,
        minutes: Int = 0,
        seconds: Int = 0
    ) -> Date {
        Calendar.current.date(
            from: DateComponents(
                year: year,
                month: month,
                day: day,
                hour: hour,
                minute: minutes,
                second: seconds
            )
        ) ?? Date()
    }
}

#if DEBUG
struct SummaryChartView_Previews: PreviewProvider {
    static var previews: some View {
        SummaryChartView()
    }
}
#endif

