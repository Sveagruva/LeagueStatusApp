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
		VStack {
			let _ = print("content View rebuild")
			if(UserDefaults.standard.string(forKey: "chosenPath") == "") {
				SetUpView()
			} else {
				ChampionsListView(path: UserDefaults.standard.string(forKey: "chosenPath")!)
			}
		}
	}
}
