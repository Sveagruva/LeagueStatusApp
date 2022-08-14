//
//  API.swift
//  League (macOS)
//
//  Created by Sveagruva on 12.05.2022.
//

import Foundation
import SwiftUI

class API {
	static let base = "https://ddragon.leagueoflegends.com/cdn"
	static let languagesURL = "\(API.base)/languages.json"
	static let patchesURL = "https://ddragon.leagueoflegends.com/api/versions.json"

	static private func getChampionURL(language: String, path: String) -> String {
		return "\(API.base)/\(path)/data/\(language)/champion.json";
	}

	static private func getChampionSkinURL(language: String, path: String, name: String) -> String {
		return "\(API.base)/\(path)/data/\(language)/champion/\(name).json";
	}

	static private func getChampionSpecificSkinURL(name: String, num: Int) -> String {
		return "\(API.base)/img/champion/splash/\(name)_\(num).jpg";
	}



	static func getChampions(path: String, language: String, callback: @escaping ([Champion]) -> Void) {
		guard let url = URL(string: API.getChampionURL(language: language, path: path)) else {
			return
		}

		struct jsonResponse: Codable {
			let type: String
			let format: String
			let version: String
			let data: [String: data]

			struct data: Codable {
				let version: String
				let id: String
				let key: String
				let name: String
				let title: String
				let blurb: String
				let info: [String: Int]
				let partype: String
				let image: image

				struct image: Codable {
					let full: String
					let sprite: String
					let group: String
					let x: Float
					let y: Float
					let w: Float
					let h: Float
				}

				let tags: [String]
				let stats: [String: Float]
			}
		}

		let task = URLSession.shared.dataTask(with: url, completionHandler: { data, response, error in
			do {
				guard let data = data, error == nil else {
					print("cannot request shit \(error!)")
					return
				}

				let json: jsonResponse = try JSONDecoder().decode(jsonResponse.self, from: data)

				var realShit: [Champion] = []
				for (_, value) in json.data {
					realShit.append(Champion(
						language: language, path: path, name: value.name, id: value.id, title: value.title, blurb: value.blurb, stats: value.stats
					))
//                    break
				}

				DispatchQueue.main.sync {
					callback(realShit)
				}
			} catch {
				print("cannot decode shit \(error)")
			}
		})

		task.resume()
	}

	static func getChampionFullInfo(champion: Champion, callback: @escaping (AdvancedChampionInfo) -> Void) {
		guard
			let url = URL(string: API.getChampionSkinURL(language: champion.language, path: champion.path, name: champion.id))
		else {
			return
		}

		struct jsonResponse: Codable {
			let type: String
			let format: String
			let version: String
			let data: [String: data]

			struct data: Codable {
				let id: String
				let name: String
				let skins: [Skin]
				let passive: Passive

				struct Skin: Codable {
					let num: Int
					let name: String
					let chromas: Bool
				}

				struct Passive: Codable {
					let name: String
					let description: String
					let image: PassiveImage

					struct PassiveImage: Codable {
						let full: String
					}
				}
			}
		}


		let task = URLSession.shared.dataTask(with: url, completionHandler: { data, response, error in
			do {
				guard let data = data, error == nil else {
					print("cannot request shit \(error!)")
					return
				}

				let json: jsonResponse = try JSONDecoder().decode(jsonResponse.self, from: data)

				DispatchQueue.main.sync {
					let champ = json.data[champion.id]!
					let passive = AdvancedChampionInfo.Passive(language: champion.language, path: champion.path, name: champ.passive.name, description: champ.passive.description, image: champ.passive.image.full)
					let skins = champ.skins.map({ s in
						AdvancedChampionInfo.Skin(num: s.num, name: s.name, imageURL: API.getChampionSpecificSkinURL(name: champion.id, num: s.num))
					})

					let advChamp = AdvancedChampionInfo(champion: champion, passive: passive, skins: skins)
					callback(advChamp)
				}
			} catch {
				print("cannot decode shit \(error)")
			}
		})

		task.resume()
	}

	static func getPatches(callback: @escaping ([String]) -> Void) {
		let url = URL(string: patchesURL)!

		let task = URLSession.shared.dataTask(with: url, completionHandler: { data, response, error in
			do {
				guard let data = data, error == nil else {
					print("cannot request shit \(error!)")
					return
				}

				let json: [String] = try JSONDecoder().decode([String].self, from: data)

				DispatchQueue.main.sync {
					callback(json)
				}
			} catch {
				print("cannot decode shit \(error)")
			}
		})

		task.resume()
	}

	static func download(url: String, callback: @escaping (Data) -> Void) {
		guard let url = URL(string: url) else {
			return
		}

		let task = URLSession.shared.dataTask(with: url, completionHandler: { data, response, error in
			guard let data = data, error == nil else {
				print("cannot request shit \(error!)")
				return
			}

			DispatchQueue.main.sync {
				callback(data)
			}
		})

		task.resume()
	}

	static func getLanguages(callback: @escaping ([String]) -> Void) {
		guard let url = URL(string: API.languagesURL) else {
			return
		}

		let task = URLSession.shared.dataTask(with: url, completionHandler: { data, response, error in
			do {
				guard let data = data, error == nil else {
					print("cannot request shit \(error!)")
					return
				}

				let languages: [String] = try JSONDecoder().decode([String].self, from: data)

				DispatchQueue.main.sync {
					callback(languages)
				}
			} catch {
				print("cannot decode shit \(error)")
			}
		})

		task.resume()
	}
}