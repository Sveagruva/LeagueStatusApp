//
//  ContentView.swift
//  Shared
//
//  Created by Sveagruva on 12.05.2022.
//

import SwiftUI


struct ContentView: View {
    @EnvironmentObject var state: AppState
    @EnvironmentObject var cache: CacheRawData

    @Namespace var ns
    
    @State private var selectedChampion: Champion?
//    @State private var currentData: NetworkImageReferenceData?
        
    var body: some View {
        ZStack {
            VStack{
        //            Text("PATH: \(Settings.path)")
                ScrollView {
                    let gap: CGFloat = 28
                    
                    LazyVGrid(columns: [.init(.adaptive(minimum: 350, maximum: 600), spacing: gap)], spacing: gap){
                        ForEach(state.champions, id: \.id.self) { champion in
                            let dta = NetworkImageReferenceData(ns: ns, id: champion.id)
                            
                            let _ = handleImageLoad(dta: dta, champion: champion, cache: cache)
                            
                            ChampionPreview(champion: champion, imageStorate: dta)
                                .onTapGesture {
                                    withAnimation {
//                                        dta.indication.toggle()
//                                        currentData = dta
                                        selectedChampion = champion
                                    }
                                }
                        }

                    }
                    .padding(10)
                }
                .padding(.top, 10)
            }
            .padding(8)
            .frame(minWidth: 200, idealWidth: 500, maxWidth: .infinity, minHeight: 300, idealHeight: 500, maxHeight: .infinity)
            
            if(selectedChampion != nil) {
                VStack{
                    ChampionView(champion: $selectedChampion, ns: ns)
                }
                .background(.background)
            } else {
                Color.clear
            }


        }
//        .overlay {
//
//        }
    }
    
}


func handleImageLoad(dta: NetworkImageReferenceData, champion: Champion, cache: CacheRawData) {
    let key = champion.id;
    let rawData = cache.get(key: key)
    
    if(rawData == nil) {
//        var publisher = cache.getDependency(key: key)
        
        if(cache.isDependency(key: key)) {
            cache.createDependency(key: key) { promise in
                
//                URLSession.shared.dataTaskPublisher(for: URL(string: champion.imageURL)!)
//                    .map({ $0.data })
//                    .catch({ _ in
//
//                    })
//                    .sink { raw in
//
//
//                    }
                
                DispatchQueue.main.async {
                    API.download(url: champion.imageURL) { raw in
                        promise(Result.success(raw))
                        cache.set(key: key, data: raw)
                    }
                }

            }
            
//            publisher = cache.getDependency(key: key)
        }
        
        cache.addToDependency(key: key) { data in
            dta.data = data
        }
        
//        publisher!
//            .print()
//            .sink { data in
//                DispatchQueue.main.sync {
//                    print("sinked")
//                    dta.data = data
//                }
//            }

        
//        if(isCreating) {
//        }
        
    } else {
        dta.data = rawData!
    }

}

struct ChampionPreview: View {
    var champion: Champion
    var imageStorate: NetworkImageReferenceData
    let AR = 0.8

    
    var body: some View {
        ZStack {
            VStack {
                Color.clear
                    .background(
                        RawDataImage(data: imageStorate, origin: false)
                    )
                    .clipped()
                    .contentShape(Rectangle())
                Text(champion.name)
                    .fontWeight(.bold)
//                    .matchedGeometryEffect(id: champion.id, in: ns)
                    
            }
            .aspectRatio(AR, contentMode: .fill)
        }
    }
}
