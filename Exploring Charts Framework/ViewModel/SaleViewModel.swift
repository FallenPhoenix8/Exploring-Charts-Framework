//
//  SaleViewModel.swift
//  Exploring Charts Framework
//
    
import Foundation
import Observation

@Observable
class SaleViewModel {
    struct Sale: Identifiable {
        let id = UUID()
        let day: String
        let dayLegend: String
        var count: Int
    }
    
    let minSalesPerDay: Int
    let maxSalesPerDay: Int
    
    var sales: [Sale]
    var initialSales: [Sale]
    
    /// This will trigger UI updates when toggled
    private(set) var refreshHelper: Bool = false
    
    /// Generates `sales` for each weekday with `sales` count
    private func generateSales(isRandom: Bool) -> [Sale] {
        var sales: [Sale] = []
        for day in SaleModel.WeekDay.allCases {
            let sale = Sale(
                day: day.rawValue.capitalized,
                dayLegend: String(day.rawValue.prefix(3)),
                count: isRandom ? Int.random(in: minSalesPerDay ... maxSalesPerDay) : 0
            )
            sales.append(sale)
        }
        sales.sort { $0.day < $1.day }
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
}
