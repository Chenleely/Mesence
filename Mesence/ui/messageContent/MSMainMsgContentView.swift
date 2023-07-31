//
//  MSMainMsgContentView.swift
//  Mesence
//
//  Created by luozhihua on 2023/7/27.
//

import Foundation
import SnapKit
import Cocoa

class MSMainMsgContentView: NSView {
    private static let tableColumnID = NSUserInterfaceItemIdentifier(rawValue: "contentTableViewCellID")
    private var vm: MSMainContentVM? = nil
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
        let column = NSTableColumn(identifier: MSMainMsgContentView.tableColumnID)
        tableView.addTableColumn(column)
        tableView.headerView = nil
        self.addSubview(tableView)
        return tableView
    }()
    
    override var frame: NSRect {
        didSet {
            if frame.width > 0 {
                self.installLayout()
            }
        }
    }
    
    convenience init(vm: MSMainContentVM) {
        self.init(frame: CGRectZero)
        self.vm = vm
        self.vm?.getMsgList()
    }
    
    override init(frame frameRect: NSRect) {
        super.init(frame: frameRect)
        NotificationCenter.default.addObserver(self, selector: #selector(onMessageListChanged), name: MSMainContentVM.MSMessageListChanceNofiName, object: nil)
    }
    
    @objc func onMessageListChanged() {
        contentTableView.reloadData()
        if let count = self.vm?.msgList.count {
            contentTableView.scrollRowToVisible(count - 1)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("Can't init object through this method")
    }
    
    private func installLayout() {
        contentScrollView.snp.makeConstraints { make in
            make.edges.equalTo(self)
        }
    }
    
    public func reloadData() {
        contentTableView.reloadData()
    }
}

extension MSMainMsgContentView: NSTableViewDelegate, NSTableViewDataSource {
    func numberOfRows(in tableView: NSTableView) -> Int {
        return vm?.msgList.count ?? 0
    }
    
    func tableView(_ tableView: NSTableView, viewFor tableColumn: NSTableColumn?, row: Int) -> NSView? {
        var cell = tableView.makeView(withIdentifier: MSMainMsgContentView.tableColumnID, owner: self)
        if cell == nil {
            cell = MSMainMsgContentCellView()
        }
        if let contentCell = cell as? MSMainMsgContentCellView, let msg = vm?.msgList[row]{
            contentCell.config(msg: msg, msgType: msg.data.from == "user" ? .mine : .other )
        }
        return cell
    }
    
    func tableView(_ tableView: NSTableView, heightOfRow row: Int) -> CGFloat {
        if let msg = vm?.msgList[row] {
            let size =  MSMainMsgContentCellView.calcuteCellSize(msg.data.content, withMaxWidth: self.frame.width - 20)
            return size.height
        }
        return 0
    }
}
