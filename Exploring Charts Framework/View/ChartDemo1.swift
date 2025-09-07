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
        let dim: CGFloat
        
        var body: some View {
            ColorfulButton(colors: $colors, dim: dim, offset: 10) {}
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
    
    struct ChartCard: View {
        @Binding var salesVM: SaleViewModel
        let chartType: ChartType
        let colors: [Color]
        let isLandscape: Bool
        let isEditMode: Bool
        
        #if os(iOS)
            var minHeight: CGFloat {
                isLandscape ? 250 : 600
            }

            var maxHeight: CGFloat {
                isLandscape ? 250 : .infinity
            }

        #elseif os(macOS)
            var minHeight: CGFloat = 600
            var maxHeight: CGFloat = .infinity
        #endif
        
        var body: some View {
            SalesChart(salesVM: $salesVM, chartType: chartType, colors: colors, isEditMode: isEditMode)
           
                .frame(
                    minHeight: minHeight,
                    maxHeight: maxHeight
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
                
                ChartCard(
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
            #if os(iOS)
                ToolbarItemGroup(placement: .topBarLeading) {
                    ToolbarIconButton(iconSystemName: !isEditMode ? "square.and.pencil" : "square") {
                        withAnimation { isEditMode.toggle() }
                    }
                }

                ToolbarItem(placement: .bottomBar) {
                    ButtonColorSwitcher(colors: $colors, dim: 40)
                }
            #elseif os(macOS)
                ToolbarItemGroup(placement: .navigation) {
                    ToolbarIconButton(iconSystemName: !isEditMode ? "square.and.pencil" : "square") {
                        withAnimation { isEditMode.toggle() }
                    }
                }

                ToolbarItem(placement: .navigation) {
                    ButtonColorSwitcher(colors: $colors, dim: 24)
                }
            #endif
        }
    }
}

#Preview {
    NavigationStack {
        ChartDemo1()
            .navigationTitle("Chart Demo 1")
    }
}
