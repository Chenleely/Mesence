//
//  AppDelegate.swift
//  Mesence
//
//  Created by luozhihua on 2023/7/26.
//

import Cocoa


class AppDelegate: NSObject, NSApplicationDelegate {
    var mainWindow: NSWindow? // Main Window
    func applicationDidFinishLaunching(_ aNotification: Notification) {
         mainWindow = NSWindow(contentRect: NSMakeRect(0, 0, 1200, 720),
                               styleMask: [.titled, .resizable, .miniaturizable, .closable, .fullSizeContentView],
                                backing: .buffered,
                                defer: false)
        mainWindow?.minSize = NSMakeSize(500, 300)
        mainWindow?.contentViewController = ViewController()
        mainWindow?.titleVisibility = .hidden
        mainWindow?.titlebarAppearsTransparent = true
        mainWindow?.isMovableByWindowBackground = true
        mainWindow?.backgroundColor = .white
        mainWindow?.center()
        mainWindow?.makeKeyAndOrderFront(nil)
    }

    func applicationWillTerminate(_ aNotification: Notification) {
        // Insert code here to tear down your application
    }

    func applicationSupportsSecureRestorableState(_ app: NSApplication) -> Bool {
        return true
    }


}

