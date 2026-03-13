import AppKit

class AppScanner {
    static let shared = AppScanner()
    
    private init() {}
    
    /// 扫描所有正在运行的应用
    func scanRunningApps() -> [MenuBarApp] {
        var apps: [MenuBarApp] = []
        
        print("🔍 开始扫描正在运行的应用...")
        
        let runningApps = NSWorkspace.shared.runningApplications
        print("📊 找到 \(runningApps.count) 个正在运行的应用")
        
        for app in runningApps {
            // 过滤掉系统应用和没有 UI 的应用
            guard let bundleId = app.bundleIdentifier,
                  let localizedName = app.localizedName,
                  app.activationPolicy != .prohibited else {
                continue
            }
            
            // 判断是否是菜单栏应用
            let isMenuBarApp = app.activationPolicy == .accessory || 
                               isLikelyMenuBarApp(app)
            
            let menuBarApp = MenuBarApp(
                bundleIdentifier: bundleId,
                name: localizedName,
                icon: app.icon,
                isMenuBarApp: isMenuBarApp,
                app: app
            )
            
            apps.append(menuBarApp)
            
            if isMenuBarApp {
                print("  📌 \(localizedName) - \(bundleId)")
            }
        }
        
        // 按名称排序
        apps.sort { $0.name < $1.name }
        
        let menuBarCount = apps.filter { $0.isMenuBarApp }.count
        print("✅ 扫描完成: \(apps.count) 个应用，其中 \(menuBarCount) 个菜单栏应用")
        
        return apps
    }
    
    /// 判断应用是否可能是菜单栏应用
    private func isLikelyMenuBarApp(_ app: NSRunningApplication) -> Bool {
        // 检查 LSUIElement (后台应用标记)
        if let bundleURL = app.bundleURL {
            let infoPlistURL = bundleURL.appendingPathComponent("Contents/Info.plist")
            if let infoDict = NSDictionary(contentsOf: infoPlistURL) {
                if let lsUIElement = infoDict["LSUIElement"] as? Bool, lsUIElement {
                    return true
                }
            }
        }
        
        // 如果应用没有窗口但在运行，可能是菜单栏应用
        // 这个判断不太准确，但可以作为参考
        return false
    }
}
