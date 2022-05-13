//
//  API.swift
//  League (macOS)
//
//  Created by Sveagruva on 12.05.2022.
//

import Foundation
import SwiftUI


protocol Tracable {
    var language: String { get }
    var path: String { get }
}


struct Champion: Tracable {
    let language: String
    let path: String

    let name: String
    let id: String
    let title: String
    let blurb: String
    let passive: Passive?
    
    
    struct Passive: Tracable {
        let language: String
        let path: String
        
        let name: String
        let description: String
        let image: String
        
        lazy var imageURL: String = {
            "\(API.base)/\(path)/img/passive/\(image)"
        }()
    }

    
    //https://ddragon.leagueoflegends.com/cdn/5.9.1/img/passive/Ezreal_RisingSpellForce.png
    var imageURL: String {
        get{
            let img = id == "Fiddlesticks" ? "FiddleSticks" : id
            return "\(API.base)/img/champion/centered/\(img)_0.jpg"
        }
    }
//    let imageURL: String
//    static func createImageURL(name: String) {
//        "\(API.base)/\(path)/img/passive/\(name)"
//    }
}

class API {
    static let base = "https://ddragon.leagueoflegends.com/cdn"
    static let languagesURL = "\(API.base)/languages.json"
    static private func getChampionURL(langauge: String, path: String) -> String {
        return "\(API.base)/\(path)/data/\(langauge)/champion.json";
    }
    
    static private func getChampionSkinURL(langauge: String, path: String, name: String) -> String {
        return "\(API.base)/\(path)/data/\(langauge)/champion/\(name).json";
    }
    
    static private func getChampionSpecificSkinURL(name: String, num: Int) -> String {
        return "\(API.base)/img/champion/splash/\(name)_\(num).jpg";
    }
    
    
    
    
    static func getChampions(callback: @escaping ([Champion]) -> Void) {
        guard let url = URL(string: API.getChampionURL(langauge: "en_US", path: "12.3.1")) else {
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
                        language: "en_US", path: "12.3.1", name: value.name, id: value.id, title: value.title, blurb: value.blurb, passive: nil
                    ))
//                    break
                }
                            
                DispatchQueue.main.sync {
                    callback(realShit)
                }
            } catch {
                print("cannot decode shit \(error)")
            }
        } )

        task.resume()
    }
    
    static func getChampionsSkins(champion: Champion, callback: @escaping ([String]) -> Void) {
        guard let url = URL(string: API.getChampionSkinURL(langauge: champion.language, path: champion.path, name: champion.id)) else {
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
               let skins: [skin]
               
               struct skin: Codable {
                   let num: Int
                   let name: String
                   let chromas: Bool
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
                    callback((json.data[champion.id]!.skins.map({ sk in
                        API.getChampionSpecificSkinURL(name: champion.id, num: sk.num)
                    })))
                }
            } catch {
                print("cannot decode shit \(error)")
            }
        } )

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
        } )

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
                
                print(languages)
                DispatchQueue.main.sync {
                    callback(languages)
                }
            } catch {
                print("cannot decode shit \(error)")
            }
        } )

        task.resume()
    }
}
