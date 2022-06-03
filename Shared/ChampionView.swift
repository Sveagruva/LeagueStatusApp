//
//  ChampionView.swift
//  League
//
//  Created by Sveagruva on 14.05.2022.
//

import Foundation
import SwiftUI

struct ChampionView: View {
    @EnvironmentObject var cache: CacheRawData

    
    @Binding var champion: Champion?
    let ns: Namespace.ID
//    @Binding var imageData: NetworkImageReferenceData?

    @ObservedObject var d: D

    class D: ObservableObject {
        @Published var fullDataChamp: Champion? = nil
        
        init(champion: Champion) {
            API.getChampionFullInfo(champion: champion) { ch in
                self.fullDataChamp = ch
            }
        }
    }
    
    init(champion: Binding<Champion?>, ns: Namespace.ID) {
        //imageData: Binding<NetworkImageReferenceData?>
        self._champion = champion
        self.ns = ns
//        self._imageData = imageData
        self.d = D(champion: champion.wrappedValue!)
    }

    
    let AR = 0.8
    
    var body: some View {
        VStack {

            if(champion != nil) {
                GeometryReader { geo in
                    ScrollView {
                        HStack {
                            Spacer()
                            VStack{
                                let dta = NetworkImageReferenceData(ns: ns, id: champion!.id)
                                
                                let _ = handleImageLoad(dta: dta, champion: champion!, cache: cache)

                                RawDataImage(data: dta, origin: true)
//                                    .frame(height: geo.size.height / 3 < 400 ? 400 : geo.size.height / 3)
//                                    .clipped()
//                                    .contentShape(Rectangle())
                                Text(champion!.name)
                                    .font(.system(size: 70, weight: .heavy, design: .default))
                                    .frame(maxWidth: .infinity, alignment: .topLeading)
                                Text(champion!.title)
                                    .font(.system(size: 36, weight: .bold, design: .default))
                                    .frame(maxWidth: .infinity, alignment: .topLeading)

                                if(d.fullDataChamp != nil) {
                                    VStack {
                                        Spacer().frame(height: 30)
//                                        Text("Passive")
//                                            .font(.system(size: 18, weight: .semibold, design: .default))
//                                            .frame(maxWidth: .infinity, alignment: .topLeading)
                                        HStack {
                                            AsyncImage(url: URL(string: d.fullDataChamp!.passive!.imageURL))
                                            Spacer()
                                                .frame(width: 20)
                                            VStack {
                                                Text(d.fullDataChamp!.passive!.name)
                                                    .font(.system(size: 36, weight: .heavy, design: .default))
                                                    .frame(maxWidth: .infinity, alignment: .topLeading)
                                                Text(d.fullDataChamp!.passive!.description)
                                                    .font(.system(size: 14, weight: .medium, design: .default))
                                                    .frame(maxWidth: .infinity, alignment: .topLeading)
                                            }
                                        }
//                                        .frame(alignment: .leading)

                                    }
                                }
                                VStack {
                                    ForEach(Array(champion!.stats.keys), id: \.self) { key in
                                        HStack {
                                            Text(key)
                                                .font(.system(size: 15, weight: .heavy, design: .default))
                                                .frame(maxWidth: .infinity, alignment: .topLeading)
                                            Text(String(describing: champion!.stats[key]!))
                                                .font(.system(size: 14, weight: .medium, design: .default))
                                                .frame(maxWidth: .infinity, alignment: .topLeading)
                                        }
                                    }
                                }
                //                        .matchedGeometryEffect(id: champion!.id, in: ns)

                            }
                            .frame(maxWidth: 900)
                            Spacer()
                        }
                        
                        if(d.fullDataChamp != nil) {
                            HStack {
                                ScrollView(.horizontal) {
                                    HStack {
                                        ForEach(d.fullDataChamp!.skins!, id: \.self) { skin in
                                            AsyncImage(url: URL(string: skin))
                                        }
                                    }
                                }
                            }
                        }

                    }
                }
            }

        }
        .onTapGesture {
            withAnimation {
//                imageData!.indication.toggle()
                champion = nil
//                imageData = nil
            }
        }
    }
}

