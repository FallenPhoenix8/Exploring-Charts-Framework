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
                    NavigationLink("Chart Demo 1") {
                        ChartDemo1()
                            .navigationTitle(Text("Chart Demo 1"))
                    }
                }
            }
            .navigationTitle(Text("Exploring Charts"))
        }
    }
}

#Preview() {
    ContentView()
}
