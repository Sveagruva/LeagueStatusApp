//
//  ChampionView.swift
//  League
//
//  Created by Sveagruva on 14.05.2022.
//

import Foundation
import SwiftUI

struct ChampionView: View {
	var cache: CacheRawData

	@Binding var selectedChampion: Champion?
	let ns: Namespace.ID
	let champion: Champion
	@ObservedObject var d: D
	let dta: NetworkImageData

	class D: ObservableObject {
		@Published var fullDataChamp: AdvancedChampionInfo? = nil

		init(champion: Champion, dta: NetworkImageData) {
			API.getChampionFullInfo(champion: champion) { ch in
				self.fullDataChamp = ch
			}
		}
	}

	init(selectedChampion: Binding<Champion?>, cache: CacheRawData, ns: Namespace.ID, champion: Champion) {
		self._selectedChampion = selectedChampion
		self.champion = champion
		self.ns = ns

		dta = NetworkImageData(ns: ns, id: champion.id)
		self.cache = cache
		let dta2 = dta
		cache.downloadOrUseCache(url: champion.imageURL) { data in
			dta2.data = data
		}

		d = D(champion: champion, dta: dta)
	}


	let AR = 0.8

	var body: some View {
		VStack {
			GeometryReader { geo in
				ScrollView {
					VStack {
						HStack {
							Spacer()
							VStack {
								if (selectedChampion != nil) {
									Color.clear
									  .background(
										  RawDataImage(data: dta, origin: selectedChampion != nil)
									  )
									  .frame(height: geo.size.height / 3 < 400 ? 400 : geo.size.height / 3)
									  .clipped()
									  .contentShape(Rectangle())

								} else {
									Color.clear
									  .frame(height: geo.size.height / 3 < 400 ? 400 : geo.size.height / 3)
									  .clipped()
									  .contentShape(Rectangle())
								}

								if (selectedChampion != nil) {
									Text(champion.name)
									  .font(.system(size: 70, weight: .heavy, design: .default))
									  .minimumScaleFactor(0.1)
									  .matchedGeometryEffect(id: champion.id + "title", in: ns)
									  .frame(maxWidth: .infinity, alignment: .topLeading)
								} else {
									Text(champion.name)
									  .font(.system(size: 30, weight: .heavy, design: .default))
									  .minimumScaleFactor(0.1)
									  .opacity(0)
								}




								Text(champion.title)
								  .font(.system(size: 36, weight: .bold, design: .default))
								  .frame(maxWidth: .infinity, alignment: .topLeading)
								Spacer()
								  .frame(height: 20)

								Text(champion.blurb)
									//                                    .font(.system(size: 36, weight: .bold, design: .default))
								  .frame(maxWidth: .infinity, alignment: .topLeading)

								if (d.fullDataChamp != nil) {
									VStack {
										Spacer().frame(height: 30)
//                                        Text("Passive")
//                                            .font(.system(size: 18, weight: .semibold, design: .default))
//                                            .frame(maxWidth: .infinity, alignment: .topLeading)
										HStack {
											AsyncImage(url: URL(string: d.fullDataChamp!.passive.imageURL))
											  .frame(width: 80)
											Spacer()
											  .frame(width: 20)
											VStack {
												Text(d.fullDataChamp!.passive.name)
												  .font(.system(size: 36, weight: .heavy, design: .default))
												  .frame(maxWidth: .infinity, alignment: .topLeading)
												Text(d.fullDataChamp!.passive.description)
												  .font(.system(size: 14, weight: .medium, design: .default))
												  .frame(maxWidth: .infinity, alignment: .topLeading)
											}
										}
									}
								}

								VStack {
									LazyVGrid(
										columns: [GridItem(.flexible()), GridItem(.flexible())],
										alignment: .center,
										spacing: 7
									) {
										ForEach(Array(champion.stats.keys), id: \.self) { key in
											HStack {
												Spacer()
												Text(key)
												  .font(.system(size: 17, weight: .heavy, design: .default))
												  .frame(width: 200, alignment: .leading)
												Spacer()
											}
											Text(String(describing: champion.stats[key]!))
											  .font(.system(size: 15, weight: .medium, design: .default))

										}
									}
								}
							}
							  .frame(maxWidth: 900)
							Spacer()
						}

						if (d.fullDataChamp != nil) {
							HStack {
								Spacer()
								VStack {
									Text("Skins")
									  .font(.system(size: 34, weight: .heavy, design: .default))
									  .frame(maxWidth: .infinity, alignment: .topLeading)
								}
								  .frame(maxWidth: 900)
								Spacer()
							}
							HStack {
								ScrollView(.horizontal) {
									HStack {
										ForEach(d.fullDataChamp!.skins, id: \.name.self) { skin in
											let dta = NetworkImageData(ns: ns, id: champion.id)

											let _ = cache.downloadOrUseCache(url: skin.imageURL) { data in
												dta.data = data
											}

											let height = geo.size.height / 2 < 400 ? 400 : geo.size.height / 2

											VStack {
												RawDataImage(data: dta, origin: nil)
												  .frame(width: height * 1.69, height: height)
												  #if os(macOS)
												  .onTapGesture {
													  let imageViewer = ImageViewer(dta: dta, title: skin.name == "default" ? champion.name : skin.name)
													  imageViewer.openAsWindow()
												  }
												  #endif

												Text(skin.name)
												  .font(.system(size: 19, weight: .medium, design: .default))
												  .frame(maxWidth: .infinity, alignment: .center)

											}

//                                                .clipped()
//                                                .contentShape(Rectangle())
										}
									}
									  .padding(Edge.Set.bottom, 17)
								}
							}
							  .padding(7)
						}

					}
				}
			}
		}
		  .padding(14)
	}
}

