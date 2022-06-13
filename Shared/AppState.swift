//
//  State.swift
//  League
//
//  Created by Sveagruva on 12.05.2022.
//

import Foundation

class AppState: ObservableObject {
    @Published var languages: [String] = []
    @Published var champions: [Champion] = []
    
    init() {
        print("app state")
        API.getLanguages { languages in
            self.languages = languages
        }
        
        API.getChampions { champions in
            self.champions = champions
        }
    }
}
