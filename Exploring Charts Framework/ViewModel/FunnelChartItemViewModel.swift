//
//  FunnelChartItemViewModel.swift
//  Exploring Charts Framework
//
    
import Foundation
import Observation

@Observable
class FunnelChartItemViewModel {
    let maxValue: Double
    let minValue: Double
    let count: Int
    private(set) var items: [FunnelChartItemModel]
    
    func generateRandomItems() -> [FunnelChartItemModel] {
        var maxValue: Double = maxValue
        var items = [FunnelChartItemModel]()
        
        for i in 0 ..< count {
            let name = String(Character(UnicodeScalar(i)!))
            
            let randomValue = Double.random(in: minValue ... maxValue)
            maxValue = randomValue
            
            items.append(.init(numerical: randomValue, name: name))
        }
        
        return items.sorted { $0.numerical > $1.numerical }
    }
    
    func getMaxValue() -> Double? {
        return items.count > 0 ? items[0].numerical : nil
    }
    
    func randomize() {
        self.items = generateRandomItems()
    }
    
    init(maxValue: Double, minValue: Double, count: Int) {
        self.maxValue = maxValue
        self.minValue = minValue
        self.count = count
        
        // Generating random items
        self.items = []
        self.items = generateRandomItems()
    }
    
}
