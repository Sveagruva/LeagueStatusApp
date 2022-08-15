//
// Created by Sveagruva on 19.06.2022.
//

import Foundation
import SwiftUI
import UserNotifications

struct SettingsView: View {
	@EnvironmentObject var state: AppState
	@EnvironmentObject var settingsState: SettingsState
	@State var chosenPath: String = UserDefaults.standard.string(forKey: "chosenPath") ?? ""
	@State var chosenLanguage: String = UserDefaults.standard.string(forKey: "chosenLanguage") ?? "en_US"
	@State var errorMsg: String? = nil
	static let widthMin = CGFloat(270)

	var body: some View {
		if(settingsState.firstTime) {
			let _ = settingsState.updateServerKeys()
		}

		if(settingsState.isRequestingPatches || settingsState.isRequestingLanguages) {
			// progress indicator
				ProgressView()
					.frame(maxWidth: .infinity, maxHeight: .infinity)
		} else {
			if(chosenPath == "" && settingsState.patches.count > 0 && settingsState.doUseLatestPath) {
				let _ = chosenPath = settingsState.patches[0]
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
			Text("Latest Path: \(settingsState.patches.count > 0 ? settingsState.patches[0] : "loading latest path")")
			Form {
				Toggle("Use latest path", isOn: $settingsState.doUseLatestPath)
			}
			  .padding(5)
			  // if doUseLatestPath is true then set chosenPath to latest path
			  .onChange(of: settingsState.doUseLatestPath) { (newValue) in
				  if(newValue) {
					  chosenPath = settingsState.patches[0]
				  }
			  }

			// if doUseLatestPath is false then show the path picker from state.patches
			if(!settingsState.doUseLatestPath) {
				Picker("Path", selection: $chosenPath) {
					ForEach(settingsState.patches, id: \.self) { path in
						Text(path)
					}
				}
			}

			Spacer()
			  .frame(height: 30)

			if(settingsState.languages.count > 0) {
				Picker("Language", selection: $chosenLanguage) {
					ForEach(settingsState.languages, id: \.self) { language in
						Text(language)
					}
				}

				Spacer()
				  .frame(height: 30)
			}

			HStack {
				Button(action: {
					settingsState.chosenPath = ""
				}, label: {
					Text("Reset")
				})

				Spacer()

				Button(action: {
					if(settingsState.doUseLatestPath) {
						if(settingsState.patches.count > 0) {
							settingsState.chosenPath = settingsState.patches[0]
							errorMsg = nil
						} else {
							errorMsg = "Latest path not loaded"
						}
					} else {
						if(chosenPath != ""){
							settingsState.chosenPath = chosenPath
							errorMsg = nil
						} else {
							errorMsg = "Choose a path"
						}
					}

					if(settingsState.chosenLanguage != chosenLanguage) {
						settingsState.chosenLanguage = chosenLanguage
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
