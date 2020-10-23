//
//  main.swift
//  makeschedule
//
//  Created by Dix Lorenz on 23.10.20.
//

import Foundation


func make_schedule() -> Schedule
{
      //let players = make_players(n: players)
      //let stations = make_stations(n: stations)

      let tournament = Tournament(players: roster, stations: station_list)

      return tournament.schedule()
}

//      let tournament = Tournament(players: roster, stations: station_list)

      let schedule = make_schedule()

      schedule.display()

      //print(tournament.schedule())

