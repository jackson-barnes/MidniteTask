//
//  TeamView.swift
//  MidniteTask
//
//  Created by Jackson Barnes on 23/07/2026.
//

import SwiftUI

struct TeamView: View, Equatable {
    
    static func == (lhs: TeamView, rhs: TeamView) -> Bool {
        lhs.team.name == rhs.team.name &&
        lhs.team.imageURL == rhs.team.imageURL
    }
    
    let team: TeamDisplay
    
    var body: some View {
        VStack(spacing: 8) {
            if let imageURL = team.imageURL {
                AsyncImage(url: imageURL, transaction: Transaction(animation: nil)) { phase in
                    switch phase {
                    case .success(let image):
                        image
                            .resizable()
                            .scaledToFit()
                        
                    case .failure(_):
                        fallbackView
                        
                    case .empty:
                        fallbackView
                        
                    @unknown default:
                        fallbackView
                    }
                }
                .frame(width: 56, height: 56)
                
            } else {
                fallbackView
            }
            
            Text(team.name)
                .font(.caption)
                .multilineTextAlignment(.center)
                .lineLimit(2)
        }
    }
    
    @ViewBuilder
    private var fallbackView: some View {
        Circle()
            .fill(team.colour ?? MidniteTheme.surfaceSecondary)
            .frame(width: 44, height: 44)
    }
}

#Preview {
    
    TeamView(
        team: TeamDisplay(
            name: "Liverpool",
            imageURL: nil,
            colour: .red
        )
    )
}
