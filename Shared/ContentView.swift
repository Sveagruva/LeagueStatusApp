//
//  ContentView.swift
//  Shared
//
//  Created by Sveagruva on 12.05.2022.
//

import SwiftUI


struct ContentView: View {
    @EnvironmentObject var state: AppState
    @Namespace var ns
    
    @State private var selectedItem: String?
    
    var body: some View {
        let views = ForEach(state.champions, id: \.id.self) { champion in
            NavigationLink(
                destination:
                    Text(champion.name)
//                    .fontWeight(.bold)
                        .matchedGeometryEffect(id: champion.id, in: ns)
                        ,
                tag: champion.id,
                selection: $selectedItem
             ) {
                Spacer()
             }
        }
        
        NavigationView {
            #if os(macOS)
                VStack{
                    views
                }
                .dissableSideBar()
            #endif
            

            VStack{
    //            Text("PATH: \(Settings.path)")
                ScrollView {
                    let gap: CGFloat = 28
                    #if os(iOS)
                    views
                    #endif
                    LazyVGrid(columns: [.init(.adaptive(minimum: 350, maximum: 600), spacing: gap)], spacing: gap){
                        ForEach(state.champions, id: \.id.self) { champion in
                            ChampionPreview(champion: champion, ns: ns)
                                .onTapGesture {
                                    withAnimation {
                                        selectedItem = champion.id
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
            
        }
    }
}





struct ChampionPreview: View {
    var champion: Champion
    let ns: Namespace
    let AR = 0.8
    
    var body: some View {
        VStack {
            Color.clear
                .background(
                    AsyncImage(url: URL(string: champion.imageURL)) { image in
                        image
                    } placeholder: {
                        VStack{
                            ProgressView()
                        }
                    }
                )
                .clipped()
                .contentShape(Rectangle())
            Text(champion.name)
//                .fontWeight(.bold)
                .matchedGeometryEffect(id: champion.id, in: ns)
                
        }
        .aspectRatio(AR, contentMode: .fill)
    }
    
//    struct ChampionImage: View {
//        let AR = 0.7
//
//        class DATA: ObservableObject {
//            @Published var d: Data? = nil
//            let u: URL
//
//            init(u: URL, shit: @escaping (DATA) -> Void) {
//                self.u = u
//                shit(self)
//            }
//        }
//
//        @ObservedObject var dta: DATA
//
//        init(url: String) {
//            dta = DATA(u: URL(string: url)!) { bi in
//                let task = URLSession.shared.dataTask(with: bi.u, completionHandler: { data, response, error in
//                    guard let data = data, error == nil else {
//                        print("cannot request shit \(error!)")
//                        return
//                    }
//
//                    DispatchQueue.main.async {
//                        bi.d = data
//                    }
//                } )
//
//                task.resume()
//            }
//        }
//
//        var body: some View {
//            VStack{
//                if(dta.d == nil) {
//                    ZStack{
//                        Color.gray
//                          .scaledToFit()
//                        ActivityIndicator()
//                    }
//                } else {
//                    Color.clear
//                      .scaledToFit()
//                      .background(
//                            Image(nsImage: NSImage(data: dta.d!)!)
//                                .resizable()
//                                .aspectRatio(contentMode: .fill)
////                            ,alignment: .topLeading
//                      )
//                      .clipped()
//                }
//            }
//            .aspectRatio(AR, contentMode: .fill)
//        }
//    }

}
