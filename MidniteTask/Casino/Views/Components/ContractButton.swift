//
//  ContractButton.swift
//  MidniteTask
//
//  Created by Jackson Barnes on 23/07/2026.
//

import SwiftUI

struct ContractButton: View {
    
    let contract: DisplayContract
    let isSelected: Bool
    let priceChange: PriceChangeDirection?
    let action: () -> Void
    
    var body: some View {
        
        Button(action: action) {
            VStack(spacing: 6) {
                Text(contract.title)
                    .font(.subheadline)
                    .fontWeight(.medium)
                
                Text(contract.decimalPrice)
                    .font(.headline)
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, 12)
            .background(backgroundColor)
            .foregroundColor(foregroundColor)
            .clipShape(RoundedRectangle(cornerRadius: 12))
            .animation(.easeInOut(duration: 0.25), value: priceChange)
        }
        .buttonStyle(.plain)
    }
    
    
    private var backgroundColor: Color {
        
        if isSelected {
            return .white
        }
        
        switch priceChange {
            
        case .increased:
            return MidniteTheme.positive.opacity(0.25)
            
        case .decreased:
            return MidniteTheme.negative.opacity(0.25)
            
        case nil:
            return MidniteTheme.surfaceSecondary
        }
    }
    
    
    private var foregroundColor: Color {
        isSelected ? .black : .primary
    }
}


#Preview {
    
    ContractButton(
        contract: DisplayContract(id: 1, title: "Home", decimalPrice: "1.85"),
        isSelected: false,
        priceChange: .increased)
    {}
}
