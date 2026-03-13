# NotchFix Build Commands

# Build the app in debug mode
build:
    swift build

# Build the app in release mode with optimizations
release:
    swift build -c release
    @echo "✅ Release build completed"
    @echo "📦 Binary location: .build/release/NotchFix"

# Install the app to /Applications
install: release
    @echo "📦 Installing NotchFix..."
    @mkdir -p NotchFix.app/Contents/MacOS
    @mkdir -p NotchFix.app/Contents/Resources
    @cp .build/release/NotchFix NotchFix.app/Contents/MacOS/
    @echo '<?xml version="1.0" encoding="UTF-8"?>' > NotchFix.app/Contents/Info.plist
    @echo '<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">' >> NotchFix.app/Contents/Info.plist
    @echo '<plist version="1.0">' >> NotchFix.app/Contents/Info.plist
    @echo '<dict>' >> NotchFix.app/Contents/Info.plist
    @echo '    <key>CFBundleExecutable</key>' >> NotchFix.app/Contents/Info.plist
    @echo '    <string>NotchFix</string>' >> NotchFix.app/Contents/Info.plist
    @echo '    <key>CFBundleIdentifier</key>' >> NotchFix.app/Contents/Info.plist
    @echo '    <string>com.notchfix.app</string>' >> NotchFix.app/Contents/Info.plist
    @echo '    <key>CFBundleName</key>' >> NotchFix.app/Contents/Info.plist
    @echo '    <string>NotchFix</string>' >> NotchFix.app/Contents/Info.plist
    @echo '    <key>CFBundlePackageType</key>' >> NotchFix.app/Contents/Info.plist
    @echo '    <string>APPL</string>' >> NotchFix.app/Contents/Info.plist
    @echo '    <key>CFBundleShortVersionString</key>' >> NotchFix.app/Contents/Info.plist
    @echo '    <string>1.0.0</string>' >> NotchFix.app/Contents/Info.plist
    @echo '    <key>LSMinimumSystemVersion</key>' >> NotchFix.app/Contents/Info.plist
    @echo '    <string>13.0</string>' >> NotchFix.app/Contents/Info.plist
    @echo '    <key>LSUIElement</key>' >> NotchFix.app/Contents/Info.plist
    @echo '    <true/>' >> NotchFix.app/Contents/Info.plist
    @echo '    <key>NSSupportsAutomaticTermination</key>' >> NotchFix.app/Contents/Info.plist
    @echo '    <true/>' >> NotchFix.app/Contents/Info.plist
    @echo '    <key>NSAppleEventsUsageDescription</key>' >> NotchFix.app/Contents/Info.plist
    @echo '    <string>NotchFix 需要访问辅助功能以管理菜单栏图标</string>' >> NotchFix.app/Contents/Info.plist
    @echo '</dict>' >> NotchFix.app/Contents/Info.plist
    @echo '</plist>' >> NotchFix.app/Contents/Info.plist
    @rm -rf /Applications/NotchFix.app
    @cp -R NotchFix.app /Applications/
    @echo "✅ NotchFix installed to /Applications"
    @echo "🚀 Launch from Applications folder or Spotlight"

# Clean build artifacts
clean:
    swift package clean
    rm -rf .build
    rm -rf NotchFix.app
    @echo "✅ Build artifacts cleaned"

# Run the app in debug mode
run: build
    .build/debug/NotchFix

# Show help
help:
    @echo "NotchFix Build Commands:"
    @echo "  just build    - Build in debug mode"
    @echo "  just release  - Build optimized release binary"
    @echo "  just install  - Build and install to /Applications"
    @echo "  just clean    - Remove build artifacts"
    @echo "  just run      - Build and run in debug mode"
