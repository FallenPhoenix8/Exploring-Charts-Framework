// 
//  SaleModel.swift
//  Exploring Charts Framework
//
    

import Foundation

struct SaleModel: Identifiable {
    enum WeekDay: String, CaseIterable {
        case monday, tuesday, wednesday, thursday, friday, saturday, sunday
    }
    
    let id = UUID()
    let day: WeekDay
    var sales: Int
}
