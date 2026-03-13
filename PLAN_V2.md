# NotchFix 方案 V2 - 菜单栏快速启动器

## 问题分析

原方案使用 Accessibility API 尝试隐藏菜单栏图标，但遇到以下问题：
1. 权限要求严格，用户体验差
2. `kAXHiddenAttribute` 大部分应用不支持
3. 技术实现复杂且不稳定

## 新方案：菜单栏快速启动器

### 核心功能

1. **应用扫描**
   - 扫描所有正在运行的应用
   - 识别有菜单栏图标的应用
   - 获取应用图标、名称、Bundle ID

2. **快速访问面板**
   - 点击 NotchFix 图标显示应用列表
   - 显示应用图标和名称
   - 支持搜索和过滤

3. **应用操作**
   - 点击应用图标 → 激活应用（bring to front）
   - 右键应用图标 → 显示快捷菜单（退出、隐藏等）
   - 收藏常用应用

4. **用户体验**
   - 无需辅助功能权限
   - 即装即用
   - 轻量快速

### 技术实现

#### 1. 应用扫描
使用 `NSWorkspace` API（无需特殊权限）：
```swift
NSWorkspace.shared.runningApplications
```

#### 2. 菜单栏图标检测
通过以下特征判断应用是否有菜单栏图标：
- `activationPolicy == .accessory` (纯菜单栏应用)
- 或者检查应用的 Info.plist 中的 `LSUIElement`
- 或者用户手动标记

#### 3. 应用激活
```swift
app.activate(options: .activateIgnoringOtherApps)
```

#### 4. 应用图标获取
```swift
app.icon // NSImage
```

### 优势

✅ 无需辅助功能权限
✅ 技术实现简单可靠
✅ 用户体验流畅
✅ 解决刘海屏图标被隐藏的问题
✅ 额外提供快速启动功能

### 局限

⚠️ 不能真正"隐藏"原图标
⚠️ 用户需要自己通过应用设置隐藏图标（如果应用支持）

### 下一步

1. 移除 Accessibility API 相关代码
2. 实现基于 NSWorkspace 的应用扫描
3. 重新设计 UI，展示应用列表
4. 添加应用激活和快捷操作
5. 添加搜索和收藏功能
