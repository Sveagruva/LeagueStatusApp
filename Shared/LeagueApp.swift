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
		let state = AppState()
		let settings = SettingsState()

		WindowGroup {
			ContentView()
			  .frame(minWidth: 400, idealWidth: 500, maxWidth: .infinity, minHeight: 400, idealHeight: 500, maxHeight: .infinity)
			  .environmentObject(state)
			  .environmentObject(settings)
			  .environmentObject(CacheRawData())
		}

		#if os(macOS)
		Settings {
			SettingsView()
			  .environmentObject(state)
			  .environmentObject(settings)
			  .frame(width: SettingsView.widthMin)
		}
		#endif
	}
}
