//
//  BarChartExample.swift
//  Exploring Charts Framework
//

import Charts
import Observation
import SwiftUI

struct ChartDemo1: View {
    let min = 0.0
    let max = 600.0
    let supportedChartTypes: [ChartType] = [
        .bar,
        .line,
        .area
    ]

    @State var colors: [Color] = Color.defaultColors
    @State var salesVM: SaleViewModel
    @State var chartType: ChartType = .bar

    init() {
        _salesVM = State(initialValue: SaleViewModel(minSales: Int(self.min), maxSales: Int(self.max)))
    }

    var body: some View {
        VStack(spacing: 16) {
            Picker("Select chart type", selection: $chartType) {
                ForEach(supportedChartTypes, id: \.self) { type in
                    Text("\(type.rawValue)").tag(type)
                }
            }
            .pickerStyle(.segmented)

            // Chart View
            SalesChart(salesVM: salesVM, chartType: chartType, colors: colors)
                .frame(height: 400)
                .background(
                    RoundedRectangle(cornerRadius: 8)
                        .fill(.regularMaterial)
                        .shadow(color: .black.opacity(0.1), radius: 5, x: 0, y: 2)
                )
        }
    }
}

#Preview {
    ChartDemo1()
}
