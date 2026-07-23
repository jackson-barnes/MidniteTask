//
//  MidniteTaskApp.swift
//  MidniteTask
//
//  Created by Jackson Barnes on 22/07/2026.
//

import SwiftUI

@main
struct MidniteTaskApp: App {
    
    var body: some Scene {
        
        WindowGroup {
            NavigationStack {
                SportsBookView()
            }
            .preferredColorScheme(.dark)
        }
    }
}
