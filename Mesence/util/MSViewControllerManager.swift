//
//  MSViewControllerManager.swift
//  Mesence
//
//  Created by luozhihua on 2023/7/31.
//

import Foundation
import Cocoa

// Manage viewcontrollers in the same window
class MSViewControllerManager {
    private var window: NSWindow?
    private lazy var controllers: [NSViewController] = {
        return [NSViewController]()
    }()
    static let sharedManager: MSViewControllerManager = {
        return MSViewControllerManager()
    }()
    
    private init() {}
    
    public func setCurrentWindow(_ window: NSWindow) {
        self.window = window
    }
    
    deinit {
        self.controllers.removeAll()
    }
    
    func push(_ viewController: NSViewController) {
        guard let window = self.window else  { return }
        if window.contentViewController != viewController {
            self.controllers.append(viewController)
            window.contentViewController = viewController
        }
    }
    
    func pop() {
        guard let window = self.window else  { return }
        if self.controllers.count <= 1 { return }
        self.controllers.removeLast()
        if let lastController = self.controllers.last {
            window.contentViewController = lastController
        }
    }
    
    func present(view: NSView?, size: CGSize) {
        guard let window = self.window else  { return }
        // create above sub window
        window.backgroundColor = NSColor(hexString: "#CACACA")
        let newWindowFrame = CGRect(x: window.frame.origin.x + window.frame.width / 2 - size.width / 2, y: window.frame.origin.y + window.frame.height / 2 - size.height / 2, width: size.width, height: size.height)
        let newWindow = NSWindow(contentRect: newWindowFrame, styleMask: .borderless, backing: .buffered, defer: false)
        newWindow.backgroundColor = .white
        newWindow.level = .floating
        newWindow.collectionBehavior = .transient
        newWindow.contentView = view
        window.addChildWindow(newWindow, ordered: .above)
        
        // bind them
        let baseWindowFrame = window.frame
        NotificationCenter.default.addObserver(forName: NSWindow.didMoveNotification, object: window, queue: nil) { (note) in
            let newBaseWindowFrame = window.frame
            let newNewWindowFrame = NSRect(x: newWindowFrame.origin.x + (newBaseWindowFrame.origin.x - baseWindowFrame.origin.x), y: newWindowFrame.origin.y + (newBaseWindowFrame.origin.y - baseWindowFrame.origin.y), width: newWindowFrame.size.width, height: newWindowFrame.size.height)
            newWindow.setFrame(newNewWindowFrame, display: true)
        }
    }
}
