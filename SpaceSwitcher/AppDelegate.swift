//
//  AppDelegate.swift
//  SpaceSwitcher
//
//  Created by wayZ on 2020/5/25.
//  Copyright © 2020 wayZ. All rights reserved.
//

import Cocoa

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {
    // 申明标题栏图标对象
    var statusBarItem: NSStatusItem!



    func applicationDidFinishLaunching(_ aNotification: Notification) {
        // Insert code here to initialize your application
        // 初始化标题栏图标
        let statusBar = NSStatusBar.system
        statusBarItem = statusBar.statusItem(
            withLength: NSStatusItem.squareLength)
//        statusBarItem.button?.title = "🌯"
        statusBarItem.button?.title = "◻️"
        let statusBarMenu = NSMenu(title: "SpaceSwitcher")
        statusBarItem.menu = statusBarMenu
        
        // 添加选项
        statusBarMenu.addItem(
            withTitle: "Quit",
            action: #selector(AppDelegate.quitApplication),
            keyEquivalent: "")
    }
    
    // 选项使用的函数
    @objc func quitApplication() {
        // 退出程序
        NSApplication.shared.terminate(self)
    }

    func applicationWillTerminate(_ aNotification: Notification) {
        // Insert code here to tear down your application
    }


}

