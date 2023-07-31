//
//  MSLogingViewController.swift
//  Mesence
//
//  Created by luozhihua on 2023/7/31.
//

import Foundation
import SnapKit
import Cocoa

class MSLogingViewController: NSViewController {
    private lazy var userIDInputView: NSTextField = {
        let tv = NSTextField()
        tv.placeholderString = "Input your userName here"
        tv.font = NSFont.systemFont(ofSize: 16)
        tv.wantsLayer = true
        tv.layer?.cornerRadius = 10
        tv.layer?.borderColor = NSColor.gray
        tv.textColor = NSColor.lightGray
        self.view.addSubview(tv)
        return tv
    }()
    private lazy var passwordInputView: NSSecureTextField = {
        let tv = NSSecureTextField()
        tv.placeholderString = "Input your password here"
        tv.font = NSFont.systemFont(ofSize: 16)
        tv.wantsLayer = true
        tv.layer?.cornerRadius = 10
        tv.layer?.borderColor = NSColor.gray
        tv.textColor = NSColor.lightGray
        self.view.addSubview(tv)
        return tv
    }()
    
    override func loadView() {
        guard let window = NSApplication.shared.windows.first else { return }
        let windowRect = window.frame
        view = NSView(frame: windowRect)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear() {
        super.viewDidAppear()
        self.userIDInputView.snp.makeConstraints { make in
            make.width.equalTo(200)
            make.height.equalTo(50)
            make.center.equalTo(self.view).offset(-60)
        }
        self.passwordInputView.snp.makeConstraints { make in
            make.width.equalTo(200)
            make.height.equalTo(50)
            make.center.equalTo(self.view).offset(60)
        }
    }
}
