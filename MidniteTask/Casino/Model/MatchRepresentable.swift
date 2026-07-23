//
//  MatchRepresentable.swift
//  MidniteTask
//
//  Created by Jackson Barnes on 23/07/2026.
//

import Foundation
import SwiftUI

// MARK: - Team Display

struct TeamDisplay {
    let name: String
    let imageURL: URL?
    let colour: Color?
}

// MARK: - Market Contract

struct DisplayContract: Identifiable {
    let id: Int
    let title: String
    let decimalPrice: String
}

// MARK: - Shared Match Protocol

protocol MatchRepresentable: Identifiable {
    var id: Int { get }
    var competitionName: String { get }
    var homeTeam: String { get }
    var awayTeam: String { get }
    var homeImageURL: URL? { get }
    var awayImageURL: URL? { get }
    var homeTeamColourHex: String? { get }
    var awayTeamColourHex: String? { get }
    var startTime: Date { get }
    var status: String { get }
    var marketName: String { get }
    var contracts: [DisplayContract] { get }
    var gameName: String { get }
}

// MARK: - Helpers

extension MatchRepresentable {
    
    var isLive: Bool {
        status.lowercased() == "live"
    }
    
    var homeDisplay: TeamDisplay {
        TeamDisplay(
            name: homeTeam,
            imageURL: homeImageURL,
            colour: Color(hex: homeTeamColourHex)
        )
    }
    
    var awayDisplay: TeamDisplay {
        TeamDisplay(
            name: awayTeam,
            imageURL: awayImageURL,
            colour: Color(hex: awayTeamColourHex)
        )
    }
}

// MARK: - Colour Helper

extension Color {
    
    init?(hex: String?) {
        
        guard let hex else {
            return nil
        }
        
        let hexValue = hex.replacingOccurrences(of: "#", with: "")
        
        guard hexValue.count == 6, let value = Int(hexValue, radix: 16) else {
            return nil
        }
        
        let red = Double((value >> 16) & 0xFF) / 255
        let green = Double((value >> 8) & 0xFF) / 255
        let blue = Double(value & 0xFF) / 255
        
        self.init(red: red, green: green,blue: blue)
    }
}
