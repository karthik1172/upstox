//
//  HoldingsResponse.swift
//  Upstox
//
//  Created by Karthik Rashinkar on 21/11/24.
//

import Foundation
// Root response structure
struct HoldingsResponse: Codable {
    let data: HoldingsData
}

struct HoldingsData: Codable {
    let userHolding: [Holding]
}

// Updated Holding model
struct Holding: Codable {
    let symbol: String
    let quantity: Int
    let ltp: Double
    let avgPrice: Double
    let close: Double
    
    // Computed properties for existing calculations
    var lastTradedPrice: Double { ltp }
    var closePrice: Double { close }
    var name: String { symbol }  // Using symbol as name since original model had a name
}

