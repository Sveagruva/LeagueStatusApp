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
		if(UserDefaults.standard.string(forKey: "chosenPath") == "") {
			SetUpView()
		} else {
			ChampionsListView(path: state.chosenPath)
		}
	}
}
