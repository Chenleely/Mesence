//
//  AppDelegate.swift
//  Mesence
//
//  Created by luozhihua on 2023/7/26.
//

import Cocoa


class AppDelegate: NSObject, NSApplicationDelegate {
    lazy var mainWindow: NSWindow = {
        let window = NSWindow(contentRect: NSMakeRect(0, 0, 1200, 720),
                              styleMask: [.titled, .resizable, .miniaturizable, .closable, .fullSizeContentView],
                               backing: .buffered,
                               defer: false)
        window.minSize = NSMakeSize(500, 300)
        window.titleVisibility = .hidden
        window.titlebarAppearsTransparent = true
        window.isMovableByWindowBackground = true
        window.backgroundColor = .white
        window.center()
        return window
    }()
    
    func applicationDidFinishLaunching(_ aNotification: Notification) {
        mainWindow.makeKeyAndOrderFront(nil)
        MSViewControllerManager.sharedManager.setCurrentWindow(mainWindow)
        let rootVC = MSLoginManager.shared.checkTokenValid() ? MSMainViewController() : MSLogingViewController()
        MSViewControllerManager.sharedManager.push(rootVC)
    }

    func applicationWillTerminate(_ aNotification: Notification) {
        // Insert code here to tear down your application
    }

    func applicationSupportsSecureRestorableState(_ app: NSApplication) -> Bool {
        return true
    }
}

