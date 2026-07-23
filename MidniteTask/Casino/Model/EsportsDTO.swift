//
//  EsportsDTO.swift
//  MidniteTask
//
//  Created by Jackson Barnes on 23/07/2026.
//

import Foundation

struct EsportsResponse: Codable {
    let data: [EsportsMatch]
}

struct EsportsMatch: Codable, MatchRepresentable {
    
    let id: Int
    let competitionName: String
    let gameName: String
    let homeTeam: String
    let awayTeam: String
    let homeImageURL: URL?
    let awayImageURL: URL?
    let homeTeamColourHex: String?
    let awayTeamColourHex: String?
    let startTime: Date
    let status: String
    let market: MarketDTO
    
    enum CodingKeys: String, CodingKey {
        case id
        case competitionName = "competition_name"
        case gameName = "game_name"
        case homeTeam = "home_team"
        case awayTeam = "away_team"
        case homeImageURL = "home_image_url"
        case awayImageURL = "away_image_url"
        case homeTeamColourHex = "home_team_colour"
        case awayTeamColourHex = "away_team_colour"
        case startTime = "start_time"
        case status
        case market
    }
    
    var marketName: String {
        market.name
    }
    
    var contracts: [DisplayContract] {
        market.contracts.map {
            DisplayContract(
                id: $0.id,
                title: displayTitle(for: $0),
                decimalPrice: $0.prices.decimalDisplay
            )
        }
    }
    
    private func displayTitle(for contract: ContractDTO) -> String {
        
        switch contract.outcome.lowercased() {
            
        case "home":
            return "Home"
            
        case "draw":
            return "Draw"
            
        case "away":
            return "Away"
            
        default:
            return contract.name
        }
    }
}
