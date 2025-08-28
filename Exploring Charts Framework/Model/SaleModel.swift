// 
//  SaleModel.swift
//  Exploring Charts Framework
//
    

import Foundation

struct SaleModel: Identifiable {
    let id = UUID()
    let day: String
    let dayLegend: String
    var count: Int
}
