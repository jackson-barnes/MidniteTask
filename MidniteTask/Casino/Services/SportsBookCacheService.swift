//
//  SportsBookCacheService.swift
//  MidniteTask
//
//  Created by Jackson Barnes on 23/07/2026.
//

import Foundation

protocol SportsBookCacheServiceProtocol {
    func saveSports(_ matches: [SportsMatch]) async throws
    func loadSports() async throws -> [SportsMatch]?
    func saveEsports(_ matches: [EsportsMatch]) async throws
    func loadEsports() async throws -> [EsportsMatch]?
}


final class SportsBookCacheService: SportsBookCacheServiceProtocol {
    private let fileManager = FileManager.default
    private let encoder = JSONEncoder()
    private let decoder = JSONDecoder()
    private var cacheDirectory: URL {
        fileManager.urls(for: .applicationSupportDirectory, in: .userDomainMask)[0]
            .appendingPathComponent("SportsBookCache", isDirectory: true)
    }
    
    private var sportsFile: URL {
        cacheDirectory
            .appendingPathComponent("sports.json")
    }
    
    private var esportsFile: URL {
        cacheDirectory
            .appendingPathComponent("esports.json")
    }
    
    init() {
        encoder.dateEncodingStrategy = .iso8601
        decoder.dateDecodingStrategy = .iso8601
        createDirectoryIfNeeded()
    }
    
    
    func saveSports(_ matches: [SportsMatch]) async throws {
        let data = try encoder.encode(matches)
        try data.write(to: sportsFile,options: .atomic)
    }
    
    
    func loadSports() async throws -> [SportsMatch]? {
        
        guard fileManager.fileExists(atPath: sportsFile.path) else {
            return nil
        }
        
        let data = try Data(contentsOf: sportsFile)
        
        return try decoder.decode([SportsMatch].self, from: data)
    }
    
    
    func saveEsports(_ matches: [EsportsMatch]) async throws {
        let data = try encoder.encode(matches)
        try data.write(to: esportsFile,options: .atomic)
    }
    
    
    func loadEsports() async throws -> [EsportsMatch]? {
        
        guard fileManager.fileExists(atPath: esportsFile.path) else {
            return nil
        }
        
        let data = try Data(contentsOf: esportsFile)
        
        return try decoder.decode([EsportsMatch].self, from: data)
    }
    
    
    private func createDirectoryIfNeeded() {
        
        guard !fileManager.fileExists(atPath: cacheDirectory.path) else {
            return
        }
        
        try? fileManager.createDirectory(at: cacheDirectory, withIntermediateDirectories: true)
    }
}
