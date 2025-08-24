//
//  BarChartExample.swift
//  Exploring Charts Framework
//

import Charts
import SwiftUI

struct SalesData: Identifiable {
    let id = UUID()
    let day: String
    let dayLegend: String
    var sales: Int
}

struct BarChartExample: View {
    let min = 0.0
    let max = 600.0

    @Environment(\.horizontalSizeClass) var horizontalSizeClass
    @Environment(\.verticalSizeClass) var verticalSizeClass

    var isLandscape: Bool {
        withAnimation {
            horizontalSizeClass == .regular || verticalSizeClass == .compact
        }
    }

    @State private var sales: [SalesData] = [
        .init(day: "Sun", dayLegend: "Sunday", sales: 0),
        .init(day: "Mon", dayLegend: "Monday", sales: 0),
        .init(day: "Tue", dayLegend: "Tuesday", sales: 0),
        .init(day: "Wed", dayLegend: "Wednesday", sales: 0),
        .init(day: "Thu", dayLegend: "Thursday", sales: 0),
        .init(day: "Fri", dayLegend: "Friday", sales: 0),
        .init(day: "Sat", dayLegend: "Saturday", sales: 0),
    ]

    var body: some View {
        Chart {
            ForEach(sales) { sale in
                BarMark(
                    x: .value("Day", sale.day),
                    y: .value(
                        "Sales",
                        sale.sales
                    )
                )
                .annotation {
                    Text("\(sale.sales)")
                        .font(.caption)
                        .fontWeight(.light)
                }
                .foregroundStyle(by: .value("Day", sale.dayLegend))
            }
        }
        .chartYScale(domain: min ... max)
        .chartXAxis {
            AxisMarks(position: .bottom)
        }
        .chartYAxis {
            AxisMarks(position: .leading)
        }
        .chartLegend(position: isLandscape ? .leading : .automatic, alignment: .center)
        .padding()
        .onAppear {
            withAnimation {
                for i in 0..<sales.count {
                    sales[i].sales = Int.random(in: 20...600)
                }
            }
        }
    }
}

#Preview {
    BarChartExample()
}
