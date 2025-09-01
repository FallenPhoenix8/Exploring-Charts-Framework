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
    @State var isEditMode: Bool = false
    
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
    
    struct ToolbarIconButton: View {
        let iconSystemName: String
        let action: () -> Void
        
        var body: some View {
            Button(action: action) {
                Image(systemName: iconSystemName)
            }
            .padding()
        }
    }
    
    struct Chart: View {
        @Binding var salesVM: SaleViewModel
        let chartType: ChartType
        let colors: [Color]
        let isLandscape: Bool
        let isEditMode: Bool
        
        var body: some View {
            SalesChart(salesVM: $salesVM, chartType: chartType, colors: colors, isEditMode: isEditMode)
                .frame(
                    minHeight: isLandscape ? 250 : 600,
                    maxHeight: isLandscape ? 250 : .infinity
                )
                .background(
                    RoundedRectangle(cornerRadius: 8)
                        .fill(.regularMaterial)
                        .shadow(color: .black.opacity(0.1), radius: 5, x: 0, y: 2)
                )
        }
    }

    var body: some View {
        ScrollView {
            VStack(spacing: 16) {
                if isLandscape {
//                    ButtonColorSwitcher(colors: $colors).padding(.vertical)
                }
                
                ChartTypePicker(supportedChartTypes: supportedChartTypes, chartType: $chartType)
                
                Chart(
                    salesVM: $salesVM,
                    chartType: chartType,
                    colors: colors,
                    isLandscape: isLandscape,
                    isEditMode: isEditMode
                )
                
//                if !isLandscape {
//                    ButtonColorSwitcher(colors: $colors)
//                }
            }
        }
        .toolbar {
            ToolbarItem(placement: .navigation) {
                    ToolbarIconButton(iconSystemName: !isEditMode ? "square.and.pencil" : "square") {
                        withAnimation {
                            isEditMode.toggle()
                        }
                    }
            }

            ToolbarItem(placement: .bottomBar) {
                ButtonColorSwitcher(colors: $colors)
            }
        }
    }
}

#Preview {
    NavigationStack {
        ChartDemo1()
            .navigationTitle("Chart Demo 1")
    }
}
