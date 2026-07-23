//
//  MidniteTheme.swift
//  MidniteTask
//
//  Created by Jackson Barnes on 23/07/2026.
//

import SwiftUI

enum MidniteTheme {
    
    // MARK: - Backgrounds
    
    static let background = Color(
        red: 0.04,
        green: 0.04,
        blue: 0.05
    )
    
    static let surface = Color(
        red: 0.09,
        green: 0.09,
        blue: 0.11
    )
    
    static let surfaceSecondary = Color(
        red: 0.14,
        green: 0.14,
        blue: 0.17
    )
    
    
    // MARK: - Brand
    
    static let primary = Color(
        red: 0.62,
        green: 0.35,
        blue: 1.0
    )
    
    static let accent = Color(
        red: 0.82,
        green: 0.25,
        blue: 0.95
    )
    
    
    // MARK: - States
    
    static let live = Color.red
    
    static let upcoming = Color.orange
    
    static let positive = Color.green
    
    static let negative = Color.red
    
    
    // MARK: - Text
    
    static let textPrimary = Color.white
    
    static let textSecondary = Color(
        white: 0.65
    )
}
