//
//  SportsBookView.swift
//  MidniteTask
//
//  Created by Jackson Barnes on 22/07/2026.
//

import SwiftUI

struct SportsBookView: View {
    
    @StateObject private var viewModel = SportsBookViewModel()
    
    var body: some View {
        
        VStack(spacing: 0) {
            
            Picker("Match Type", selection: $viewModel.selectedDisplay) {
                ForEach(SportsBookViewModel.DisplayType.allCases) {
                    Text($0.rawValue)
                        .tag($0)
                }
            }
            .pickerStyle(.segmented)
            .padding(.horizontal)
            .padding(.top)
            
            
            TextField("Search competition or game", text: $viewModel.searchText)
            .textFieldStyle(.plain)
            .padding(12)
            .background(MidniteTheme.surface)
            .clipShape(RoundedRectangle(cornerRadius: 12))
            .foregroundStyle(MidniteTheme.textPrimary)
            .padding()
            
            Group {
                if viewModel.isLoading {
                    Spacer()
                    
                    ProgressView()
                    
                    Spacer()
                } else if let error = viewModel.errorMessage {
                    
                    Spacer()
                    
                    VStack(spacing: 12) {
                        Image(systemName: "exclamationmark.triangle.fill")
                            .font(.largeTitle)
                        
                        Text(error)
                            .multilineTextAlignment(.center)
                    }
                    
                    Spacer()
                } else {
                    
                    switch viewModel.selectedDisplay {
                        
                    case .sports:
                        SportsView(viewModel: viewModel)
                        
                    case .esports:
                        EsportsView(viewModel: viewModel)
                    }
                }
            }
        }
        .background(MidniteTheme.background)
        .navigationTitle("Midnite")
        .task { await viewModel.loadInitialData() }
        .task(id: viewModel.selectedDisplay) { await viewModel.displayChanged() }
    }
}

#Preview {
    
    NavigationStack {
        SportsBookView()
    }
}
