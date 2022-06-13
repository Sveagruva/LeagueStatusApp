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
    
    @State private var searchInput: String = ""
    @FocusState private var focusState: Bool
    
    @State private var selectedChampion: Champion?

//    @State private var currentData: NetworkImageReferenceData?
        
    var body: some View {
            VStack{
//                    Text("PATH: \(Settings.path)")
                TextField("Name", text: $searchInput)
                    .focused($focusState)
                    .padding(14)
                ChampionsListView
                    .opacity(selectedChampion == nil ? 1 : 0)
                    .padding(.top, 10)
            }
            .padding(8)
            .overlay {
                if(selectedChampion != nil) {
                    SelectedChampionView
                }
            }
    }
    
    @ViewBuilder
    var SelectedChampionView: some View {
        ZStack {
            VStack{
                ChampionView(selectedChampion: $selectedChampion, ns: ns, champion: selectedChampion!)
            }
            .background(.background)
            
            VStack{
                HStack{
                    Spacer()
                        Button(action: {
                            withAnimation {
                                selectedChampion = nil
                            }
                        }) {
                            HStack {
                                Image(systemName: "xmark")
                                    .font(.system(size: 32))
                                    .frame(width: 45, height: 45)
                                    .foregroundColor(Color.black)
                                    .background(Color.red)
                                    .clipShape(Circle())
                            }

                        }
                        .keyboardShortcut(.escape, modifiers: [])
                        .buttonStyle(PlainButtonStyle())
                    
                    .padding(10)
                }
                Spacer()
            }
            .frame(alignment: .topTrailing)

        }
    }
    
    @ViewBuilder
    var ChampionsListView: some View {
        ScrollView {
            let gap: CGFloat = 28
            
            LazyVGrid(columns: [.init(.adaptive(minimum: 350, maximum: 600), spacing: gap)], spacing: gap){
                ForEach(state.champions.filter { champion in
                    if(searchInput.isEmpty) {
                        return true
                    }
                    
                    return champion.name.lowercased().starts(with: searchInput.lowercased())
                }, id: \.id.self) { champion in
                    
                    let dta = NetworkImageReferenceData(ns: ns, id: champion.id)
                    
                    let _ = handleImageLoad(dta: dta, url: champion.imageURL, cache: cache)
                    
                    ChampionPreview(champion: champion, imageStorate: dta, selectedChampion: $selectedChampion)
                        .onTapGesture {
                            withAnimation {
                                focusState = false
                                selectedChampion = champion
                            }
                        }
                }

            }
            .padding(10)
        }

    }
}


func handleImageLoad(dta: NetworkImageReferenceData, url: String, cache: CacheRawData) {
//    let key = champion.imageURL;
    let rawData = cache.get(key: url)
    
    if(rawData == nil) {
//        var publisher = cache.getDependency(key: key)
        
        if(!cache.isDependency(key: url)) {
            cache.createDependency(url: url)
        }

        cache.addToDependency(key: url) { data in
            dta.data = data
        }
    } else {
        dta.data = rawData!
    }

}

struct ChampionPreview: View {
    var champion: Champion
    var imageStorate: NetworkImageReferenceData
    @Binding var selectedChampion: Champion?
    let AR = 0.8


    
    var body: some View {
        ZStack {
            VStack {
                if(!(selectedChampion != nil && selectedChampion!.name == champion.name)) {
                    Color.clear
                        .background(
                            RawDataImage(data: imageStorate, origin: selectedChampion == nil)
                        )
                        .clipped()
                        .contentShape(Rectangle())
                    Text(champion.name)
                        .font(.system(size: 30, weight: .heavy, design: .default))
                        .minimumScaleFactor(0.1)
                        .matchedGeometryEffect(id:  champion.id + "title", in: imageStorate.ns, isSource: selectedChampion == nil)
                }
            }
            .aspectRatio(AR, contentMode: .fill)
        }
    }
}
