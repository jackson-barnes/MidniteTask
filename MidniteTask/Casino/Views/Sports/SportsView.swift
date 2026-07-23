//
//  SportsView.swift
//  MidniteTask
//
//  Created by Jackson Barnes on 23/07/2026.
//

import SwiftUI

struct SportsView: View {
    
    @ObservedObject var viewModel: SportsBookViewModel
    
    var body: some View {
        ScrollView {
            LazyVStack(spacing: 24) {
                ForEach(viewModel.competitionSections) { section in
                    CompetitionSectionView(
                        section: section,
                        selectedContracts: viewModel.selectedContracts,
                        formattedDate: viewModel.formattedStartTime(for:),
                        onContractSelected: viewModel.selectContract,
                        priceChanges: viewModel.priceChanges
                    )
                }
            }
            .padding(.vertical)
        }
    }
}

#Preview {
    SportsView(
        viewModel: SportsBookViewModel()
    )
}
