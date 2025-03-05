//
//  ContentView.swift
//  BasketballGames
//
//  Created by Samuel Shi on 2/27/25.
//

import SwiftUI

struct Game: Codable {
    var id: Int
    
    var date: String
    var team: String
    var score: Score
    var isHomeGame: Bool
    var opponent: String
}

struct Score: Codable {
    var opponent: Int
    var unc: Int
}

struct ContentView: View {
    @State private var results: [Game] = []
    
    var body: some View {
        NavigationStack {
            List(results, id: \.id) { game in
                VStack {
                    HStack {
                        Text("\(game.team) vs. \(game.opponent)")
                        
                        Spacer()
                        
                        Text("\(game.score.unc) - \(game.score.opponent)")
                    }
                    
                    HStack {
                        Text("\(game.date)")
                        
                        Spacer()
                        
                        Text("\(game.isHomeGame ? "Home" : "Away")")
                    }
                    .font(.caption)
                    .foregroundStyle(.secondary)
                }
            }
            .task {
                await loadData()
            }
            .navigationTitle(Text("UNC Basketball"))
        }
    }
    
    func loadData() async {
        guard let url = URL(string: "https://api.samuelshi.com/uncbasketball")
        else {
            print("Invalid URL")
            
            return
        }
        
        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            
            let decodedResponse = try JSONDecoder().decode([Game].self, from: data)
            results = decodedResponse
        } catch {
            print("Invalid Data \(error)")
        }
    }
}

#Preview {
    ContentView()
}
