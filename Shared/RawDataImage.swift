//
//  RawDataImage.swift
//  League
//
//  Created by Sveagruva on 14.05.2022.
//

import Foundation
import SwiftUI

struct RawDataImage: View {
    @ObservedObject var data: NetworkImageReferenceData
    let origin: Bool
    
    var body: some View {
        if(data.data == nil) {
            ZStack{
                Color.clear
                    .background(.background)
                    .scaledToFit()
                VStack{
                    ProgressView()
                }
            }
        } else {
            #if os(macOS)
            Image(nsImage: NSImage(data: data.data!)!)
                .matchedGeometryEffect(id: data.id, in: data.ns)
            //
            #else
            Image(uiImage: UIImage(data: data.data!)!)
            #endif
        }

    }
}
