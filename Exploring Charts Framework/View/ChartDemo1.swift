//
//  BarChartExample.swift
//  Exploring Charts Framework
//

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
    
    @Environment(\.horizontalSizeClass) private var horizontalSizeClass
    @Environment(\.verticalSizeClass) private var verticalSizeClass
    
    var isLandscape: Bool {
        horizontalSizeClass == .regular || verticalSizeClass == .compact
    }

    init() {
        _salesVM = State(initialValue: SaleViewModel(minSales: Int(self.min), maxSales: Int(self.max)))
    }
    
    // MARK: - Builder Blocks
    
    struct ChartTypePicker: View {
        let supportedChartTypes: [ChartType]
        @Binding var chartType: ChartType
        
        var body: some View {
            Picker("Select chart type", selection: $chartType) {
                ForEach(supportedChartTypes, id: \.self) { type in
                    Text("\(type.rawValue)").tag(type)
                }
            }
            .pickerStyle(.segmented)
        }
    }
    
    struct ButtonColorSwitcher: View {
        @Binding var colors: [Color]
        var body: some View {
            ColorfulButton(colors: $colors, dim: 48, offset: 10) {}
        }
    }
    
    struct Chart: View {
        let salesVM: SaleViewModel
        let chartType: ChartType
        let colors: [Color]
        
        var body: some View {
            SalesChart(salesVM: salesVM, chartType: chartType, colors: colors)
                .frame(height: 400)
                .background(
                    RoundedRectangle(cornerRadius: 8)
                        .fill(.regularMaterial)
                        .shadow(color: .black.opacity(0.1), radius: 5, x: 0, y: 2)
                )
        }
    }

    var body: some View {
        ScrollView {
            if isLandscape {
                Grid {
                    GridRow {
                        ChartTypePicker(supportedChartTypes: supportedChartTypes, chartType: $chartType)
                    }
                    GridRow {
                        HStack(spacing: 16) {
                            ButtonColorSwitcher(colors: $colors)
                        
                            Chart(salesVM: salesVM, chartType: chartType, colors: colors)
                        }
                    }
                }
            } else {
                VStack(spacing: 16) {
                    ChartTypePicker(supportedChartTypes: supportedChartTypes, chartType: $chartType)
                    
                    Chart(salesVM: salesVM, chartType: chartType, colors: colors)
                    
                    ButtonColorSwitcher(colors: $colors)
                }
            }
        }
    }
}

#Preview {
    ChartDemo1()
}
