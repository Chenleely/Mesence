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
}
