import SwiftUI

struct AppListView: View {
    @State private var apps: [MenuBarApp] = []
    @State private var isScanning = false
    @State private var searchText = ""
    @State private var showMenuBarOnly = true
    
    var filteredApps: [MenuBarApp] {
        var result = apps
        
        // 过滤：只显示菜单栏应用
        if showMenuBarOnly {
            result = result.filter { $0.isMenuBarApp }
        }
        
        // 搜索过滤
        if !searchText.isEmpty {
            result = result.filter { app in
                app.name.localizedCaseInsensitiveContains(searchText) ||
                app.bundleIdentifier.localizedCaseInsensitiveContains(searchText)
            }
        }
        
        return result
    }
    
    var body: some View {
        VStack(spacing: 0) {
            // 标题栏
            HStack {
                Text("应用快速启动")
                    .font(.headline)
                Spacer()
                Button(action: scanApps) {
                    Image(systemName: "arrow.clockwise")
                }
                .disabled(isScanning)
            }
            .padding()
            
            // 搜索栏
            HStack {
                Image(systemName: "magnifyingglass")
                    .foregroundColor(.secondary)
                TextField("搜索应用...", text: $searchText)
                    .textFieldStyle(.plain)
                if !searchText.isEmpty {
                    Button(action: { searchText = "" }) {
                        Image(systemName: "xmark.circle.fill")
                            .foregroundColor(.secondary)
                    }
                    .buttonStyle(.plain)
                }
            }
            .padding(8)
            .background(Color.gray.opacity(0.1))
            .cornerRadius(8)
            .padding(.horizontal)
            
            // 过滤选项
            Toggle("只显示菜单栏应用", isOn: $showMenuBarOnly)
                .padding(.horizontal)
                .padding(.vertical, 8)
            
            Divider()
            
            // 应用列表
            if filteredApps.isEmpty {
                VStack(spacing: 12) {
                    Image(systemName: isScanning ? "arrow.clockwise" : "tray")
                        .font(.system(size: 48))
                        .foregroundColor(.secondary)
                    Text(isScanning ? "扫描中..." : (searchText.isEmpty ? "点击刷新按钮扫描应用" : "未找到匹配的应用"))
                        .foregroundColor(.secondary)
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
            } else {
                ScrollView {
                    LazyVStack(spacing: 0) {
                        ForEach(filteredApps) { app in
                            AppRow(app: app)
                            Divider()
                        }
                    }
                }
            }
        }
        .frame(width: 350, height: 500)
        .onAppear {
            scanApps()
        }
    }
    
    private func scanApps() {
        isScanning = true
        DispatchQueue.global(qos: .userInitiated).async {
            let scannedApps = AppScanner.shared.scanRunningApps()
            DispatchQueue.main.async {
                self.apps = scannedApps
                self.isScanning = false
            }
        }
    }
}

struct AppRow: View {
    let app: MenuBarApp
    @State private var isHovered = false
    
    var body: some View {
        HStack(spacing: 12) {
            // 应用图标
            if let icon = app.icon {
                Image(nsImage: icon)
                    .resizable()
                    .frame(width: 32, height: 32)
            } else {
                Image(systemName: "app")
                    .font(.system(size: 32))
                    .foregroundColor(.secondary)
            }
            
            // 应用信息
            VStack(alignment: .leading, spacing: 2) {
                Text(app.name)
                    .font(.body)
                Text(app.bundleIdentifier)
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            
            Spacer()
            
            // 菜单栏标记
            if app.isMenuBarApp {
                Image(systemName: "menubar.rectangle")
                    .foregroundColor(.blue)
                    .help("菜单栏应用")
            }
        }
        .padding(.horizontal)
        .padding(.vertical, 8)
        .background(isHovered ? Color.gray.opacity(0.1) : Color.clear)
        .onHover { hovering in
            isHovered = hovering
        }
        .onTapGesture {
            app.activate()
        }
        .contextMenu {
            Button("激活") {
                app.activate()
            }
            Button("隐藏") {
                app.hide()
            }
            Divider()
            Button("退出") {
                app.quit()
            }
        }
    }
}
