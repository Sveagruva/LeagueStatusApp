//
// Created by Sveagruva on 19.06.2022.
//

import Foundation

protocol Tracable {
	var language: String { get }
	var path: String { get }
}

struct Champion: Tracable, Encodable, Decodable {
	let language: String
	let path: String

	let name: String
	let id: String
	let title: String
	let blurb: String
	let stats: [String: Float]

	//https://ddragon.leagueoflegends.com/cdn/5.9.1/img/passive/Ezreal_RisingSpellForce.png
	var imageURL: String {
		get {
			let img = id == "Fiddlesticks" ? "FiddleSticks" : id
			return "\(API.base)/img/champion/centered/\(img)_0.jpg"
		}
	}
//    let imageURL: String
//    static func createImageURL(name: String) {
//        "\(API.base)/\(path)/img/passive/\(name)"
//    }
}

struct AdvancedChampionInfo {
	let champion: Champion
	var passive: Passive
	var skins: [Skin]

	struct Skin {
		let num: Int
		let name: String
		let imageURL: String

//        lazy var imageURL: String = {
//            "\(API.base)/\(path)/img/passive/\(image)"
//        }()
	}

	struct Passive: Tracable {
		let language: String
		let path: String

		let name: String
		let description: String
		let image: String

		var imageURL: String {
			get {
				"\(API.base)/\(path)/img/passive/\(image)"
			}
		}
//        lazy var imageURL: String = {
//            "\(API.base)/\(path)/img/passive/\(image)"
//        }()
	}
}
