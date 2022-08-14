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
}
