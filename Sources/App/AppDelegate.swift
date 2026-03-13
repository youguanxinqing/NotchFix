import AppKit
import SwiftUI

class AppDelegate: NSObject, NSApplicationDelegate {
    var statusItem: NSStatusItem?
    var popover: NSPopover?
    var menu: NSMenu?
    var eventMonitor: Any?
    
    func applicationDidFinishLaunching(_ notification: Notification) {
        // 创建菜单栏图标
        statusItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.variableLength)
        
        if let button = statusItem?.button {
            button.image = NSImage(systemSymbolName: "ellipsis.circle", accessibilityDescription: "NotchFix")
            button.action = #selector(handleClick)
            button.sendAction(on: [.leftMouseUp, .rightMouseUp])
            button.target = self
        }
        
        // 创建弹出窗口
        popover = NSPopover()
        popover?.contentSize = NSSize(width: 300, height: 400)
        popover?.behavior = .transient
        popover?.contentViewController = NSHostingController(rootView: IconListView())
        
        // 监听点击事件以关闭弹窗
        setupEventMonitor()
        
        // 创建右键菜单
        setupMenu()
    }
    
    func setupEventMonitor() {
        eventMonitor = NSEvent.addGlobalMonitorForEvents(matching: [.leftMouseDown, .rightMouseDown]) { [weak self] event in
            if let popover = self?.popover, popover.isShown {
                self?.closePopover()
            }
        }
    }
    
    deinit {
        if let monitor = eventMonitor {
            NSEvent.removeMonitor(monitor)
        }
    }
    
    func setupMenu() {
        menu = NSMenu()
        
        // 刷新图标列表
        let refreshItem = NSMenuItem(title: "刷新图标列表", action: #selector(refreshIcons), keyEquivalent: "r")
        refreshItem.target = self
        menu?.addItem(refreshItem)
        
        menu?.addItem(NSMenuItem.separator())
        
        // 打开设置
        let settingsItem = NSMenuItem(title: "设置...", action: #selector(openSettings), keyEquivalent: ",")
        settingsItem.target = self
        menu?.addItem(settingsItem)
        
        menu?.addItem(NSMenuItem.separator())
        
        // 退出
        let quitItem = NSMenuItem(title: "退出 NotchFix", action: #selector(quitApp), keyEquivalent: "q")
        quitItem.target = self
        menu?.addItem(quitItem)
    }
    
    @objc func handleClick() {
        guard let event = NSApp.currentEvent else { return }
        
        if event.type == .rightMouseUp {
            // 右键点击 - 显示菜单
            showMenu()
        } else {
            // 左键点击 - 显示弹出窗口
            togglePopover()
        }
    }
    
    @objc func showMenu() {
        guard let button = statusItem?.button, let menu = menu else { return }
        statusItem?.menu = menu
        button.performClick(nil)
        statusItem?.menu = nil
    }
    
    @objc func togglePopover() {
        guard let button = statusItem?.button else { return }
        
        if let popover = popover {
            if popover.isShown {
                closePopover()
            } else {
                popover.show(relativeTo: button.bounds, of: button, preferredEdge: .minY)
                // 激活应用以确保弹窗获得焦点
                NSApp.activate(ignoringOtherApps: true)
            }
        }
    }
    
    func closePopover() {
        popover?.performClose(nil)
    }
    
    @objc func refreshIcons() {
        // 触发图标列表刷新
        NotificationCenter.default.post(name: NSNotification.Name("RefreshIcons"), object: nil)
    }
    
    @objc func openSettings() {
        NSApp.activate(ignoringOtherApps: true)
        NSApp.sendAction(Selector(("showSettingsWindow:")), to: nil, from: nil)
    }
    
    @objc func quitApp() {
        NSApplication.shared.terminate(nil)
    }
}
