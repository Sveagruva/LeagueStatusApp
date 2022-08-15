//
//  State.swift
//  League
//
//  Created by Sveagruva on 12.05.2022.
//

import Foundation
import SwiftUI

class AppState: ObservableObject {
	@AppStorage("chosenLanguage") var chosenLanguage: String = "en_US"



	init() {

	}
}
