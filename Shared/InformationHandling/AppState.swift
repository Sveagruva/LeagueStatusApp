//
//  State.swift
//  League
//
//  Created by Sveagruva on 12.05.2022.
//

import Foundation
import SwiftUI

class AppState: ObservableObject {
	@AppStorage("chosenPath") var chosenPath: String = ""
	@AppStorage("chosenLanguage") var chosenLanguage: String = "en_US"
	@AppStorage("doUseLatestPath") var doUseLatestPath: Bool = true

	@Published var languages: [String] = []
//	@Published var champions: [Champion] = []
	@Published var patches: [String] = []
	@Published var isRequestingPatches: Bool = false
	var firstTime: Bool = true

	func getPatches() {
		firstTime = false
		isRequestingPatches = true
		API.getPatches { patches in
			self.patches = patches
			self.isRequestingPatches = false
		}
	}

	init() {
//		if(UserDefaults.standard.object(forKey: "champions") == nil) {
//			UserDefaults.standard.set([:], forKey: "champions")
//		}
//
////		if(UserDefaults.standard.object(forKey: "basicChampions") == nil) {
//			UserDefaults.standard.set(try! NSKeyedArchiver.archivedData(withRootObject: [:], requiringSecureCoding: false), forKey: "basicChampions")
////		}
	}
}
