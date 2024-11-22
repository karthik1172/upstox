//
//  PortfoliView.swift
//  Upstox
//
//  Created by Karthik Rashinkar on 21/11/24.
//

import SwiftUI

struct PortfoliView: View {
    @State private var viewModel = PortfolioViewModel()
    @State private var isExpanded = false
    @State private var selectedDetent: PresentationDetent = .fraction(0.15)
    
    var body: some View {
        NavigationView {
            VStack {
                holdingsListView
                    .sheet(isPresented: .constant(true)) {
                        VStack {
                            summaryContent()
                        }
                        .presentationDetents([.fraction(0.15), .medium], selection: $selectedDetent)
                        .presentationDragIndicator(.visible)
                        .interactiveDismissDisabled()
                        .presentationBackgroundInteraction(.enabled(upThrough: .fraction(0.15)))
                    }
            }
            .navigationTitle("My Portfolio")
            .task {
                viewModel.fetchHoldings()
                print(viewModel.holdings)
            }
        }
    }
    
    @ViewBuilder
    private func summaryContent() -> some View {
        if selectedDetent == .medium {
            VStack(alignment: .leading, spacing: 10) {
                HStack {
                    Text("Portfolio Summary")
                        .font(.headline)
                    Spacer()
                    
                }
                
                if let summary = viewModel.summary {
                    VStack {
                        summaryRowView(title: "Current Value", value: summary.currentValue)
                        summaryRowView(title: "Total Investment", value: summary.totalInvestment)
                        summaryRowView(title: "Total P&L", value: summary.totalPNL, isProfit: summary.totalPNL >= 0)
                        summaryRowView(title: "Today's P&L", value: summary.todaysPNL, isProfit: summary.todaysPNL >= 0)
                    }
                }
            }
            .padding()
            .background(Color.gray.opacity(0.1))
            .cornerRadius(10)
        }
        else {
            if let summary = viewModel.summary {
                VStack {
                    summaryRowView(title: "Today's P&L", value: summary.todaysPNL, isProfit: summary.todaysPNL >= 0)
                        .background(RoundedRectangle(cornerRadius: 10).fill(Color.black).opacity(0.2))
                }
            }
        }
    }
    
    private func summaryRowView(title: String, value: Double, isProfit: Bool = true, holdingList: Bool = false) -> some View {
        HStack {
            Text(title)
            Spacer()
            Text(String(format: "₹ %.2f", value))
                .foregroundColor(isProfit ? .green : .red)
        }
        .padding()
    }
    
    private var holdingsListView: some View {
        List(viewModel.holdings, id: \.name) { holding in
            HStack {
                VStack(alignment: .leading) {
                    Text(holding.symbol)
                        .font(.headline)
                    
                    Text(String(format: "NET QTY: %d", holding.quantity))
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
                Spacer()
                VStack(alignment: .trailing) {
                    
                    Text(String(format: "LTP: ₹ %.2f", holding.lastTradedPrice))
                }
            }
            .padding(.vertical, 8)
        }
        .listStyle(PlainListStyle())
        .transition(.slide)
    }
}

#Preview {
    PortfoliView()
}
