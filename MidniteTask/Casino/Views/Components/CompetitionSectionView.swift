//
//  CompetitionSection.swift
//  MidniteTask
//
//  Created by Jackson Barnes on 23/07/2026.
//

import SwiftUI

struct CompetitionSectionView: View {
    
    let section: SportsBookViewModel.CompetitionSection
    let selectedContracts: [Int: Int]
    let formattedDate: (Date) -> String
    let onContractSelected: (Int, Int) -> Void
    let priceChanges: [Int: PriceChangeDirection]
    
    var body: some View {
        
        VStack(alignment: .leading, spacing: 16) {
            Text(section.competitionName)
                .font(.title3)
                .fontWeight(.bold)
                .padding(.horizontal)
            
            LazyVStack(spacing: 16) {
                ForEach(section.matches, id: \.id) { match in
                    MatchCell(match: match,
                              selectedContractID: selectedContracts[match.id],
                              priceChanges: priceChanges,
                              formattedStartTime: formattedDate(match.startTime)
                    ) { contractID in
                        onContractSelected(
                            match.id,
                            contractID
                        )
                    }
                }
            }
            .padding(.horizontal)
        }
    }
}
