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
    private static let cellTitleHeight = 20.0
    private lazy var cellTitle: NSTextField = {
        let tv = NSTextField()
        tv.isEditable = false
        tv.textColor = .black
        tv.isBordered = false
        tv.backgroundColor = .white
        tv.font = NSFont.systemFont(ofSize: 11)
        self.addSubview(tv)
        return tv
    }()
    private lazy var textView: NSTextField = {
        let tv = NSTextField()
        tv.isEditable = false
        tv.textColor = .black
        tv.backgroundColor = NSColor(hexString: "#E6E6E7")
        tv.font = NSFont.systemFont(ofSize: 13)
        tv.wantsLayer = true
        tv.layer?.cornerRadius = 5.0
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
        let size = msg.sizeForText(font: NSFont.systemFont(ofSize: 13), width: maxWidth, lineSpacing: 2)
        return CGSize(width: size.width, height: size.height + MSMainMsgContentCellView.cellTitleHeight)
    }
    
    func config(msg: Msg, msgType type: MSMainMsgContentCellViewMsgType) {
        if msg.type != .word || !msg.hasData { return }
        cellTitle.snp.makeConstraints { make in
            make.height.equalTo(MSMainMsgContentCellView.cellTitleHeight)
            make.left.equalTo(self).offset(10)
            make.right.equalTo(self).offset(-10)
        }
        textView.snp.makeConstraints { make in
            make.top.equalTo(cellTitle.snp.bottom)
            make.left.equalTo(self).offset(10)
            make.bottom.equalTo(self).offset(-10)
            make.right.lessThanOrEqualTo(self).offset(-200)
        }
        textView.stringValue = msg.data.content
        cellTitle.stringValue = msg.data.from + "    " + msg.data.sendTime
        switch type {
        case .mine:
            textView.backgroundColor = NSColor(hexString: "#C7E4FD")
            
        case .other:
            textView.backgroundColor = NSColor(hexString: "#E6E6E7")
        }
    }
    
}
