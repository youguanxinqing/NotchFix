import AppKit
import Foundation

struct MenuBarApp: Identifiable {
    let id: String
    let bundleIdentifier: String
    let name: String
    let icon: NSImage?
    let isMenuBarApp: Bool
    weak var app: NSRunningApplication?
    
    init(bundleIdentifier: String, name: String, icon: NSImage?, isMenuBarApp: Bool, app: NSRunningApplication) {
        self.id = bundleIdentifier
        self.bundleIdentifier = bundleIdentifier
        self.name = name
        self.icon = icon
        self.isMenuBarApp = isMenuBarApp
        self.app = app
    }
    
    /// 激活应用
    func activate() {
        app?.activate(options: .activateIgnoringOtherApps)
    }
    
    /// 隐藏应用
    func hide() {
        app?.hide()
    }
    
    /// 退出应用
    func quit() {
        app?.terminate()
    }
}
