//
//  NeumorphicRectangle.swift
//  Exploring Charts Framework
//

import SwiftUI

struct NeumorphicRectangle: View {
    var cornerRadius: CGFloat = 24
    var fillColor: Color = .init(red: 0.94, green: 0.94, blue: 0.96)
    let width: CGFloat
    let height: CGFloat
    var body: some View {
        RoundedRectangle(cornerRadius: cornerRadius)
            .fill(fillColor)
            .frame(width: width, height: height)
            .shadow(
                color: Color.white.opacity(0.8),
                radius: 10,
                x: -5,
                y: -5
            )
            .shadow(
                color: Color.black.opacity(0.2),
                radius: 10,
                x: 5,
                y: 5
            )
    }
}

#Preview {
    NeumorphicRectangle(width: 200, height: 200)
}
