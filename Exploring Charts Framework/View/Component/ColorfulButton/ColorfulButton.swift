//
//  ColorfulButton.swift
//  Exploring Charts
//

import SwiftUI

struct ColorfulButton: View {
    // State
    @State private var flip: Bool = false

    // Bindings
    @Binding var colors: [Color]

    // Properties
    /// Dimensions
    let dim: CGFloat
    /// Initial shift
    let offset: CGFloat
    let action: () -> Void

    // Computed properties
    var count: CGFloat { CGFloat(colors.count) }
    var lineWidth: CGFloat { (dim - offset) / count }
    var lastColor: Color { colors.last ?? .black }

    // Helper functions
    func minRadius(i: Int, offset: CGFloat) -> CGFloat {
        return lineWidth * CGFloat(i) + offset
    }

    func maxRadius(i: Int, offset: CGFloat) -> CGFloat {
        return lineWidth * CGFloat(i + 1) + offset + lineWidth
    }

    var body: some View {
        ZStack {
            ForEach(0 ..< colors.count - 1, id: \.self) { i in
                RandomColorArc(
                    colors: colors,
                    index: i,
                    minRadius: minRadius(i: i, offset: offset),
                    maxRadius: maxRadius(i: i, offset: offset)
                )
            }

            Circle()
                .stroke(lastColor, lineWidth: lineWidth)
                .frame(width: dim, height: dim)
        }
        .rotation3DEffect(flip ? .zero : .degrees(180), axis: (
            x: Double.random(in: -1...1),
            y: Double.random(in: -1...1),
            z: 0
        ))
        .onTapGesture {
            // Flip the button and randomize color pallette
            colors = Color.getRandomHTMLColors(n: colors.count)
            withAnimation {
                flip.toggle()
            }

            // Call additional action
            action()
        }
    }
}

#Preview {
    @Previewable @State var colors: [Color] = Color.defaultColors

    ColorfulButton(colors: $colors, dim: 100, offset: 10, action: {})
}
