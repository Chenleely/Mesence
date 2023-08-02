//
//  MSLeftFriendsListCellView.swift
//  Mesence
//
//  Created by 罗志华 on 2023/8/2.
//

import Foundation
import SnapKit
import Cocoa

class MSLeftFriendsListCellView: NSTableCellView {
    private lazy var userAvatarImageView: NSImageView = {
        let imageView = NSImageView(image: NSImage(named: "user_avatar_placeholder")!)
        self.addSubview(imageView)
        return imageView
    }()
    private lazy var userNameTextLabel: NSTextField = {
        let tv = NSTextField()
        tv.alignment = .left
        tv.isEditable = false
        tv.isBordered = false
        tv.backgroundColor = .clear
        tv.font = NSFont.systemFont(ofSize: 14)
        tv.textColor = NSColor(hexString: "#181818")
        self.addSubview(tv)
        return tv
    }()
    private lazy var userDividerView: NSView = {
        let view = NSView()
        view.wantsLayer = true
        view.layer?.backgroundColor = NSColor(hexString: "#DEDEDE").cgColor
        self.addSubview(view)
        return view
    }()
    
    required init?(coder: NSCoder) {
        fatalError("can't do this")
    }
    
    override init(frame frameRect: NSRect) {
        super.init(frame: frameRect)
        self.installLayout()
    }
    
    // MARK: - Public Methods
    private func installLayout() {
        self.userAvatarImageView.snp.makeConstraints { make in
            make.centerY.equalTo(self)
            make.height.width.equalTo(25)
            make.left.equalTo(self).offset(20)
        }
        self.userNameTextLabel.snp.makeConstraints { make in
            make.right.centerY.equalTo(self)
            make.height.equalTo(20)
            make.left.equalTo(self.userAvatarImageView.snp.right).offset(10)
        }
        self.userDividerView.snp.makeConstraints { make in
            make.height.equalTo(1)
            make.left.right.bottom.equalTo(self)
        }
    }
    
    // MARK: - Public Methods
    public func configCell(_ friend: FriendDataStruct?) {
        self.userNameTextLabel.stringValue = friend?.Friend?.Name ?? "user"
    }
}
