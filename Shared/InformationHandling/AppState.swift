//
//  State.swift
//  League
//
//  Created by Sveagruva on 12.05.2022.
//

import Foundation
import SwiftUI

class AppState: ObservableObject {
	@Published var languages: [String] = []
	@Published var patches: [String] = []
	var isRequestingPatches: Bool = false
	var firstTime: Bool = true

	@AppStorage("chosenLanguage") var chosenLanguage: String = "en_US"

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
