//
// Created by Sveagruva on 22.07.2022.
//

import Foundation

class DataProvider {

	static func getChampions(path: String, language: String, completion: @escaping ([Champion]) -> Void) {
		let key = "basicChampions_" + path

		if let data = UserDefaults.standard.value(forKey: key) as? Data {
			completion(try! PropertyListDecoder().decode([Champion].self, from: data))
		} else {
			API.getChampions(path: path, language: language) { champs in
				UserDefaults.standard.set(try? PropertyListEncoder().encode(champs), forKey: key)
				completion(champs)
			}
		}
	}
}