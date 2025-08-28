//
//  Arc.swift
//  Exploring Charts
//
    
import SwiftUI

struct Arc: View {
    let color: Color
    
    // Radius properties
    let startRadius: CGFloat
    let endRadius: CGFloat
    
    // Trim properties
    let startTrim: CGFloat
    let endTrim: CGFloat
    
    // Rotation
    let rotation: CGFloat
    
    @State private var finalTrim: CGFloat = 0
    
    var lineWidth: CGFloat {
        endRadius - startRadius
    }
    
    var finalRadius: CGFloat {
        endRadius - lineWidth
    }
    
    var body: some View {
        Circle()
            .trim(from: startTrim, to: finalTrim)
            .stroke(color, style: .init(lineWidth: lineWidth, lineCap: .round))
            .rotationEffect(.degrees(rotation))
            .frame(width: finalRadius, height: finalRadius, alignment: .center)
            .onAppear {
                withAnimation {
                    finalTrim = endTrim
                }
            }
    }
}

#Preview {
    ZStack {
        Arc(
            color: .darkorchid,
            startRadius: 90,
            endRadius: 100,
            startTrim: 0.25,
            endTrim: 0.75,
            rotation: 30
        )
    }
}
