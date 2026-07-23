//
//  PriceChangeTracker.swift
//  MidniteTask
//
//  Created by Jackson Barnes on 23/07/2026.
//

import Foundation


enum PriceChangeDirection {
    case increased
    case decreased
}


final class PriceChangeTracker {
    
    private var previousPrices: [Int: Double] = [:]
    
    
    func update(matches: [any MatchRepresentable]) -> [Int: PriceChangeDirection] {
        
        var changes: [Int: PriceChangeDirection] = [:]
        
        for match in matches {
            
            for contract in match.contracts {
                
                guard let price = Double(contract.decimalPrice) else {
                    continue
                }
                
                if let previous = previousPrices[contract.id] {
                    if price > previous {
                        changes[contract.id] = .increased
                    } else if price < previous {
                        changes[contract.id] = .decreased
                    }
                }
                
                previousPrices[contract.id] = price
            }
        }
        
        return changes
    }
}
