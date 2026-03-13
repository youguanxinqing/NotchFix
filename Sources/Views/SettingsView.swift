import SwiftUI

struct SettingsView: View {
    var body: some View {
        VStack(spacing: 20) {
            Image(systemName: "gearshape.2")
                .font(.system(size: 48))
                .foregroundColor(.accentColor)
            
            Text("NotchFix 设置")
                .font(.title)
            
            Text("菜单栏图标管理工具")
                .foregroundColor(.secondary)
            
            Divider()
            
            VStack(alignment: .leading, spacing: 12) {
                Label("点击菜单栏图标查看所有图标", systemImage: "hand.tap")
                Label("切换开关隐藏/显示图标", systemImage: "eye.slash")
                Label("需要辅助功能权限", systemImage: "lock.shield")
            }
            .font(.body)
            
            Spacer()
            
            Button("打开系统偏好设置") {
                openAccessibilitySettings()
            }
            .buttonStyle(.borderedProminent)
        }
        .padding(30)
        .frame(width: 400, height: 350)
    }
    
    private func openAccessibilitySettings() {
        let url = URL(string: "x-apple.systempreferences:com.apple.preference.security?Privacy_Accessibility")!
        NSWorkspace.shared.open(url)
    }
}
