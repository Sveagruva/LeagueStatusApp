//
//  NetworkImageReference.swift
//  League
//
//  Created by Sveagruva on 14.05.2022.
//

import Foundation
import SwiftUI

class NetworkImageData: ObservableObject {
	@Published var data: Data? = nil
	var ns: Namespace.ID
	var id: String
	@Published var indication: Bool = true

	init(ns: Namespace.ID, id: String) {
		self.ns = ns
		self.id = id
	}
}
