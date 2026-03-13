import AppKit
import ApplicationServices

class MenuBarScanner {
    static let shared = MenuBarScanner()
    
    private init() {}
    
    func scanMenuBarIcons() -> [MenuBarIcon] {
        var icons: [MenuBarIcon] = []
        
        // 获取系统级 UI 元素
        let systemWideElement = AXUIElementCreateSystemWide()
        
        var menuBarRef: CFTypeRef?
        let result = AXUIElementCopyAttributeValue(
            systemWideElement,
            kAXMenuBarAttribute as CFString,
            &menuBarRef
        )
        
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
        
        // 遍历菜单栏项
        for child in children {
            if let icon = extractIconInfo(from: child) {
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
}
