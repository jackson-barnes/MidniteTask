//
//  MatchCell.swift
//  MidniteTask
//
//  Created by Jackson Barnes on 23/07/2026.
//

import SwiftUI

struct MatchCell: View {
    
    let match: any MatchRepresentable
    let selectedContractID: Int?
    let priceChanges: [Int: PriceChangeDirection]
    let formattedStartTime: String
    let onContractSelected: (Int) -> Void
    
    var body: some View {
        
        VStack(alignment: .leading, spacing: 16) {
            HStack {
                statusBadge
                
                Spacer()
                
                Text(formattedStartTime)
                    .font(.caption)
                    .foregroundStyle(MidniteTheme.textSecondary)
            }
        
            HStack {
                TeamView(team: match.homeDisplay)
                
                Spacer()
                
                Text("vs")
                    .font(.headline)
                    .foregroundStyle(MidniteTheme.textSecondary)
                
                Spacer()
                
                TeamView(team: match.awayDisplay)
            }
            
            VStack(alignment: .leading, spacing: 8) {
                
                Text(match.marketName)
                    .font(.headline)
                
                HStack(spacing: 12) {
                    
                    ForEach(match.contracts) { contract in
                        ContractButton(
                            contract: contract,
                            isSelected: selectedContractID == contract.id,
                            priceChange: priceChanges[contract.id]
                        ) {
                            onContractSelected(contract.id)
                        }
                    }
                }
            }
        }
        .padding()
        .background(MidniteTheme.surface)
        .clipShape(RoundedRectangle(cornerRadius: 16))
        .shadow(color: .black.opacity(0.4), radius: 5, y: 2)
    }
    
    
    @ViewBuilder
    private var statusBadge: some View {
        Text(match.isLive ? "LIVE" : "UPCOMING")
            .font(.caption2)
            .bold()
            .padding(.horizontal, 10)
            .padding(.vertical, 6)
            .background(match.isLive ? MidniteTheme.live: MidniteTheme.upcoming)
            .foregroundColor(.white)
            .clipShape(
                Capsule()
            )
    }
}

