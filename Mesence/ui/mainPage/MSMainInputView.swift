//
//  File.swift
//  Mesence
//
//  Created by luozhihua on 2023/7/27.
//

import Foundation
import Cocoa
import SnapKit

class MSMainInputView: NSView  {
    private var scrollView: NSScrollView = {
        return NSTextView.scrollableTextView()
    }()
    private var textView: NSTextView?
    
    // MARK: - Public Methods
    required init?(coder: NSCoder) {
        fatalError("Can't do this")
    }
    
    override init(frame frameRect: NSRect) {
        super.init(frame: frameRect)
        self.initUI()
        self.installLayout()
    }
    
    // MARK: - Private Methods
    private func initUI() {
        textView = scrollView.documentView as? NSTextView
        textView?.backgroundColor = .white
        textView?.textColor = .black
        textView?.font = NSFont.systemFont(ofSize: 14)
        textView?.insertionPointColor = .lightGray
        self.addSubview(scrollView)
    }
    
    private func installLayout() {
        scrollView.snp.makeConstraints { make in
            make.edges.equalTo(self)
        }
    }
}

extension MSMainInputView: NSTextViewDelegate {
    
}
