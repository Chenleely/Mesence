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
    private let dataSource = [
        "你好啊，你好啊，你好啊",
        "sadthoasd,gasdjgh fasdgasd gasdhgfdsaffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffgasdhgfdsaffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffgasdhgfdsaffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff",
        "fasdghasdl",
        "sadthoasd,gasdjgh fasdgasd gasdhg",
        "你好啊，你好啊，你好啊",
        "fasdghasdl",
        "sadthoasd,gasdjgh fasdgasd gasdhg",
        "你好啊，你好啊，你好啊",
        "fasdghasdl",
        "sadthoasd,gasdjgh fasdgasd gasdhg",
        "你好啊，你好啊，你好啊",
        "fasdghasdl",
        "sadthoasd,gasdjgh fasdgasd gasdhg",
        "你好啊，你好啊，你好啊",
        "fasdghasdl",
        "sadthoasd,gasdjgh fasdgasd gasdhg",
        "你好啊，你好啊，你好啊",
        "fasdghasdl",
        "sadthoasd,gasdjgh fasdgasd gasdhg",
        "你好啊，你好啊，你好啊",
        "fasdghasdl",
        "sadthoasd,gasdjgh fasdgasd gasdhg",
        "你好啊，你好啊，你好啊",
        "fasdghasdl",
        "sadthoasd,gasdjgh fasdgasd gasdhg",
        "你好啊，你好啊，你好啊",
        "fasdghasdl",
        "sadthoasd,gasdjgh fasdgasd gasdhg",
        "你好啊，你好啊，你好啊",
        "fasdghasdl",
        "sadthoasd,gasdjgh fasdgasd gasdhg",
        "你好啊，你好啊，你好啊",
        "fasdghasdl",
        "sadthoasd,gasdjgh fasdgasd gasdhg",
        "你好啊，你好啊，你好啊",
        "fasdghasdl",
        "sadthoasd,gasdjgh fasdgasd gasdhg",
        "你好啊，你好啊，你好啊",
        "fasdghasdl",
        "sadthoasd,gasdjgh fasdgasd gasdhg",
        "你好啊，你好啊，你好啊",
        "fasdghasdl",
    ]
    
    private static let tableColumnID = NSUserInterfaceItemIdentifier(rawValue: "contentTableViewCellID")
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
    
    override init(frame frameRect: NSRect) {
        super.init(frame: frameRect)
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
        return dataSource.count
    }
    
    func tableView(_ tableView: NSTableView, viewFor tableColumn: NSTableColumn?, row: Int) -> NSView? {
        var cell = tableView.makeView(withIdentifier: MSMainMsgContentView.tableColumnID, owner: self)
        if cell == nil {
            cell = MSMainMsgContentCellView()
        }
        if let contentCell = cell as? MSMainMsgContentCellView {
            contentCell.config(dataSource[row], msgType: row % 2 != 0 ? .mine : .other )
        }
        return cell
    }
    
    func tableView(_ tableView: NSTableView, heightOfRow row: Int) -> CGFloat {
        let size =  MSMainMsgContentCellView.calcuteCellSize(dataSource[row], withMaxWidth: self.frame.width - 20)
        return size.height
    }
}
