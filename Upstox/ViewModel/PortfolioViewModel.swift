//
//  ViewModel.swift
//  Upstox
//
//  Created by Karthik Rashinkar on 21/11/24.
//

import Foundation
import SwiftUI

enum NetworkError: Error {
    case invalidUrl
    case invalidResponse
}

@MainActor
@Observable
class PortfolioViewModel {
     var holdings: [Holding] = []
     var summary: PortfolioSummary?
     var isLoading = false
     var error: Error?
    
    func fetchHoldings() {
        Task {
            isLoading = true
            do {
                holdings = try await NetworkService.fetchHoldings()
               
                calculateSummary()
            } catch {
                print(error)
            }
            isLoading = false
        }
    }
    
    private func calculateSummary() {
        let currentValue = holdings.reduce(0) { $0 + ($1.lastTradedPrice * Double($1.quantity)) }
        let totalInvestment = holdings.reduce(0) { $0 + ($1.avgPrice * Double($1.quantity)) }
        let totalPNL = currentValue - totalInvestment
        let todaysPNL = holdings.reduce(0) { $0 + (($1.closePrice - $1.lastTradedPrice) * Double($1.quantity)) }
        
        summary = PortfolioSummary(
            currentValue: currentValue,
            totalInvestment: totalInvestment,
            totalPNL: totalPNL,
            todaysPNL: todaysPNL
        )
    }
}
