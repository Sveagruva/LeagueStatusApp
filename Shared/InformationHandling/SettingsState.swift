//
//  State.swift
//  League
//
//  Created by Sveagruva on 12.05.2022.
//

import Foundation
import SwiftUI

class SettingsState: ObservableObject {
	@AppStorage("chosenPath") var chosenPath: String = ""
	@AppStorage("chosenLanguage") var chosenLanguage: String = "en_US"
	@AppStorage("doUseLatestPath") var doUseLatestPath: Bool = true


	@Published var languages: [String] = []
	@Published var patches: [String] = []
	var isRequestingPatches: Bool = false
	var isRequestingLanguages: Bool = false
	var firstTime: Bool = true


	func updateServerKeys() {
		firstTime = false
		isRequestingPatches = true
		API.getPatches { patches in
			self.patches = patches
			self.isRequestingPatches = false
		}

		API.getLanguages { languages in
			self.languages = languages
			self.isRequestingLanguages = false
		}
	}
}
