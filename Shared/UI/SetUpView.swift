//
// Created by Sveagruva on 02.07.2022.
//

import Foundation
import SwiftUI

struct SetUpView: View {
	@EnvironmentObject var state: AppState

	var body: some View {
		Text("Set Up")
		  .padding(10)
		SettingsView()
		  .frame(maxWidth: .infinity, maxHeight: .infinity)
	}
}
