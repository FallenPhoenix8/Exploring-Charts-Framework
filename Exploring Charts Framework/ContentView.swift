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
                    NavigationLink("Chart Editor") {
                        ChartDemo1()
                            .navigationTitle(Text("Chart Editor"))
                        #if os(macOS)
                            .padding()
                        #endif
                    }
                    
                    NavigationLink("Funnel Chart") {
                        ChartDemo2()
                            .navigationTitle(Text("Funnel Chart"))
                        #if os(macOS)
                            .padding()
                        #endif
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
