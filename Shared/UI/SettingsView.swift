//
// Created by Sveagruva on 19.06.2022.
//

import Foundation
import SwiftUI
import UserNotifications

struct SettingsView: View {
	@EnvironmentObject var state: AppState
	@State var chosenPath: String = UserDefaults.standard.string(forKey: "chosenPath") ?? ""
	@State var errorMsg: String? = nil
	static let widthMin = CGFloat(270)

	var body: some View {
		if(state.firstTime) {
			let _ = state.getPatches()
		}

		if(state.isRequestingPatches) {
			// progress indicator
				ProgressView()
					.frame(maxWidth: .infinity, maxHeight: .infinity)
		} else {
			if(chosenPath == "" && state.patches.count > 0 && state.doUseLatestPath) {
				let _ = chosenPath = state.patches[0]
			}

			HStack {
				Spacer()
				  .frame(width: .infinity)
				SettingsBody
				  .padding(20)
				  .frame(minWidth: SettingsView.widthMin)
				Spacer()
				  .frame(width: .infinity)
			}
			  .padding(20)
		}
	}

	var SettingsBody: some View {
		VStack {
			Spacer()
			  .frame(height: 0)

			Text("Path: \(chosenPath == "" ? "not set" : chosenPath)")
			Text("Latest Path: \(state.patches.count > 0 ? state.patches[0] : "loading latest path")")
			Form {
				Toggle("Use latest path", isOn: $state.doUseLatestPath)
			}
			  .padding(5)
			  // if doUseLatestPath is true then set chosenPath to latest path
			  .onChange(of: state.doUseLatestPath) { (newValue) in
				  if(newValue) {
					  chosenPath = state.patches[0]
				  }
			  }

			// if doUseLatestPath is false then show the path picker from state.patches
			if(!state.doUseLatestPath) {
				Picker("Path", selection: $chosenPath) {
					ForEach(state.patches, id: \.self) { path in
						Text(path)
					}
				}
			}

			Spacer()
			  .frame(height: 30)

			HStack {
				Button(action: {
					state.chosenPath = ""
				}, label: {
					Text("Reset")
				})

				Spacer()

				Button(action: {
					if(state.doUseLatestPath) {
						if(state.patches.count > 0) {
							state.chosenPath = state.patches[0]
							errorMsg = nil
						} else {
							errorMsg = "Latest path not loaded"
						}
					} else {
						if(chosenPath != ""){
							state.chosenPath = chosenPath
							errorMsg = nil
						} else {
							errorMsg = "Choose a path"
						}
					}

					// make sure that we have rights to notifications for macOS
					if #available(OSX 10.15, *) {
						UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { (granted, error) in
							if granted {
								// check if errorMsg exists and if it does push notification
								if(errorMsg != nil) {
									print(errorMsg!)
									let content = UNMutableNotificationContent()
									content.title = "Error"
									content.body = errorMsg!
									content.sound = UNNotificationSound.default
									// push notification without time interval
									let request = UNNotificationRequest(identifier: "error", content: content, trigger: nil)
									UNUserNotificationCenter.current().add(request)
								}

							} else {
								print("Notifications are not allowed")
							}
						}
					}

				}) {
					Text("Save")
				}
			}

			Spacer()
			  .frame(height: 0)
		}
	}
}
