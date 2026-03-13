import AppKit
import ApplicationServices

class MenuBarScanner {
    static let shared = MenuBarScanner()
    
    private init() {}
    
    func scanMenuBarIcons() -> [MenuBarIcon] {
        var icons: [MenuBarIcon] = []
        
        print("🔍 开始扫描菜单栏图标...")
        
        // 先检查权限
        let trusted = AXIsProcessTrusted()
        if !trusted {
            print("⚠️ 没有辅助功能权限，尝试请求...")
            let options: NSDictionary = [kAXTrustedCheckOptionPrompt.takeUnretainedValue() as String: true]
            _ = AXIsProcessTrustedWithOptions(options)
            print("❌ 请在系统设置中授予辅助功能权限后重启应用")
            return icons
        }
        
        print("✅ 已获得辅助功能权限")
        
        // 获取系统级 UI 元素
        let systemWideElement = AXUIElementCreateSystemWide()
        
        var menuBarRef: CFTypeRef?
        let result = AXUIElementCopyAttributeValue(
            systemWideElement,
            kAXMenuBarAttribute as CFString,
            &menuBarRef
        )
        
        print("📊 获取菜单栏结果: \(result.rawValue) (\(axErrorDescription(result)))")
        
        guard result == .success, menuBarRef != nil else {
            print("❌ 无法访问菜单栏")
            return icons
        }
        
        let menuBar = menuBarRef as! AXUIElement
        
        // 获取菜单栏的子元素
        var childrenRef: CFTypeRef?
        let childrenResult = AXUIElementCopyAttributeValue(
            menuBar,
            kAXChildrenAttribute as CFString,
            &childrenRef
        )
        
        guard childrenResult == .success,
              let children = childrenRef as? [AXUIElement] else {
            print("❌ 无法获取菜单栏子元素")
            return icons
        }
        
        print("📋 找到 \(children.count) 个菜单栏元素")
        
        // 遍历菜单栏项
        for (index, child) in children.enumerated() {
            if let icon = extractIconInfo(from: child) {
                print("  [\(index)] \(icon.name) - \(icon.bundleIdentifier ?? "无 Bundle ID")")
                icons.append(icon)
            }
        }
        
        print("✅ 扫描到 \(icons.count) 个菜单栏图标")
        return icons
    }
    
    private func extractIconInfo(from element: AXUIElement) -> MenuBarIcon? {
        // 获取标题
        var titleRef: CFTypeRef?
        AXUIElementCopyAttributeValue(element, kAXTitleAttribute as CFString, &titleRef)
        let title = titleRef as? String ?? "Unknown"
        
        // 获取描述
        var descRef: CFTypeRef?
        AXUIElementCopyAttributeValue(element, kAXDescriptionAttribute as CFString, &descRef)
        let description = descRef as? String
        
        // 尝试获取进程 ID
        var pidValue: pid_t = 0
        AXUIElementGetPid(element, &pidValue)
        
        var bundleId: String?
        if pidValue > 0 {
            let runningApp = NSRunningApplication(processIdentifier: pidValue)
            bundleId = runningApp?.bundleIdentifier
        }
        
        let name = description ?? title
        return MenuBarIcon(name: name, bundleIdentifier: bundleId)
    }
    
    private func axErrorDescription(_ error: AXError) -> String {
        switch error {
        case .success: return "成功"
        case .failure: return "失败"
        case .illegalArgument: return "非法参数"
        case .invalidUIElement: return "无效的 UI 元素"
        case .invalidUIElementObserver: return "无效的观察者"
        case .cannotComplete: return "无法完成"
        case .attributeUnsupported: return "属性不支持"
        case .actionUnsupported: return "操作不支持"
        case .notificationUnsupported: return "通知不支持"
        case .notImplemented: return "未实现"
        case .notificationAlreadyRegistered: return "通知已注册"
        case .notificationNotRegistered: return "通知未注册"
        case .apiDisabled: return "API 已禁用 - 需要辅助功能权限"
        case .noValue: return "无值"
        case .parameterizedAttributeUnsupported: return "参数化属性不支持"
        case .notEnoughPrecision: return "精度不足"
        default: return "未知错误 (\(error.rawValue))"
        }
    }
}
