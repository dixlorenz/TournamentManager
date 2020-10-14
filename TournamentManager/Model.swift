//
//  Model.swift
//  TournamentManager
//
//  Created by Dix Lorenz on 13.10.20.
//

import Foundation

class Player : Identifiable, ObservableObject {
   var id = UUID()

   @Published var name: String
   @Published var gamer_tag: String?

   init(name: String, gamer_tag: String? = nil) {
      self.name = name
      self.gamer_tag = gamer_tag
   }

   func display_name() -> String { return gamer_tag ?? name }
   func display_gamertag() -> String? {
      if gamer_tag != nil {
         return name
      } else {
         return nil
      }
   }
}

struct Room {
   var name: String
}

class TournamentData : ObservableObject {
   @Published var players: [Player] = []

   init(players: [Player] = []) {
      self.players = players
   }
}

#if DEBUG

let testPlayers = [
   Player(name: "Dix", gamer_tag: "Argelix"),
   Player(name: "Lars", gamer_tag: "Shortround"),
   Player(name: "Devin", gamer_tag: "DevLord"),
   Player(name: "Chantal"),
   Player(name: "Volker"),
   Player(name: "Bettina")
]

let testData = TournamentData(players: testPlayers)

#endif
