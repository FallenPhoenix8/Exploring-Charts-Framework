// 
//  ContentView.swift
//  Exploring Charts Framework
//
    

import SwiftUI

struct ContentView: View {
    var body: some View {
        NavigationStack {
            VStack {
                Form {
                    NavigationLink("Bar Chart Example") {
                        BarChartExample()
                            .navigationTitle(Text("Bar Chart Example"))
                    }
                }
            }
            .navigationTitle(Text("Exploring Charts"))
        }
    }
}

#Preview {
    ContentView()
}
