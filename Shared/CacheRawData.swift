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
    var futures: [String: Future<Data, Never>] = [:]
    var addons: [String: [AnyCancellable]] = [:]
    
    init(){
        
    }
    
    func createDependency(key: String, resolver: @escaping (@escaping (Result<Data, Never>) -> Void) -> Void) -> Future <Data, Never> {
        let future: Future <Data, Never> = Future() { promise in
            resolver(promise)
        }
        
        futures[key] = future
        addons[key] = []
        return future
    }

    func isDependency(key: String) -> Bool {
        return futures[key] == nil
    }
    
    func addToDependency(key: String, addon: @escaping (Data) -> Void) -> Void {
        addons[key]!.append(
            futures[key]!
                .sink { data in
                    addon(data)
                }
        )
    }

    func set(key: String, data: Data) {
        let future = futures[key]
        
        if(future != nil) {
            print("set clearing")
            futures[key] = nil
            addons[key] = []
        }
        
        datas[key] = data
    }
    
    func get(key: String) -> Data? {
        return datas[key]
    }
}
