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
    private lazy var userIDContainerView: NSView = {
        let view = NSView()
        view.wantsLayer = true
        view.layer?.cornerRadius = 10
        view.layer?.borderWidth = 1
        view.layer?.borderColor = NSColor.gray.cgColor
        self.view.addSubview(view)
        return view
    }()
    private lazy var userIDTitle: NSTextField = {
        let tv = NSTextField()
        tv.isEditable = false
        tv.stringValue = "User Name"
        tv.font = NSFont.systemFont(ofSize: 15)
        tv.textColor = NSColor.lightGray
        self.userIDContainerView.addSubview(tv)
        return tv
    }()
    private lazy var userIDInputView: NSTextField = {
        let tv = NSTextField()
        tv.font = NSFont.systemFont(ofSize: 15)
        tv.textColor = NSColor.black
        tv.focusRingType = .none
        tv.backgroundColor = .lightGray
        tv.maximumNumberOfLines = 20
        self.userIDContainerView.addSubview(tv)
        return tv
    }()
    
    private lazy var passwordContainerView: NSView = {
        let view = NSView()
        view.wantsLayer = true
        view.layer?.cornerRadius = 10
        view.layer?.borderWidth = 1
        view.layer?.borderColor = NSColor.gray.cgColor
        self.view.addSubview(view)
        return view
    }()
    private lazy var passwordTitle: NSTextField = {
        let tv = NSTextField()
        tv.isEditable = false
        tv.stringValue = "Password"
        tv.font = NSFont.systemFont(ofSize: 15)
        tv.textColor = NSColor.lightGray
        self.passwordContainerView.addSubview(tv)
        return tv
    }()
    private lazy var passwordInputView: NSSecureTextField = {
        let tv = NSSecureTextField()
        tv.font = NSFont.systemFont(ofSize: 15)
        tv.focusRingType = .exterior
        tv.textColor = NSColor.black
        tv.backgroundColor = .lightGray
        tv.focusRingType = .none
        tv.maximumNumberOfLines = 20
        self.passwordContainerView.addSubview(tv)
        return tv
    }()
    private lazy var loginButton: NSButton = {
        let button = NSButton(title: "Login", target: self, action: #selector(clickLogin))
        button.setBackgroundColor(NSColor.green)
        button.titleTextColor = .black
        button.wantsLayer = true
        button.layer?.cornerRadius = 10
        button.isBordered = false
        self.view.addSubview(button)
        return button
    }()
    
    @objc func clickLogin() {
        MSLoginManager.shared.login(userID: "", password: "") { success in
            if success {
                MSViewControllerManager.sharedManager.pop()
                MSViewControllerManager.sharedManager.push(MSMainViewController())
            }
        }
    }
    
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
        self.installLayout()
    }
    
    private func installLayout() {
        self.userIDContainerView.snp.makeConstraints { make in
            make.width.equalTo(300)
            make.height.equalTo(100)
            make.centerX.equalTo(self.view)
            make.centerY.equalTo(self.view).offset(-60)
        }
        self.userIDTitle.snp.makeConstraints { make in
            make.height.equalTo(30)
            make.width.equalTo(280)
            make.left.top.equalTo(self.userIDContainerView).offset(10)
        }
        self.userIDInputView.snp.makeConstraints { make in
            make.height.equalTo(30)
            make.width.equalTo(280)
            make.left.equalTo(self.userIDTitle)
            make.top.equalTo(self.userIDTitle.snp.bottom)
        }
        
        self.passwordContainerView.snp.makeConstraints { make in
            make.width.equalTo(300)
            make.height.equalTo(100)
            make.centerX.equalTo(self.view)
            make.centerY.equalTo(self.view).offset(60)
        }
        self.passwordTitle.snp.makeConstraints { make in
            make.height.equalTo(30)
            make.width.equalTo(280)
            make.left.top.equalTo(self.passwordContainerView).offset(10)
        }
        self.passwordInputView.snp.makeConstraints { make in
            make.height.equalTo(30)
            make.width.equalTo(280)
            make.left.equalTo(self.passwordTitle)
            make.top.equalTo(self.passwordTitle.snp.bottom)
        }
        
        self.loginButton.snp.makeConstraints { make in
            make.width.equalTo(300)
            make.height.equalTo(40)
            make.centerX.equalTo(self.view)
            make.top.equalTo(self.passwordContainerView.snp.bottom).offset(30)
        }
    }
}
