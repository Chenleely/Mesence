//
//  MSMainMsgContentCellView.swift
//  Mesence
//
//  Created by luozhihua on 2023/7/31.
//

import Foundation
import Cocoa

enum MSMainMsgContentCellViewMsgType {
    case mine
    case other
}

class MSMainMsgContentCellView: NSTableCellView {
    private lazy var textView: NSTextField = {
        let tv = NSTextField()
        tv.isEditable = false
        tv.textColor = .black
        tv.wantsLayer = true
        tv.layer?.cornerRadius = 5.0
        tv.backgroundColor = NSColor(hexString: "#E6E6E7")
        tv.font = NSFont.systemFont(ofSize: 13)
        self.addSubview(tv)
        return tv
    }()
    
    required init?(coder: NSCoder) {
        fatalError("can't do this")
    }
    
    override init(frame frameRect: NSRect) {
        super.init(frame: frameRect)
    }
    
    class func calcuteCellSize(_ msg: String, withMaxWidth maxWidth: CGFloat) -> CGSize {
        return msg.sizeForText(font: NSFont.systemFont(ofSize: 13), width: maxWidth, lineSpacing: 2)
    }
    
    func config(_ text: String, msgType type: MSMainMsgContentCellViewMsgType) {
        textView.snp.makeConstraints { make in
            make.top.left.equalTo(self).offset(10)
            make.bottom.equalTo(self).offset(-10)
            make.right.lessThanOrEqualTo(self).offset(-200)
        }
        textView.stringValue = text
        switch type {
        case .mine:
            textView.backgroundColor = NSColor(hexString: "#C7E4FD")
        case .other:
            textView.backgroundColor = NSColor(hexString: "#E6E6E7")
        }
    }
    
}
