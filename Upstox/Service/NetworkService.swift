//
//  NetworkService.swift
//  Upstox
//
//  Created by Karthik Rashinkar on 21/11/24.
//

import Foundation

class NetworkService {
    static func fetchHoldings() async throws -> [Holding] {
        
        guard let url = URL(string: "https://35dee773a9ec441e9f38d5fc249406ce.api.mockbin.io/") else {
            throw NetworkError.invalidUrl
        }
        
        let (data, response) = try await URLSession.shared.data(from: url)
        
        guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
            throw NetworkError.invalidResponse
        }
        
        let responseData = try JSONDecoder().decode(HoldingsResponse.self, from: data)
        return responseData.data.userHolding
    }
}

