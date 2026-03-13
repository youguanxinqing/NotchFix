import AppKit

// 这个文件是 Swift Package 的入口点
// 实际的 App 入口在 App/NotchFixApp.swift

// 启动 SwiftUI App
let app = NSApplication.shared
let delegate = AppDelegate()
app.delegate = delegate
app.run()
