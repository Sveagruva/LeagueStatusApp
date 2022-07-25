//
// Created by Sveagruva on 17.06.2022.
//

import Foundation

//
//  ContentView.swift
//  Shared
//
//  Created by Sveagruva on 12.05.2022.
//

import Foundation
import SwiftUI


struct ChampionsListView: View {
	class ChampionListModel: ObservableObject {
		@Published var champs: [Champion]? = nil
		@Published var selectedChampion: Champion?

		init(path: String) {
			DataProvider.getChampions(path: path) { champions in
				DispatchQueue.main.async { [self] in
					champs = champions
				}
			}
		}
	}

	@ObservedObject var model: ChampionListModel

	@EnvironmentObject var state: AppState
	@EnvironmentObject var cache: CacheRawData


	@Namespace var ns

	@State private var searchInput: String = ""
	@FocusState private var focusState: Bool

	init(path: String) {
		model = ChampionListModel(path: path)
	}

	var body: some View {
		VStack {
			HStack {
				TextField("Name", text: $searchInput)
				  .focused($focusState)

				Spacer()
				  .frame(width: 20)

				Text("PATH: \(state.$chosenPath.wrappedValue)")
			}
			  .padding(14)

			if(model.champs != nil) {
				ChampionsListView
				  .padding(.top, 10)
			}

		}
		  .padding(8)
		  .overlay {
			  if (model.selectedChampion != nil) {
				  SelectedChampionView
			  }
		  }
	}

	@ViewBuilder
	var SelectedChampionView: some View {
		ZStack {
			VStack {
				ChampionView(selectedChampion: $model.selectedChampion, cache: cache, ns: ns, champion: model.selectedChampion!)
			}
			  .background(.background)

			VStack {
				HStack {
					Spacer()
					Button(action: {
						withAnimation {
							model.selectedChampion = nil
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

			LazyVGrid(columns: [.init(.adaptive(minimum: 350, maximum: 600), spacing: gap)], spacing: gap) {
				ForEach(model.champs!.filter { champion in
					if (searchInput.isEmpty) {
						return true
					}

					return champion.name.lowercased().starts(with: searchInput.lowercased())
				}, id: \.id.self) { champion in
					ChampionPreview(ns: ns, cache: cache, champion: champion, selectedChampion: $model.selectedChampion)
					  .onTapGesture {
						  focusState = false

						  withAnimation {
							  model.selectedChampion = champion
						  }
					  }
				}

			}
			  .padding(10)
		}

	}
}

struct ChampionPreview: View {
	var champion: Champion
	@Binding var selectedChampion: Champion?

	let imageStorage: PublishedImageData
	let AR = 0.8
	var cache: CacheRawData


	init(ns: Namespace.ID, cache: CacheRawData, champion: Champion, selectedChampion: Binding<Champion?>) {
		self.champion = champion
		self._selectedChampion = selectedChampion
		self.cache = cache

		imageStorage = PublishedImageData(ns: ns, id: champion.id)
		let dta = imageStorage
		cache.downloadOrUseCache(url: champion.imageURL) { data in
			dta.data = data
		}
	}


	var body: some View {
		ZStack {
			VStack {
				if (!(selectedChampion != nil && selectedChampion!.name == champion.name)) {
					Color.clear
					  .background(
						  RawDataImage(data: imageStorage, origin: selectedChampion == nil)
					  )
					  .clipped()
					  .contentShape(Rectangle())
				} else {
					Color.clear
					  .clipped()
					  .contentShape(Rectangle())

				}

				if (!(selectedChampion != nil && selectedChampion!.name == champion.name)) {
					Text(champion.name)
					  .font(.system(size: 30, weight: .heavy, design: .default))
					  .minimumScaleFactor(0.1)
					  .matchedGeometryEffect(id: champion.id + "title", in: imageStorage.ns)
				} else {
					Text(champion.name)
					  .font(.system(size: 30, weight: .heavy, design: .default))
					  .minimumScaleFactor(0.1)
					  .opacity(0)
				}
			}
			  .aspectRatio(AR, contentMode: .fill)

		}
	}
}
