//
//  ImageViewer.swift
//  League (macOS)
//
//  Created by Sveagruva on 16.06.2022.
//

import SwiftUI

struct ImageViewer: View {
	let dta: NetworkImageData
	let title: String

	var body: some View {
		RawDataImage(data: dta, origin: nil)
			.frame(minWidth: 400, idealWidth: 500, maxWidth: .infinity, minHeight: 400, idealHeight: 500, maxHeight: .infinity)
	}

	func openAsWindow() {
		let controller = NSHostingController(rootView: self)
		let win = NSWindow(contentViewController: controller)
		win.title = title
		win.makeKeyAndOrderFront(self)
	}
}
