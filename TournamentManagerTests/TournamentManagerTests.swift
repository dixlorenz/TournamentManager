//
//  TournamentManagerTests.swift
//  TournamentManagerTests
//
//  Created by Dix Lorenz on 13.10.20.
//

import XCTest
@testable import TournamentManager

func make_players(n: Int) -> [Player]
{
   var players : [Player] = []
   
   for i in 1...n {
      players.append(Player(name: "Player \(i)"))
   }
   
   return players
}

func make_stations(n: Int) -> [Station]
{
   var stations : [Station] = []
   
   for i in 1...n {
      stations.append(Station(name: "Station \(i)", games: ["Station \(i)-1", "Station \(i)-2"]))
   }
   
   return stations
}

func make_schedule(players: Int, stations: Int) -> [Round]
{
      //let players = make_players(n: players)
      //let stations = make_stations(n: stations)
      
      let tournament = Tournament(players: roster, stations: station_list)
      
      return tournament.schedule()!
}

class TournamentManagerTests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testSchedule_1() throws {
      let schedule = make_schedule(players: 15, stations: 4)
      
      for round in schedule {
         round.display()
      }

      XCTAssert(schedule.count == 2)
    }
}
