//
//  ContentView.swift
//  Shared
//
//  Created by Sveagruva on 12.05.2022.
//

import SwiftUI


struct ContentView: View {
	@EnvironmentObject var state: AppState
	@EnvironmentObject var cache: CacheRawData

	var body: some View {
//		NavigationView {
//			VStack {
//				Text("hi")
//			}
			ChampionsList()
//		}
	}
}
