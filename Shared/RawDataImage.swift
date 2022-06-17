//
//  RawDataImage.swift
//  League
//
//  Created by Sveagruva on 14.05.2022.
//

import Foundation
import SwiftUI

struct RawDataImage: View {
	@ObservedObject var data: NetworkImageData
	let origin: Bool?

	var body: some View {
		if (data.data == nil) {
			ZStack {
				Color.clear
					.background(.background)
					.scaledToFit()
				VStack {
					ProgressView()
				}
			}
		} else {
#if os(macOS)
			if (origin == nil) {
				let im = NSImage(data: data.data!)

				if (im == nil) {
					ZStack {
						Color.clear
							.background(.background)
							.scaledToFit()
						VStack {
							ProgressView()
						}
					}
				} else {
					Image(nsImage: im!)
						.resizable()
						.scaledToFit()
				}
			} else {
				Image(nsImage: NSImage(data: data.data!)!)
					//                    .zIndex(10)
					.matchedGeometryEffect(id: data.id, in: data.ns, isSource: origin!)
//                    .matchedGeometryEffect(id: data.id, in: data.ns)


			}
			//
#else
			if (origin == nil) {
				let im = UIImage(data: data.data!)

				if (im == nil) {
					ZStack {
						Color.clear
							.background(.background)
							.scaledToFit()
						VStack {
							ProgressView()
						}
					}
				} else {
					Image(uiImage: im!)
						.resizable()
						.scaledToFit()
				}
			} else {
				Image(uiImage: UIImage(data: data.data!)!)
					//                    .zIndex(10)
					.matchedGeometryEffect(id: data.id, in: data.ns, isSource: origin!)
//                    .matchedGeometryEffect(id: data.id, in: data.ns)


			}


#endif
		}

	}
}
