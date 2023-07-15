//
//  Extension UITableview.swift
//  Event Scheduler App
//
//  Created by Rajni Bajaj on 13/07/23.
//

import Foundation
import UIKit

class SelfSizingTableView: UITableView {
    override var contentSize: CGSize {
        didSet {
            invalidateIntrinsicContentSize()
            setNeedsLayout()
        }
    }

    override var intrinsicContentSize: CGSize {
        let height = min(.infinity, contentSize.height)
        return CGSize(width: contentSize.width, height: height)
    }
}
