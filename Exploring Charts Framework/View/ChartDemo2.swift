//
//  FunnelChartView.swift
//  Exploring Charts Framework
//

import SwiftUI

struct ChartDemo2: View {
    let itemsVM = FunnelChartItemViewModel(maxValue: 1000000, minValue: 30000, count: 6)
    var body: some View {
        FunnelChart(itemsVM: itemsVM, numericalName: "Numerical Name", stringName: "String Name")
            .navigationTitle("Funnel Chart")
    }
}

#Preview {
    NavigationStack {
        ChartDemo2()
    }
}
