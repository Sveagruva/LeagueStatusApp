//
//  CacheRawData.swift
//  League
//
//  Created by Sveagruva on 30.05.2022.
//

import Foundation
import Combine

class CacheRawData: ObservableObject {
	var cachedData: [String: Data] = [:]
	var waitingFor: [String: Bool] = [:]
	var addons: [String: [(Data) -> Void]] = [:]

	init() {}

	func downloadOrUseCache(url: String, addon: @escaping (Data) -> Void) {
		useDataWhenReady(key: url, addon: addon)
		if (waitingFor[url] != true) {
			downloadToCache(url: url)
		}
	}

	private func downloadToCache(url: String) -> Void {
		waitingFor[url] = true
		API.download(url: url) { [weak self] data in
			guard let `self` = self else {
				return
			}

			self.cachedData[url] = data
			self.waitingFor.removeValue(forKey: url)


			guard let addons = self.addons[url] else {
				return
			}

			self.addons.removeValue(forKey: url)
			addons.forEach { addon in
				addon(data)
			}
		}
	}

	private func useDataWhenReady(key: String, addon: @escaping (Data) -> Void) -> Void {
		if (cachedData[key] != nil) {
			addon(cachedData[key]!)
		} else {
			if addons[key] == nil {
				addons[key] = []
			}

			addons[key]!.append(
				addon
			)
		}
	}
}
