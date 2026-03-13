import AppKit
import ApplicationServices

class IconManager {
    static let shared = IconManager()
    
    private var hiddenIcons: [String: AXUIElement] = [:]
    
    private init() {}
    
    /// 隐藏指定的菜单栏图标
    func hideIcon(bundleId: String) -> Bool {
        guard let element = findIconElement(bundleId: bundleId) else {
            print("❌ 找不到图标: \(bundleId)")
            return false
        }
        
        // 尝试隐藏图标（通过设置 hidden 属性）
        let hidden: CFTypeRef = kCFBooleanTrue
        let result = AXUIElementSetAttributeValue(
            element,
            kAXHiddenAttribute as CFString,
            hidden
        )
        
        if result == .success {
            hiddenIcons[bundleId] = element
            print("✅ 已隐藏图标: \(bundleId)")
            return true
        } else {
            print("⚠️ 无法隐藏图标: \(bundleId), 错误码: \(result.rawValue)")
            return false
        }
    }
    
    /// 显示指定的菜单栏图标
    func showIcon(bundleId: String) -> Bool {
        guard let element = hiddenIcons[bundleId] ?? findIconElement(bundleId: bundleId) else {
            print("❌ 找不到图标: \(bundleId)")
            return false
        }
        
        // 显示图标
        let hidden: CFTypeRef = kCFBooleanFalse
        let result = AXUIElementSetAttributeValue(
            element,
            kAXHiddenAttribute as CFString,
            hidden
        )
        
        if result == .success {
            hiddenIcons.removeValue(forKey: bundleId)
            print("✅ 已显示图标: \(bundleId)")
            return true
        } else {
            print("⚠️ 无法显示图标: \(bundleId), 错误码: \(result.rawValue)")
            return false
        }
    }
    
    /// 查找指定 bundle ID 的菜单栏图标元素
    private func findIconElement(bundleId: String) -> AXUIElement? {
        let systemWideElement = AXUIElementCreateSystemWide()
        
        var menuBarRef: CFTypeRef?
        guard AXUIElementCopyAttributeValue(
            systemWideElement,
            kAXMenuBarAttribute as CFString,
            &menuBarRef
        ) == .success, menuBarRef != nil else {
            return nil
        }
        
        let menuBar = menuBarRef as! AXUIElement
        
        var childrenRef: CFTypeRef?
        guard AXUIElementCopyAttributeValue(
            menuBar,
            kAXChildrenAttribute as CFString,
            &childrenRef
        ) == .success,
              let children = childrenRef as? [AXUIElement] else {
            return nil
        }
        
        // 遍历查找匹配的图标
        for child in children {
            var pidValue: pid_t = 0
            AXUIElementGetPid(child, &pidValue)
            
            if pidValue > 0 {
                let runningApp = NSRunningApplication(processIdentifier: pidValue)
                if runningApp?.bundleIdentifier == bundleId {
                    return child
                }
            }
        }
        
        return nil
    }
    
    /// 应用配置中的隐藏设置
    func applyConfig(_ config: Config) {
        for bundleId in config.hiddenApps {
            _ = hideIcon(bundleId: bundleId)
        }
    }
}
