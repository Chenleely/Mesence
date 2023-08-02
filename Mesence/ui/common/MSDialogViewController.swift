//
//  MSDialogViewController.swift
//  Mesence
//
//  Created by 罗志华 on 2023/8/2.
//

import Foundation
import SnapKit
import Cocoa

class CustomDialogView: NSView {
    var cancelButton: NSButton!
    var confirmButton: NSButton!
    var contentTextView: NSTextField!
    var cancelCompletion: Completion?
    var confirmCompletion: Completion?

    override init(frame frameRect: NSRect) {
        super.init(frame: frameRect)

        self.wantsLayer = true
        self.layer?.backgroundColor = NSColor.white.cgColor

        cancelButton = NSButton(title: "拒绝", target: self, action: #selector(cancelButtonClicked))
        cancelButton.layer?.backgroundColor = NSColor.lightGray.cgColor
        cancelButton.titleTextColor = .red
        self.addSubview(cancelButton)

        confirmButton = NSButton(title: "同意", target: self, action: #selector(confirmButtonClicked))
        confirmButton.layer?.backgroundColor = NSColor.green.cgColor
        confirmButton.titleTextColor = .green
        self.addSubview(confirmButton)
        
        contentTextView = NSTextField()
        contentTextView.textColor = .black
        contentTextView.font = NSFont.systemFont(ofSize: 14)
        contentTextView.alignment = .center
        contentTextView.isEditable = false
        contentTextView.isBordered = false
        contentTextView.backgroundColor = .white
        self.addSubview(contentTextView)
        
        cancelButton.snp.makeConstraints { make in
            make.height.equalTo(30)
            make.width.equalTo(100)
            make.centerX.equalTo(self.snp.centerX).offset(-70)
            make.bottom.equalTo(self).offset(-10)
        }
        confirmButton.snp.makeConstraints { make in
            make.height.equalTo(30)
            make.width.equalTo(100)
            make.centerX.equalTo(self.snp.centerX).offset(70)
            make.bottom.equalTo(self).offset(-10)
        }
        contentTextView.snp.makeConstraints { make in
            make.center.equalTo(self)
            make.left.right.equalTo(self)
            make.top.equalTo(self).offset(20)
            make.bottom.equalTo(confirmButton.snp.top).offset(-20)
        }
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    @objc private func cancelButtonClicked() {
        if let dialogWindow = self.window {
            cancelCompletion?()
            NSApplication.shared.stopModal(withCode: NSApplication.ModalResponse.cancel)
            dialogWindow.close()
        }
    }

    @objc private func confirmButtonClicked() {
        if let dialogWindow = self.window {
            confirmCompletion?()
            NSApplication.shared.stopModal(withCode: NSApplication.ModalResponse.OK)
            dialogWindow.close()
        }
    }
}

typealias Completion = () -> ()
class MSDialogViewController: NSViewController {
    var customView: CustomDialogView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    public func showDialog(content: String, confirCompletion: @escaping Completion, cancelCompletion: @escaping Completion) {
        let width: CGFloat = 400
        let height: CGFloat = 150
        let x: CGFloat = (NSScreen.main?.frame.width ?? 0) / 2 - width / 2
        let y: CGFloat = (NSScreen.main?.frame.height ?? 0) / 2 - height / 2
        let rect = NSRect(x: x, y: y, width: width, height: height)
        
        customView = CustomDialogView(frame: rect)
        customView.confirmCompletion = confirCompletion
        customView.cancelCompletion = cancelCompletion
        customView.contentTextView.stringValue = content
        let dialogWindow = NSWindow(contentRect: rect, styleMask: [.titled], backing: .buffered, defer: false)
        dialogWindow.isReleasedWhenClosed = false
        dialogWindow.contentView = customView
        dialogWindow.makeKeyAndOrderFront(nil)
        NSApplication.shared.runModal(for: dialogWindow)
    }
}
