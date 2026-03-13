import SwiftUI

struct IconListView: View {
    @State private var icons: [MenuBarIcon] = []
    @State private var isScanning = false
    
    var body: some View {
        VStack(spacing: 0) {
            // 标题栏
            HStack {
                Text("菜单栏图标")
                    .font(.headline)
                Spacer()
                Button(action: scanIcons) {
                    Image(systemName: "arrow.clockwise")
                }
                .disabled(isScanning)
            }
            .padding()
            
            Divider()
            
            // 图标列表
            if icons.isEmpty {
                VStack(spacing: 12) {
                    Image(systemName: "tray")
                        .font(.system(size: 48))
                        .foregroundColor(.secondary)
                    Text(isScanning ? "扫描中..." : "点击刷新按钮扫描图标")
                        .foregroundColor(.secondary)
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
            } else {
                List {
                    ForEach(icons) { icon in
                        IconRow(icon: icon)
                    }
                }
            }
        }
        .frame(width: 300, height: 400)
        .onAppear {
            scanIcons()
            // 监听刷新通知
            NotificationCenter.default.addObserver(
                forName: NSNotification.Name("RefreshIcons"),
                object: nil,
                queue: .main
            ) { _ in
                scanIcons()
            }
        }
    }
    
    private func scanIcons() {
        isScanning = true
        DispatchQueue.global(qos: .userInitiated).async {
            let scannedIcons = MenuBarScanner.shared.scanMenuBarIcons()
            DispatchQueue.main.async {
                self.icons = scannedIcons
                self.isScanning = false
            }
        }
    }
}

struct IconRow: View {
    let icon: MenuBarIcon
    @State private var isHidden: Bool
    
    init(icon: MenuBarIcon) {
        self.icon = icon
        // 从配置中读取隐藏状态
        let config = ConfigManager.shared.getConfig()
        let hidden = icon.bundleIdentifier.map { config.hiddenApps.contains($0) } ?? false
        _isHidden = State(initialValue: hidden)
    }
    
    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 4) {
                Text(icon.name)
                    .font(.body)
                if let bundleId = icon.bundleIdentifier {
                    Text(bundleId)
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
            }
            
            Spacer()
            
            Toggle("", isOn: $isHidden)
                .labelsHidden()
                .onChange(of: isHidden) { newValue in
                    if let bundleId = icon.bundleIdentifier {
                        ConfigManager.shared.toggleIconVisibility(bundleId: bundleId)
                        
                        // 实际隐藏/显示图标
                        if newValue {
                            _ = IconManager.shared.hideIcon(bundleId: bundleId)
                        } else {
                            _ = IconManager.shared.showIcon(bundleId: bundleId)
                        }
                    }
                }
        }
        .padding(.vertical, 4)
    }
}
