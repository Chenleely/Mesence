//
//  StringExtension.swift
//  Mesence
//
//  Created by luozhihua on 2023/7/31.
//

import Foundation
import Cocoa

extension String {
    func sizeForText(font: NSFont, width: CGFloat, lineSpacing: CGFloat) -> CGSize {
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = lineSpacing
        let attributes: [NSAttributedString.Key: Any] = [
            .font: font,
            .paragraphStyle: paragraphStyle
        ]
        let attributedString = NSAttributedString(string: self, attributes: attributes)
        var rect = attributedString.boundingRect(with: CGSize(width: width, height: .greatestFiniteMagnitude),
                                                 options: [.usesLineFragmentOrigin],
                                                 context: nil)
        let fontHeight = font.ascender - font.descender + font.leading
        if rect.size.height - fontHeight <= paragraphStyle.lineSpacing {
            rect = CGRect(x: rect.origin.x, y: rect.origin.y, width: rect.width, height: rect.size.height - paragraphStyle.lineSpacing)
        }
        return CGSize(width: rect.width, height: rect.height + 30)
    }
    
  
    func judgeStringIncludeChineseWord() -> Bool {
        for (_, value) in self.enumerated() {
            if ("\u{4E00}" <= value  && value <= "\u{9FA5}") {
                return true
            }
        }
        return false
    }
    
    func maxCountEachline(font: NSFont, maxWidth: CGFloat) -> Int {
        let fontAttributes = [NSAttributedString.Key.font: font]
        let singleString = NSAttributedString(string: "W", attributes: fontAttributes)
        let singleStringRect = singleString.boundingRect(with: CGSize(width: maxWidth, height: .greatestFiniteMagnitude), options: [.usesLineFragmentOrigin], context: nil)
        return Int(floor(maxWidth / singleStringRect.width))
    }
}
 
