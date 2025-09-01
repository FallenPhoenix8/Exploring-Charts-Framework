//
//  SaleViewModel.swift
//  Exploring Charts Framework
//
    
import Foundation
import Observation

@Observable
class SaleViewModel {
    let minSalesPerDay: Int
    let maxSalesPerDay: Int
    
    private(set) var sales: [SaleModel]
    private(set) var initialSales: [SaleModel]
    
    /// This will trigger UI updates when toggled
    private(set) var refreshHelper: Bool = false
    
    /// Generates `sales` for each weekday with `sales` count
    private func generateSales(isRandom: Bool) -> [SaleModel] {
        var sales: [SaleModel] = []
        for day in WeekDay.allCases {
            let sale = SaleModel(
                day: day.rawValue.capitalized,
                dayLegend: String(day.rawValue.capitalized.prefix(3)),
                count: isRandom ? Int.random(in: minSalesPerDay ... maxSalesPerDay) : 0
            )
            sales.append(sale)
        }
        
        sales.sort(by: {
            let weekDayNumbers = [
                "sunday": 0,
                "monday": 1,
                "tuesday": 2,
                "wednesday": 3,
                "thursday": 4,
                "friday": 5,
                "saturday": 6,
            ]
            return (weekDayNumbers[$0.day.lowercased()] ?? 7) < (weekDayNumbers[$1.day.lowercased()] ?? 7)
        })
        return sales
    }
    
    /// Generates ViewModel with random sale numbers in given range
    /// `minSales ... maxSales`
    init(minSales: Int, maxSales: Int) {
        self.sales = []
        self.initialSales = []
        self.maxSalesPerDay = maxSales
        self.minSalesPerDay = minSales
        
        self.initialSales = generateSales(isRandom: false)
        self.sales = generateSales(isRandom: true)
    }
    
    /// Refreshes `sales` by temporarily setting all sales values to 0.
    /// This triggers `onChange` listeners for chart animations
    func refresh() {
        refreshHelper.toggle()
    }
    
    func reset() {
        for i in 0 ..< sales.count {
            sales[i].count = 0
        }
    }
    
    func update(day: String, count: Int) {
        let sale = sales.first(where: { $0.dayLegend == day })
        if var sale = sale {
            let index = sales.firstIndex(where: { $0.dayLegend == day })!
            sale.count = count
            sales[index] = sale
        }
    }
}
