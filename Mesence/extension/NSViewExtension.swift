//
//  NSViewExtension.swift
//  Mesence
//
//  Created by luozhihua on 2023/7/27.
//

import Foundation
import Cocoa
public extension NSView {
    func setBackgroundColor(_ color: NSColor) {
        self.wantsLayer = true
        self.layer?.backgroundColor = color.cgColor
    }
}

public extension NSWindow {
    /// 默认大小
    static var defaultRect: CGRect {
        return CGRectMake(0, 0, 300, 300)
    }

    static func create(_ rect: CGRect = NSWindow.defaultRect, title: String = "Mesence") -> Self {
    //        let style = NSWindow.StyleMask.titled.rawValue | NSWindow.StyleMask.closable.rawValue | NSWindow.StyleMask.miniaturizable.rawValue | NSWindow.StyleMask.resizable.rawValue
        let style: NSWindow.StyleMask = [.titled, .closable, .miniaturizable, .resizable]
        let window = self.init(contentRect: rect, styleMask: style, backing: .buffered, defer: false)
        window.title = title
        window.titlebarAppearsTransparent = true
        return window;
    }

    static func create(_ rect: CGRect = NSWindow.defaultRect, controller: NSViewController) -> Self {
        let window = Self.create(rect, title: controller.title ?? "")
        window.contentViewController = controller;
        return window;
    }
    
    static func createMain(_ rect: CGRect = NSWindow.defaultRect, title: String = "Mesence") -> Self {
        let window = Self.create(rect, title: title)
        window.contentMinSize = window.frame.size;
        window.makeKeyAndOrderFront(self)
        window.center()
        return window;
    }
    /// 下拉弹窗
    static func show(with controller: NSViewController, size: CGSize, handler: ((NSApplication.ModalResponse) -> Void)? = nil) {
        controller.preferredContentSize = size
        let rect = CGRectMake(0, 0, size.width, size.height)

        let panel = Self.create(rect, controller: controller)
        panel.center()
        NSApp.mainWindow?.beginSheet(panel, completionHandler: handler)
    }
    /// 下拉弹窗关闭
    static func end(with controller: NSViewController, response: NSApplication.ModalResponse) {
        guard let window = controller.view.window else { return }
        if window.isMember(of: Self.classForCoder()) == true {
//            view.window?.orderOut(self)
            NSApp.mainWindow?.endSheet(window, returnCode: response)
        }
    }
}
