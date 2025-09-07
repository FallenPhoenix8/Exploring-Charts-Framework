//
//  FunnelChart.swift
//  Exploring Charts Framework
//
    
import Charts
import SwiftUI

struct FunnelChart: View {
    let itemsVM: FunnelChartItemViewModel
    let numericalName: String
    let stringName: String
    
    @State private var isAnnotated = true
    
    @ChartContentBuilder
    func FunnelMark(item: FunnelChartItemModel, xStart: Double, xEnd: Double) -> some ChartContent {
        BarMark(
            xStart: .value(numericalName, xStart),
            xEnd: .value(numericalName, xEnd),
            y: .value(stringName, item.name)
        )
        .foregroundStyle(by: .value(stringName, item.name))
        .annotation(position: .trailing) {
            if isAnnotated {
                Text("\(String(format: "%.2f", item.numerical))")
            }
        }
    }
    
    var body: some View {
        GeometryReader { geometry in
            VStack {
                HStack(alignment: .center) {
                    Spacer()
                    Chart(itemsVM.items) { item in
                        let maxValue = itemsVM.getMaxValue() ?? 0
                        
                        let xStart = maxValue / 2 - item.numerical / 2
                        let xEnd = xStart + item.numerical
                        
                        FunnelMark(item: item, xStart: xStart, xEnd: xEnd)
                    }
                    .chartXAxis(.hidden)
                    .chartYAxis(.hidden)
                    .chartLegend(.hidden)
                    .padding()
                    .chartPlotStyle { plotArea in
                        plotArea.frame(width: geometry.size.height / 4, height: geometry.size.width / 2)
                    }
                    
                    Spacer()
                }
                
                .background(
                    NeumorphicRectangle(width: .infinity, height: .infinity)
                )
                
                .padding()
                .onTapGesture {
                    withAnimation {
                        isAnnotated.toggle()
                    }
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .toolbar {
                ToolbarItem(placement: .bottomBar) {
                    Button(action: {
                        withAnimation {
                            itemsVM.randomize()
                        }
                    }, label: {
                        ZStack {
                            NeumorphicCircle(dim: 50)
                            Image(systemName: "shuffle")
                        }
                    })
                }
            }
        }
    }
}

#Preview {
    NavigationStack {
        FunnelChart(itemsVM: .init(maxValue: 10000, minValue: 100, count: 6), numericalName: "Test", stringName: "Test2")
            .navigationTitle(Text("Funnel Chart"))
    }
}
