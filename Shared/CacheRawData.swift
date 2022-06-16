//
//  CacheRawData.swift
//  League
//
//  Created by Sveagruva on 30.05.2022.
//

import Foundation
import Combine

// ObservableObject because env obj. render logic on the user
class CacheRawData: ObservableObject {
	var datas: [String: Data] = [:]
//    var pubs: [String: (Result<Data, Never>) -> Void] = [:]
	var waitingFor: [String: Bool] = [:]
	var addons: [String: [(Data) -> Void]] = [:]

	init() {

	}

	func createDependency(url: String) -> Void {
		waitingFor[url] = true
		API.download(url: url) { [weak self] data in
			guard let `self` = self else {
				return
			}

			self.datas[url] = data
			self.waitingFor.removeValue(forKey: url)
			self.addons[url]!.forEach { addon in
//                DispatchQueue.main.sync {
				addon(data)
//                }
			}
		}
	}

	func isDependency(key: String) -> Bool {
		return waitingFor[key] == true
	}

	func addToDependency(key: String, addon: @escaping (Data) -> Void) -> Void {
		if (!self.isDependency(key: key)) {
			addon(self.get(key: key)!)
		} else {

			if addons[key] == nil {
				addons[key] = []
			}

			addons[key]!.append(
				addon
			)
		}
	}

//    func set(key: String, data: Data) {
//        let future = futures[key]
//
//        if(future != nil) {
//            print("set clearing")
//            futures[key] = nil
//            addons[key] = []
//        }
//
//        datas[key] = data
//    }

	func get(key: String) -> Data? {
		return datas[key]
	}
}
