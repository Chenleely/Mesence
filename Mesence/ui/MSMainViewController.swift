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
        view.setBackgroundColor(NSColor(hexString: "#EFEFEF"))
        return view
    }()
    private lazy var leftsideView: NSView = {
        let view = NSView()
        return view
    }()
    private lazy var leftsideDividerView: NSView = {
        let view = NSView()
        view.setBackgroundColor(NSColor(hexString: "#EFEFEF"))
        return view
    }()
    private lazy var contentView: MSMainMsgContentView = {
        let view = MSMainMsgContentView()
        return view
    }()
    private lazy var inputView: MSMainInputView = {
        let view = MSMainInputView()
        return view
    }()
    private lazy var inputDividerView: NSView = {
        let view = NSView()
        view.setBackgroundColor(NSColor(hexString: "#EFEFEF"))
        return view
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


