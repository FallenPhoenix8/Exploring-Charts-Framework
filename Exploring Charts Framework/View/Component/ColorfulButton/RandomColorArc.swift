//
//  RandomColorArc.swift
//  Exploring Charts
//
    
import SwiftUI

struct RandomColorArc: View {
    /// Constructor with constant color
    init(colors: [Color], index: Int, minRadius: CGFloat, maxRadius: CGFloat, opacity: CGFloat = 1) {
        self.colors = colors
        self.index = index
        self.minRadius = minRadius
        self.maxRadius = maxRadius
        self.opacity = opacity
    }
    
    /// Constructor with randomizing color
    init(minRadius: CGFloat, maxRadius: CGFloat, opacity: CGFloat = 1) {
        self.colors = Color.defaultColors
        self.index = Int.random(in: 0 ..< colors.count)
        
        self.minRadius = minRadius
        self.maxRadius = maxRadius
        self.opacity = opacity
    }
    
    // Properties
    
    let colors: [Color]
    let index: Int
    
    let minRadius: CGFloat
    let maxRadius: CGFloat

    let opacity: CGFloat
    
    // Random constant
    let startTrim = Double.random(in: 0 ... 0.5)
    let endTrim = Double.random(in: 0.6 ... 1.0)
    
    // Computed Properties
    
    var isValidIndex: Bool {
        index < colors.count && index >= 0
    }
    
    var finalIndex: CGFloat {
        isValidIndex ? CGFloat(index) : 0
    }
    
    var count: CGFloat {
        CGFloat(colors.count)
    }
    
    var color: Color {
        colors[Int(finalIndex)]
    }
    
    var endRadius: CGFloat {
        minRadius + maxRadius / count
    }
    
    var rotation: CGFloat {
        Double.random(in: 0 ... 360)
    }
    
    var body: some View {
        Arc(color: color.opacity(opacity), startRadius: minRadius, endRadius: endRadius, startTrim: startTrim, endTrim: endTrim, rotation: rotation)
    }
}

#Preview {
    @Previewable @State var toggle = true
    
    VStack(spacing: 50) {
        if toggle {
            Text("Constant color")
                .font(.title)
                .fontWeight(.semibold)
            RandomColorArc(
                colors: Color.defaultColors,
                index: 0,
                minRadius: 170,
                maxRadius: 180,
                opacity: 0.9
            )
            
            Text("Random color")
                .font(.title)
                .fontWeight(.semibold)
            RandomColorArc(minRadius: 170, maxRadius: 180, opacity: 0.9)
        }
        Button("Reload") {
            withAnimation {
                toggle.toggle()
                toggle.toggle()
            }
        }
    }
}
