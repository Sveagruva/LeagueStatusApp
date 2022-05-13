//
//  disableSideBar.swift
//  League (macOS)
//
//  Created by Sveagruva on 12.05.2022.
//

//import Foundation
#if os(macOS)
import Introspect
import AppKit
import SwiftUI

extension View {
    public func dissableSideBar() -> some View {
        return inject(AppKitIntrospectionView(
            selector: { introspectionView in
                guard let viewHost = Introspect.findViewHost(from: introspectionView) else {
                    return nil
                }
                return Introspect.findAncestorOrAncestorChild(ofType: NSSplitView.self, from: viewHost)
            },
            customize: { controller in
                (controller.delegate as? NSSplitViewController)?.splitViewItems.first?.isCollapsed = true
                (controller.delegate as? NSSplitViewController)?.splitViewItems.first?.canCollapse = false
            } as (NSSplitView) -> ()
        ))
    }
}


#elseif os(iOS)
//import UIKit
#endif

