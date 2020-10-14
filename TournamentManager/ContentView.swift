//
//  ContentView.swift
//  TournamentManager
//
//  Created by Dix Lorenz on 13.10.20.
//

import SwiftUI

struct ContentView: View {
   @ObservedObject var data : TournamentData

   var body: some View {
      TabView {
            PlayerList(data: self.data).padding().tabItem { Text("Players") }.tag(1)

         Text("Tab Content 2").tabItem { Text("TextLabel 2") }.tag(2)
      }
   }
}

#if DEBUG
struct ContentView_Previews: PreviewProvider {
   static var previews: some View {
      ContentView(data: testData)
   }
}
#endif
