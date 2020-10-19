//
//  TournamentManagerApp.swift
//  TournamentManager
//
//  Created by Dix Lorenz on 13.10.20.
//

import SwiftUI

@main
struct TournamentManagerApp: App {
   private var data : Tournament = testTournament

    var body: some Scene {
        WindowGroup {
            ContentView(data: self.data)
        }
    }
}
