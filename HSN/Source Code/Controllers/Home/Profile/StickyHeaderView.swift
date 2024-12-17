//
//  StickyHeaderView.swift
//  HSN
//
//  Created by Prashant Panchal on 21/09/21.
//  Copyright © 2021 Kartikeya. All rights reserved.
//

import Foundation
import UIKit
internal class StickyHeaderView: UIView {
    weak var parent: StickyHeader?
    
    internal static var KVOContext = 0
    
    override func willMove(toSuperview view: UIView?) {
        if let view = self.superview, view.isKind(of:UIScrollView.self), let parent = self.parent {
            view.removeObserver(parent, forKeyPath: "contentOffset", context: &StickyHeaderView.KVOContext)
        }
    }
    
    override func didMoveToSuperview() {
        if let view = self.superview, view.isKind(of:UIScrollView.self), let parent = parent {
            view.addObserver(parent, forKeyPath: "contentOffset", options: .new, context: &StickyHeaderView.KVOContext)
        }
    }
}
