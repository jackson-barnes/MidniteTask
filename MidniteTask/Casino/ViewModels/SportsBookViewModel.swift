//
//  SportsBookViewModel.swift
//  MidniteTask
//
//  Created by Jackson Barnes on 23/07/2026.
//

import Foundation

@MainActor
final class SportsBookViewModel: ObservableObject {
    
    // MARK: - Display Type
    
    enum DisplayType: String, CaseIterable, Identifiable {
        
        case sports = "Sports"
        case esports = "Esports"
        
        var id: String {
            rawValue
        }
    }
    
    // MARK: - Competition Section
    
    struct CompetitionSection: Identifiable {
        
        let competitionName: String
        
        let matches: [any MatchRepresentable]
        
        var id: String {
            competitionName
        }
    }
    
    // MARK: - Published Properties
    
    @Published var selectedDisplay: DisplayType = .sports
    @Published private(set) var sportsMatches: [SportsMatch] = []
    @Published private(set) var esportsMatches: [EsportsMatch] = []
    @Published private(set) var isLoading = false
    @Published private(set) var errorMessage: String?
    @Published private(set) var selectedContracts: [Int : Int] = [:]
    @Published private(set) var isRefreshing = false
    @Published private(set) var priceChanges: [Int: PriceChangeDirection] = [:]
    @Published var searchText = ""
    
    // MARK: - Dependencies
    
    private let service: SportsBookServiceProtocol
    private let cacheService: SportsBookCacheServiceProtocol
    private let priceTracker = PriceChangeTracker()
    
    // MARK: - Polling
    
    private var pollingTask: Task<Void, Never>?
    private let pollingInterval: UInt64 = 10
    private var hasLoadedInitialData = false
    
    // MARK: - Initialiser
    
    init(service: SportsBookServiceProtocol = SportsBookService(),
         cacheService: SportsBookCacheServiceProtocol = SportsBookCacheService()){
        
        self.service = service
        self.cacheService = cacheService
    }
    
    deinit {
        pollingTask?.cancel()
    }
    
    // MARK: - Public API
    
    func loadInitialData() async {
        
        guard sportsMatches.isEmpty else {
            startPolling()
            return
        }
        
        await loadCachedSports()
        await fetchSports()
        startPolling()
    }
    
    func displayChanged() async {
        
        switch selectedDisplay {
            
        case .sports:
            if sportsMatches.isEmpty {
                await fetchSports()
            }
            
        case .esports:
            if esportsMatches.isEmpty {
                await fetchEsports()
            }
        }
    }
    
    func selectContract(matchID: Int, contractID: Int) {
        
        if selectedContracts[matchID] == contractID {
            selectedContracts.removeValue(forKey: matchID)
        } else {
            selectedContracts[matchID] = contractID
        }
    }
    
    private func loadCachedSports() async {
        
        do {
            if let cached = try await cacheService.loadSports() {
                sportsMatches = cached
            }
        } catch {
            print("Failed loading cached sports:",error)
        }
    }
    
    // MARK: - Polling
    
    private func startPolling() {
        
        pollingTask?.cancel()
        pollingTask = Task {
            
            while !Task.isCancelled {
                try? await Task.sleep(
                    nanoseconds: pollingInterval * 1_000_000_000
                )
                guard !Task.isCancelled else {
                    return
                }
                await refreshCurrentDisplay()
            }
        }
    }
    
    private func refreshCurrentDisplay() async {
        
        isRefreshing = true
        
        defer {
            isRefreshing = false
        }
        
        switch selectedDisplay {
            
        case .sports:
            await fetchSports()
            
        case .esports:
            await fetchEsports()
        }
    }
    
    // MARK: - Computed Display Sections
    
    var competitionSections: [CompetitionSection] {
        
        let matches = filteredMatches
        
        let grouped = Dictionary(grouping: matches) {
            $0.competitionName
        }
        
        return grouped
            .map { competition, matches in
                
                CompetitionSection(
                    competitionName: competition,
                    matches: matches.sorted {
                        $0.startTime < $1.startTime
                    }
                )
            }
            .sorted {
                $0.competitionName < $1.competitionName
            }
    }
    
    private var filteredMatches: [any MatchRepresentable] {
        
        let matches: [any MatchRepresentable]
        
        switch selectedDisplay {
            
        case .sports:
            matches = sportsMatches
        case .esports:
            matches = esportsMatches
        }
        
        guard !searchText.isEmpty else {
            return matches
        }
                
        let query = searchText.lowercased()
        
        return matches.filter {$0.competitionName.lowercased().contains(query) || $0.gameName.lowercased().contains(query)}
    }
    
    // MARK: - Date Formatting
    
    private static let startTimeFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .short
        formatter.locale = .current
        return formatter
    }()
    
    func formattedStartTime(for date: Date) -> String {
        Self.startTimeFormatter.string(from: date)
    }
    
    private func mergeMatches<T>(existing: [T], updated: [T]) -> [T] where T: MatchRepresentable {
        
        let updatedDictionary = Dictionary(
            uniqueKeysWithValues: updated.map {
                ($0.id, $0)
            }
        )
        
        let existingMatches = existing.compactMap {
            updatedDictionary[$0.id]
        }
        
        let newMatches = updated.filter { updatedMatch in
            !existing.contains {
                $0.id == updatedMatch.id
            }
        }
        
        return existingMatches + newMatches
    }
    
    // MARK: - Private Networking
    
    private func fetchSports() async {
        
        if !hasLoadedInitialData {
            isLoading = true
        }
    
        errorMessage = nil
        
        defer {
            isLoading = false
            hasLoadedInitialData = true
        }
        
        do {
            let matches = try await service.fetchSports()
        
            priceChanges = priceTracker.update(
                matches: matches
            )
            
            sportsMatches = mergeMatches(
                existing: sportsMatches,
                updated: matches
            )
            
            try? await cacheService.saveSports(
                matches
            )
            
        } catch {
            errorMessage = error.localizedDescription
        }
    }
    
    private func fetchEsports() async {
        
        if !hasLoadedInitialData {
            isLoading = true
        }

        errorMessage = nil
        
        defer {
            isLoading = false
            hasLoadedInitialData = true
        }
        
        do {
            let matches = try await service.fetchEsports()
            priceChanges = priceTracker.update(matches: matches)
            esportsMatches = mergeMatches(existing: esportsMatches, updated: matches)
            try? await cacheService.saveEsports(matches)
        } catch {
            errorMessage = error.localizedDescription
        }
    }
}
