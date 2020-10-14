//
//  PlayerViews.swift
//  TournamentManager
//
//  Created by Dix Lorenz on 13.10.20.
//

import SwiftUI

func ??<T>(lhs: Binding<Optional<T>>, rhs: T) -> Binding<T> {
   Binding(
      get: { lhs.wrappedValue ?? rhs },
      set: { lhs.wrappedValue = $0 }
   )
}

struct PlayerList: View {
   @ObservedObject var data : TournamentData = TournamentData()

   //@StateObject private var 

   var body: some View {
      NavigationView {
         List {
            ForEach(data.players) { player in
               PlayerCell(player:player)
            }
            .onMove(perform: movePlayers)
            .onDelete(perform: deletePlayers)
         }.navigationTitle("Players").toolbar {
            EditButton()
            Button("Add", action: addPlayer)
        }
      }.navigationViewStyle(StackNavigationViewStyle())
   }

   func addPlayer() {
      withAnimation {
         data.players.append(Player(name: "God", gamer_tag: "BigBoss"))
      }
   }

   func movePlayers(from: IndexSet, to: Int) {
      withAnimation {
         data.players.move(fromOffsets: from, toOffset: to)
      }
   }

   func deletePlayers(offsets: IndexSet) {
      withAnimation {
         data.players.remove(atOffsets: offsets)
      }
   }
}

struct PlayerCell: View {
   var player: Player

   var body: some View {
      NavigationLink(destination: PlayerDetail(player:player)) {
         Image(systemName: "photo")
         VStack(alignment: .leading) {
            Text(player.display_name())
            if player.display_gamertag() != nil {
               Text(player.name).font(.subheadline).foregroundColor(.secondary)
            }
         }
      }.navigationTitle("Players")
   }
}

struct PlayerDetail : View {
   @State var player : Player

   var body : some View {
      Form {
         HStack {
            Text("Name")
            Spacer()
            TextField("Name", text:$player.name)
         }
         HStack {
            Text("Gamer-Tag")
            Spacer()
            TextField("Name", text:$player.gamer_tag ?? "")
         }
      }
   }
}

#if DEBUG
struct PlayerViews_Previews: PreviewProvider {
   @StateObject private static var data : TournamentData = testData

   static var previews: some View {
      PlayerList(data:data)
         .previewDevice("iPad Pro (9.7-inch)")
         
   }
}
#endif
