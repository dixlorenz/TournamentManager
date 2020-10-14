//
//  TournamentManagerApp.swift
//  TournamentManager
//
//  Created by Dix Lorenz on 13.10.20.
//

import SwiftUI

@main
struct TournamentManagerApp: App {
   @StateObject private var data : TournamentData = testData//TournamentData()

    var body: some Scene {
        WindowGroup {
            ContentView(data: self.data)
        }
    }
}
