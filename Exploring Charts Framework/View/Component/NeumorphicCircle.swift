// 
//  NeumorphicCircle.swift
//  Exploring Charts Framework
//
    

import SwiftUI

struct NeumorphicCircle: View {
    var fillColor: Color = .init(red: 0.94, green: 0.94, blue: 0.96)
    var dim: CGFloat = 200
    var body: some View {
        Circle()
            .fill(fillColor)
            .frame(width: dim, height: dim)
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
    NeumorphicCircle()
}
