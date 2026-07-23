//
//  SportsBookService.swift
//  MidniteTask
//
//  Created by Jackson Barnes on 23/07/2026.
//

import Foundation

protocol SportsBookServiceProtocol {
    func fetchSports() async throws -> [SportsMatch]
    func fetchEsports() async throws -> [EsportsMatch]
}

final class SportsBookService: SportsBookServiceProtocol {

    private let sportsURL = URL(string: "https://beaneymidnite.github.io/midnitejson.github.io/sports.json")!

    private let esportsURL = URL(string: "https://beaneymidnite.github.io/midnitejson.github.io/esports.json")!

    private lazy var decoder: JSONDecoder = {
        let decoder = JSONDecoder()
        let formatter = ISO8601DateFormatter()
        
        formatter.formatOptions = [.withInternetDateTime, .withFractionalSeconds]
        
        decoder.dateDecodingStrategy = .custom { decoder in
            let container = try decoder.singleValueContainer()
            let string = try container.decode(String.self)
            
            guard let date = formatter.date(from: string) else {
                throw DecodingError.dataCorruptedError(in: container, debugDescription: "Invalid date \(string)")
            }
            
            return date
        }
        
        return decoder
        
    }()
    
    func fetchSports() async throws -> [SportsMatch] {
        
        let (data, response) = try await URLSession.shared.data(from: sportsURL)
        
        guard let http = response as? HTTPURLResponse, 200...299 ~= http.statusCode else {
            throw URLError(.badServerResponse)
        }
        
        return try decoder.decode(SportsResponse.self,from: data).data
    }
    
    func fetchEsports() async throws -> [EsportsMatch] {
        
        let (data, response) = try await URLSession.shared.data(from: esportsURL)
        
        guard let http = response as? HTTPURLResponse,
              200...299 ~= http.statusCode else {
            
            throw URLError(.badServerResponse)
        }
        
        return try decoder.decode(EsportsResponse.self, from: data).data
    }
}
