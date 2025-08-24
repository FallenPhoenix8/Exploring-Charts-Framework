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
    let sales: Int
}

struct BarChartExample: View {
    let min = 0.0
    let max = 600.0

    let sales: [SalesData] = [
        .init(day: "Sun", dayLegend: "Sunday", sales: Int.random(in: 20...500)),
        .init(day: "Mon", dayLegend: "Monday", sales: Int.random(in: 20...500)),
        .init(day: "Tue", dayLegend: "Tuesday", sales: Int.random(in: 20...500)),
        .init(day: "Wed", dayLegend: "Wednesday", sales: Int.random(in: 20...500)),
        .init(day: "Thu", dayLegend: "Thursday", sales: Int.random(in: 20...500)),
        .init(day: "Fri", dayLegend: "Friday", sales: Int.random(in: 20...500)),
        .init(day: "Sat", dayLegend: "Saturday", sales: Int.random(in: 20...500)),
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
        .chartYScale(domain: min...max)
        .chartXAxis {
            AxisMarks(position: .bottom)
        }
        .chartYAxis {
            AxisMarks(position: .leading)
        }
        .padding()
    }
}

#Preview {
    BarChartExample()
}
