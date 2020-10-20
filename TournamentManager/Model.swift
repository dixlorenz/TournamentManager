//
//  Model.swift
//  TournamentManager
//
//  Created by Dix Lorenz on 13.10.20.
//

import Foundation

let games_per_station = 2
let max_group_size = 4

func divide_up(x: Int, y: Int) -> Int { (x + y - 1) / y }

public struct Player {
   var name: String
   var gamer_tag: String?
   
   func display_name() -> String { return gamer_tag ?? name }
   func display_gamertag() -> String? {
      if gamer_tag != nil {
         return name
      } else {
         return nil
      }
   }
}

struct Station {
   var name: String
   var games: [String] = []
   
   func validate() -> Bool {
      return games.count == 2
   }
}

struct Match {
   var game : String
   var players: [Player] = []

   func fitness() -> Double {
      return 1
   }

   func display() {
      print(game, ": ", players.map { $0.display_name() })
   }
   
   func validate() -> Bool {
      let names = Set<String>(players.map { $0.name })
      return names.count == players.count
   }
}

struct SubRound {
   var matches : [Match] = []

   func fitness() -> Double {
      return matches.reduce(0.0, { $0 + $1.fitness() })
   }
   
   func display() {
      for m in matches {
         m.display()
      }
   }
}

struct Round {
   var number : Int
   var sub_rounds : [SubRound] = []

   func fitness() -> Double {
      return sub_rounds.reduce(0.0, { $0 + $1.fitness() })
   }

   func display() {
      print("Round", number)
      for sr in sub_rounds {
         print("--")
         sr.display()
      }
      print("--")
   }
}

struct Schedule {
   var rounds : [Round]
   
   func fitness() -> Double {
      return rounds.reduce(0.0, { $0 + $1.fitness() })
   }

   func display() {
      for round in rounds {
         round.display()
      }
   }
}

struct Tournament {
   var players: [Player] = []
   var stations: [Station] = []
   
   init(players: [Player], stations: [Station]) {
      self.players = players
      self.stations = stations
      while (max_group_size * self.stations.count) < players.count {
         self.stations.append(stationPause)
      }
   }
   
   func make_schedule() -> Schedule {
      var schedule = Schedule(rounds: [])
      
      for round_number in 1...games_per_station {
         var round = schedule_round(number: round_number)

         var fails = 0
      
         while round == nil {
            fails = fails + 1

            round = schedule_round(number: round_number)
         }
         
         if fails > 0 {
            print("\(fails) fails")
         }
         schedule.rounds.append(round!)
      }
      
      return schedule
   }
   
   func schedule() -> Schedule {
      var schedules: [Schedule] = []
      
      //for _ in 0...256 {
         schedules.append(make_schedule())
      //}
      
      return schedules.max(by: { $0.fitness() < $1.fitness() } )!
   }
   
   func schedule_round(number: Int) -> Round? {
      let stations_bucket = Set<Int>(0...stations.count - 1)
      
      var round = Round(number:number)
      
      let new_matches = stations.map { Match(game: $0.games[number - 1]) }
      
      var assignments_needed = players.count * stations.count
      
      var players_missing_stations = players.map(
         {(p: Player) -> (player: Player, missing: Set<Int>) in
            return (p, stations_bucket)
         })
      
      var dark_station : Int?
      
      dark_station = stations.count - 1
      
      while assignments_needed > 0 {
         // new subround
         var current_station = 0
         
         var available_players = Set<Int>(0..<players.count)
         var matches = new_matches
         
         var x = 0
         
         while !available_players.isEmpty {
            if let dark = dark_station {
               if dark == current_station {
                  current_station = (current_station + 1) % stations.count
                  continue
               }
            }
            if matches[current_station].players.count < max_group_size {
               let player_idx = Int.random(in: 0..<players.count)
               var assigned_station = false
               for i in 0..<players.count {
                  let check_player_idx = (player_idx + i) % players.count
                  if !assigned_station
                        && players_missing_stations[check_player_idx].missing.contains(current_station)
                        && available_players.contains(check_player_idx)  {
                     players_missing_stations[check_player_idx].missing.remove(current_station)
                     available_players.remove(check_player_idx)
                     matches[current_station].players.append(players[check_player_idx])
                     assigned_station = true
                     assignments_needed = assignments_needed - 1
                  }
               }
            }
            
            current_station = (current_station + 1) % stations.count
            x = x + 1
            if x > 1000 {
               return nil
            }
         }
         
         var min_size = max_group_size
         var max_size = 0
         
         for m in matches {
            if m.players.count > 0 {
               min_size = min(min_size, m.players.count)
            }
            max_size = max(max_size, m.players.count)
         }
         
         if (max_size - min_size) > 1 {
            return nil
         }
         
         round.sub_rounds.append(SubRound(matches: matches))
         
         if let dark = dark_station {
            dark_station = (dark + 1) % stations.count
         }
      }
      
      
      
      return round
   }
}

let roster = [
   Player(name: "Dix", gamer_tag: "Argelix"),
   Player(name: "Lars", gamer_tag: "Shortround"),
   Player(name: "Devin", gamer_tag: "DevLord"),
   Player(name: "Chantal", gamer_tag: "Carlotta"),
   Player(name: "Volker"),
   Player(name: "Bettina"),
   Player(name: "Carola"),
   Player(name: "Tanni"),
   Player(name: "Flori"),
   Player(name: "Iris"),
   Player(name: "Kevin"),
   Player(name: "Thomas")
]

let station_list = [
   Station(name: "Pubgames", games: ["Darts", "Billard"]),
   Station(name: "Fitness", games: ["Arms & Legs", "Core & Legs"]),
   Station(name: "Central", games: ["Mario Kart", "Just Dance"]),
   Station(name: "Pause", games: ["Relax", "Chill"])
]

let stationPause = Station(name: "Pause", games: ["Relax", "Chill"])

let testTournament = Tournament(players: roster, stations: station_list)
