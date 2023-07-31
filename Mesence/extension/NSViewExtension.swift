//
//  NSViewExtension.swift
//  Mesence
//
//  Created by luozhihua on 2023/7/27.
//

import Foundation
import Cocoa
extension NSView {
    func setBackgroundColor(_ color: NSColor) {
        self.wantsLayer = true
        self.layer?.backgroundColor = color.cgColor
    }
}
