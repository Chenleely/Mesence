//
//  MSLeftFriendsListView.swift
//  Mesence
//
//  Created by 罗志华 on 2023/8/2.
//

import Foundation
import Cocoa

class MSLeftFriendsListView: NSView {
    public weak var delegate: MSLeftFriendListViewDelegate? = nil
    public weak var dataSource: MSLeftFriendListViewDataSource? = nil
    private let tableColumnID = NSUserInterfaceItemIdentifier(rawValue: "LeftFriendsListViewCellID")
    private lazy var contentScrollView: NSScrollView = {
        let scrollView = NSScrollView()
        scrollView.autoresizingMask = [.height, .width]
        scrollView.documentView = contentTableView
        scrollView.hasVerticalScroller = true
        scrollView.backgroundColor = .white
        self.addSubview(scrollView)
        return scrollView
    }()
    private lazy var contentTableView: NSTableView = {
        let tableView = NSTableView()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.allowsColumnResizing = false
        tableView.allowsColumnReordering = false
        tableView.backgroundColor = .white
        tableView.selectionHighlightStyle = .none
        let column = NSTableColumn(identifier: tableColumnID)
        tableView.addTableColumn(column)
        tableView.headerView = nil
        self.addSubview(tableView)
        return tableView
    }()
    private lazy var addNewUserButton: NSButton = {
        let button = NSButton(image: NSImage(named: "add_new_user")!, target: self, action: #selector(clickAddNewUser))
        button.isBordered = false
        self.addSubview(button)
        return button
    }()
    
    override init(frame frameRect: NSRect) {
        super.init(frame: frameRect)
        self.installLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("Can't do this")
    }
    
    private func installLayout() {
        addNewUserButton.snp.makeConstraints { make in
            make.height.width.equalTo(20)
            make.top.equalTo(self).offset(20)
            make.right.equalTo(self).offset(-10)
        }
        contentScrollView.snp.makeConstraints { make in
            make.top.equalTo(addNewUserButton.snp.bottom).offset(10)
            make.left.right.bottom.equalTo(self)
        }
    }
    
    @objc private func clickAddNewUser() {
        delegate?.didClickAddNewUser()
    }
    
    // MARK: - Public Methods
    func reloadData() {
        self.contentTableView.reloadData()
    }
}

extension MSLeftFriendsListView: NSTableViewDelegate, NSTableViewDataSource {
    func numberOfRows(in tableView: NSTableView) -> Int {
        return dataSource?.friendList?.count ?? 0
    }
    
    func tableView(_ tableView: NSTableView, viewFor tableColumn: NSTableColumn?, row: Int) -> NSView? {
        var cell = tableView.makeView(withIdentifier: tableColumnID, owner: self)
        if cell == nil {
            cell = MSLeftFriendsListCellView()
        }
        if let friendsListCell = cell as? MSLeftFriendsListCellView, let friend = dataSource?.friendList?[row]{
            friendsListCell.configCell(friend)
        }
        return cell
    }
    
    func tableViewSelectionDidChange(_ notification: Notification) {
        if let tableView = notification.object as? NSTableView {
            delegate?.didClickItem(atIndex: tableView.selectedRow)
        }
    }
    
    func tableView(_ tableView: NSTableView, didClick tableColumn: NSTableColumn) {
        delegate?.didClickItem(atIndex: tableView.selectedRow)
    }
    
    func tableView(_ tableView: NSTableView, heightOfRow row: Int) -> CGFloat {
        return 50
    }
}

