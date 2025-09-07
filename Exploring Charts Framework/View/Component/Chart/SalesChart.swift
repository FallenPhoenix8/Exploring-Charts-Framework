//
//  SalesChart.swift
//  Exploring Charts Framework
//

import Charts
import Observation
import SwiftUI

struct SalesChart: View {
    @Binding var salesVM: SaleViewModel

    let chartType: ChartType
    let colors: [Color]
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
                if animatedValue > 0, isEditMode {
                    VStack {
                        Circle()
                            .stroke(lineWidth: 2)
                            .foregroundStyle(.secondary)

                        Text("\(Int(animatedValue))")
                            .font(.caption)
                            .fontWeight(.medium)
                            .foregroundColor(.secondary)
                    }
                }
            }
            .foregroundStyle(by: .value("Day", sale.dayLegend))

        case .line:
            LineMark(
                x: x,
                y: y
            )
            if isEditMode {
                PointMark(x: x, y: y)
            }

        case .area:
            AreaMark(
                x: x,
                y: y
            )
            .opacity(0.6)

            if isEditMode {
                PointMark(x: x, y: y)
            }
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
        .foregroundStyle(colors[0])
        .chartOverlay { proxy in
            GeometryReader { chartGeo in // Get the geometry of the chart's plot area
                Rectangle()
                    .fill(overlayColor)
                    .contentShape(Rectangle())
                    .gesture(
                        DragGesture(minimumDistance: 0) // Respond immediately on touch
                            .onChanged { value in
                                if !isEditMode || salesVM.sales.isEmpty { return }

                                // MARK: - Manual X-Axis Hit-Testing

                                // 1. Calculate the width of each bar's "band"
                                let bandWidth = chartGeo.size.width / CGFloat(salesVM.sales.count)

                                // 2. Determine the index of the bar at the drag's start location
                                let index = Int(value.startLocation.x / bandWidth)

                                // 3. Make sure the calculated index is valid
                                guard index >= 0, index < salesVM.sales.count else { return }

                                // 4. Get the day to update from our data array
                                let dayToUpdate = salesVM.sales[index].dayLegend

                                // --- Use Proxy for Y-Axis Value ---

                                // 5. Use the proxy to get the new sales value from the current Y position
                                guard let (_, salesCount) = proxy.value(at: value.location, as: (String, Double).self) else { return }

                                // --- Update State & ViewModel ---

                                isDragging = true
                                selectedDay = dayToUpdate
                                salesVM.update(day: dayToUpdate, count: Int(max(0, salesCount)))
                            }
                            .onEnded { _ in
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
