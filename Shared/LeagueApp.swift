//
//  LeagueApp.swift
//  Shared
//
//  Created by Sveagruva on 12.05.2022.
//

import SwiftUI

@main
struct LeagueApp: App {
	var body: some Scene {
		WindowGroup {
			ContentView()
				.frame(minWidth: 400, idealWidth: 500, maxWidth: .infinity, minHeight: 400, idealHeight: 500, maxHeight: .infinity)
				.environmentObject(AppState())
				.environmentObject(CacheRawData())
		}
	}
}
