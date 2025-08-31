//
//  SalesChart.swift
//  Exploring Charts Framework
//

import Charts
import Observation
import SwiftUI

struct SalesChart: View {
//    init(chartType: ChartType, colors: [Color], isEditMode: Bool) {
////        self.salesVM = salesVM
//        self.chartType = chartType
//        self.colors = colors
//        self.isEditMode = isEditMode
//    }
    @Binding var salesVM: SaleViewModel

    let chartType: ChartType
    let colors: [Color]
//    let salesVM: SaleViewModel
    let isEditMode: Bool
    
    

    @State private var animationProgress: Double = 0.0
    @State private var isDragging: Bool = false
    @State private var selectedDay: String? = nil
    
    var overlayColor: Color {
        isEditMode ? .black.opacity(0.1) : .clear
    }

    @Environment(\.horizontalSizeClass) private var horizontalSizeClass
    @Environment(\.verticalSizeClass) private var verticalSizeClass

    var isLandscape: Bool {
        horizontalSizeClass == .regular || verticalSizeClass == .compact
    }

    var chartLegendPosition: AnnotationPosition {
        isLandscape ? .leading : .automatic
    }

    // MARK: - Chart builder blocks

    @ChartContentBuilder
    private func chartMark(for sale: SaleModel) -> some ChartContent {
        // Scale the sales value by animation progress (0.0 = zero, 1.0 = full value)
        let animatedValue = Double(sale.count) * animationProgress

        let x: PlottableValue<String> = .value("Day", sale.dayLegend)
        let y: PlottableValue<Double> = .value("Sales", animatedValue)

        switch chartType {
        case .bar:
            BarMark(
                x: x,
                y: y
            )
            .annotation(position: .top, alignment: .center) {
                if animatedValue > 0 {
                    Text("\(Int(animatedValue))")
                        .font(.caption)
                        .fontWeight(.medium)
                        .foregroundColor(.secondary)
                }
            }
            .foregroundStyle(by: .value("Day", sale.dayLegend))

        case .line:
            LineMark(
                x: x,
                y: y
            )
            PointMark(x: x, y: y)

        case .area:
            AreaMark(
                x: x,
                y: y
            )
            .opacity(0.6)

            PointMark(x: x, y: y)
        }
    }

    @ChartContentBuilder
    private var chartContent: some ChartContent {
        ForEach(salesVM.sales) { sale in
            chartMark(for: sale)
        }
        
        if isDragging, let selectedDay = selectedDay {
            let count = salesVM.sales.first(where: { $0.dayLegend == selectedDay })?.count ?? 0
            RuleMark(y: .value("Sales", count))
                .foregroundStyle(.red)
                .lineStyle(.init(lineWidth: 2, dash: [5]))
                .annotation(position: .topTrailing) {
                    Text("\(count)")
                        .font(.caption2)
                }
        }
    }

    // MARK: - Building Chart

    var body: some View {
        Chart {
            chartContent
        }
        .chartYScale(domain: salesVM.minSalesPerDay ... salesVM.maxSalesPerDay)
        .chartXAxis {
            AxisMarks(position: .bottom) { _ in
                AxisGridLine()
                AxisTick()
                AxisValueLabel()
            }
        }
        .chartYAxis {
            AxisMarks(position: .leading) { _ in
                AxisGridLine()
                AxisTick()
                AxisValueLabel()
            }
        }
        .chartLegend(position: chartLegendPosition, alignment: .center)
        .padding()
        .onAppear {
            startGrowAnimation()
        }
        .onChange(of: chartType) { _, _ in
            restartAnimation()
        }
        .onChange(of: salesVM.refreshHelper) { _, _ in
            restartAnimation()
        }
        .chartForegroundStyleScale(range: colors)
        .foregroundStyle(colors.randomElement() ?? Color.accentColor)
        .chartOverlay { proxy in
            GeometryReader { geo in
                    Rectangle()
                    .fill(overlayColor)
                    .contentShape(Rectangle())
                    .gesture(
                        DragGesture()
                            .onChanged { value in
                                if !isEditMode {
                                    return
                                }
                                
                                isDragging = true
                                
                                let location = value.location

                                
                                let (newDay, salesCount) = proxy.value(at: location, as: (String, Double).self) ?? ("error", -1)
                                
                                print(proxy.value(at: location, as: (String, Double).self) ?? ("error", -1))
                                
                                selectedDay = newDay
                                
                                salesVM.update(day: newDay, count: Int(salesCount))
                                
                                
                                
                            }
                            .onEnded { value in
                                isDragging = false
                            }
                    )
            }
        }
        .padding(isEditMode ? .all : Edge.Set())
    }

    // MARK: - Animation Methods

    private func startGrowAnimation() {
        animationProgress = 0.0

        withAnimation(.spring(response: 1.0, dampingFraction: 0.7)) {
            animationProgress = 1.0
        }
    }

    private func restartAnimation() {
        // Immediately reset to zero
        animationProgress = 0.0

        // Start growing animation
        withAnimation(.spring(response: 1.0, dampingFraction: 0.7)) {
            animationProgress = 1.0
        }
    }
}

#Preview {
    @Previewable @State var salesVM: SaleViewModel = .init(minSales: 0, maxSales: 600)
    
    SalesChart(salesVM: $salesVM, chartType: .bar, colors: Color.defaultColors, isEditMode: true)
}
