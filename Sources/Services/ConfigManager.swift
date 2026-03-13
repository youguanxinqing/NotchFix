import Foundation

class ConfigManager {
    static let shared = ConfigManager()
    
    private let configURL: URL
    private var config: Config
    
    private init() {
        let appSupport = FileManager.default.urls(for: .applicationSupportDirectory, in: .userDomainMask).first!
        let appDir = appSupport.appendingPathComponent("NotchFix", isDirectory: true)
        
        // 创建目录
        do {
            try FileManager.default.createDirectory(at: appDir, withIntermediateDirectories: true)
        } catch {
            print("❌ 创建配置目录失败: \(error.localizedDescription)")
        }
        
        configURL = appDir.appendingPathComponent("config.json")
        
        // 加载配置
        if let data = try? Data(contentsOf: configURL),
           let loadedConfig = try? JSONDecoder().decode(Config.self, from: data) {
            config = loadedConfig
            print("✅ 配置已加载")
        } else {
            config = .default
            print("ℹ️ 使用默认配置")
        }
    }
    
    func getConfig() -> Config {
        return config
    }
    
    func updateConfig(_ newConfig: Config) {
        config = newConfig
        save()
    }
    
    func toggleIconVisibility(bundleId: String) {
        if config.hiddenApps.contains(bundleId) {
            config.hiddenApps.removeAll { $0 == bundleId }
        } else {
            config.hiddenApps.append(bundleId)
        }
        save()
    }
    
    private func save() {
        do {
            let data = try JSONEncoder().encode(config)
            try data.write(to: configURL)
            print("✅ 配置已保存")
        } catch {
            print("❌ 保存配置失败: \(error)")
        }
    }
}
