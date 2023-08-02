//
//  ViewController.swift
//  Mesence
//
//  Created by luozhihua on 2023/7/26.
//

import Cocoa

class MSMainViewController: NSViewController {
    private lazy var headerView: NSView = {
        let view = NSView()
        return view
    }()
    private lazy var headerDividerView: NSView = {
        let view = NSView()
        view.isHidden = true
        view.setBackgroundColor(NSColor(hexString: "#EFEFEF"))
        return view
    }()
    private lazy var leftsideView: MSLeftFriendsListView = {
        let view = MSLeftFriendsListView()
        view.delegate = self
        view.dataSource = self
        return view
    }()
    private lazy var leftsideDividerView: NSView = {
        let view = NSView()
        view.setBackgroundColor(NSColor(hexString: "#EFEFEF"))
        return view
    }()
    private lazy var contentView: MSMainMsgContentView = {
        let view = MSMainMsgContentView(vm: self.vm)
        view.isHidden = true
        return view
    }()
    private lazy var inputView: MSMainInputView = {
        let view = MSMainInputView(vm: self.vm)
        view.isHidden = true
        return view
    }()
    private lazy var inputDividerView: NSView = {
        let view = NSView()
        view.setBackgroundColor(NSColor(hexString: "#EFEFEF"))
        view.isHidden = true
        return view
    }()
    private lazy var vm: MSMainContentVM = {
       return MSMainContentVM(vc: self)
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.initUI()
        self.installLayout()
    }
    
    override var representedObject: Any? {
        didSet {
            // Update the view, if already loaded.
        }
    }
    
    override func loadView() {
        guard let window = NSApplication.shared.windows.first else { return }
        let windowRect = window.frame
        window.delegate = self
        view = NSView(frame: windowRect)
    }
    
    // MARK: - Private Functions
    private func initUI() {
        self.view.addSubview(self.headerView)
        self.view.addSubview(self.headerDividerView)
        self.view.addSubview(self.contentView)
        self.view.addSubview(self.inputView)
        self.view.addSubview(self.inputDividerView)
        self.view.addSubview(self.leftsideView)
        self.view.addSubview(self.leftsideDividerView)
    }
    
    private func installLayout() {
        let leftViewRect = NSRect(origin: CGPoint(x: 0, y: 0), size: CGSize(width: 200, height: self.view.bounds.height))
        
        let leftDividerRect = NSRect(origin: CGPoint(x: leftViewRect.width - 1, y: 5), size: CGSize(width: 1, height: leftViewRect.height - 10))
        
        let inputViewRect = NSRect(origin: CGPoint(x: leftViewRect.width, y: 0),
                                   size: CGSize(width: self.view.bounds.width - leftViewRect.width - leftDividerRect.width, height: 100))
        
        let inputDividerRect = NSRect(origin: CGPoint(x: inputViewRect.origin.x + 5, y: inputViewRect.origin.y + inputViewRect.height - 1),
                                      size: CGSize(width: inputViewRect.width - 10, height: 1))
        
        let headerViewRect = NSRect(origin: CGPoint(x: leftViewRect.width, y: self.view.bounds.height - 80),
                                    size: CGSize(width: inputViewRect.width, height: 80))
        
        let headerDividerRect = NSRect(origin: CGPoint(x: inputViewRect.origin.x + 5, y: headerViewRect.origin.y - 1),
                                       size: CGSize(width: headerViewRect.width - 10, height: 1))
        
        let contentViewRect = NSRect(origin: CGPoint(x: leftViewRect.width, y:inputViewRect.origin.y + inputViewRect.height + inputDividerRect.height),
                                     size: CGSize(width: inputViewRect.width, height: self.view.bounds.height - inputViewRect.height - headerViewRect.height - inputDividerRect.height - headerDividerRect.height))
    
        self.leftsideView.frame = leftViewRect
        self.leftsideDividerView.frame = leftDividerRect
        self.inputView.frame = inputViewRect
        self.inputDividerView.frame = inputDividerRect
        self.contentView.frame = contentViewRect
        self.headerView.frame = headerViewRect
        self.headerDividerView.frame = headerDividerRect
        self.leftsideView.reloadData()
    }
    
    // MARK: - public Functions
    public func checkoutCurrentUser() {
        self.inputView.isHidden = self.vm.currentUser == nil
        self.headerView.isHidden = self.vm.currentUser == nil
        self.contentView.isHidden = self.vm.currentUser == nil
        self.inputDividerView.isHidden = self.vm.currentUser == nil
    }
    
    public func reloadFriendsListView() {
        self.leftsideView.reloadData()
    }
    
    public func reloadMainView() {
        self.contentView.reloadData()
    }
    
    public func receiveNewFriendRequst(msg: Msg) {
        var mutableMsg = msg
        let message = "收到来来自 ---\(msg.data.from)--- 的好友请求，是否同意"
        MSDialogViewController().showDialog(content: message) {
            mutableMsg.data.setRequestStatus(status: .accepted)
            self.vm.responseToFriendRequest(msg: mutableMsg)
        } cancelCompletion: {
            mutableMsg.data.setRequestStatus(status: .refused)
            self.vm.responseToFriendRequest(msg: mutableMsg)
        }
    }
    
    public func receiveOldFriendRequst(msg: Msg) {
        let message = "\(msg.data.from)---\(msg.data.requestStatus == .accepted ?  "同意了你的好友请求" : "拒绝了你的好友请求")"
        MSDialogViewController().showDialog(content: message) {
            
        } cancelCompletion: {
            
        }
    }
}

extension MSMainViewController: NSWindowDelegate {
    func windowWillResize(_ sender: NSWindow, to frameSize: NSSize) -> NSSize {
        let width = max(frameSize.width, 600)
        let height = max(frameSize.height, 360)
        return NSSize(width: width, height: height)
    }
    
    func windowDidResize(_ notification: Notification) {
        self.installLayout()
    }
}

extension MSMainViewController: MSLeftFriendListViewDelegate, MSLeftFriendListViewDataSource {
    func didClickItem(atIndex: Int) {
        if let user = self.vm.friendsList?[safe: atIndex]?.Friend {
            self.checkoutCurrentUser()
            self.vm.checkoutCurrentUser(user)
        }
    }
    
    func didClickAddNewUser() {
        self.vm.requestAdddNewuser(to: "test")
    }
    
    var friendList: [FriendDataStruct]? {
        return vm.friendsList
    }
}

