//
//  ViewController.swift
//  SpaceSwitcher
//
//  Created by wayZ on 2020/5/25.
//  Copyright © 2020 wayZ. All rights reserved.
//

import Cocoa

class ViewController: NSViewController {
    lazy var window: NSWindow = self.view.window!
    override func viewDidLoad() {
        super.viewDidLoad()
        NSApp.setActivationPolicy(.prohibited)
        
        // 鼠标移动监视器
        NSEvent.addGlobalMonitorForEvents(matching: .mouseMoved, handler:{(event:NSEvent) in
            self.mouseMoveHandler(event:event)
        })
        NSEvent.addLocalMonitorForEvents(matching: .mouseMoved, handler:{(event:NSEvent) in
            print("在前台")
            self.mouseMoveHandler(event: event)
            return event
        })
        // 鼠标滑轮滚动监视器
        NSEvent.addGlobalMonitorForEvents(matching: .scrollWheel, handler:{(event:NSEvent) in
            self.scrollHandler(event: event)
        })
        NSEvent.addLocalMonitorForEvents(matching: .scrollWheel, handler: {(event:NSEvent) in
            print("在前台")
            self.scrollHandler(event: event)
            return event
        })
        // 鼠标滚轮按下监视器
        NSEvent.addGlobalMonitorForEvents(matching: .otherMouseDown, handler:{(event:NSEvent) in
            self.middleButtonHandler(event: event)
        })
        NSEvent.addLocalMonitorForEvents(matching: .otherMouseDown, handler: {(event:NSEvent) in
            print("在前台")
            self.middleButtonHandler(event: event)
            return event
        })
    }
    
    func mouseMoveHandler(event:NSEvent){
        let x = NSEvent.mouseLocation.x
        let y = NSEvent.mouseLocation.y
        print("x坐标是：\(x)，y坐标是：\(y)")
        print("当前屏幕高度是：\(NSScreen.main?.frame.height ?? 0)")
        print("当前屏幕左下角原点值是：\(NSScreen.main?.frame.origin ?? CGPoint(x: 0,y: 0))")
        print("---------------------------------------")
    }
    
    func scrollHandler(event:NSEvent) {
        if IsInAreaHeight(){
            if event.scrollingDeltaY>0{
                print("向上滚了")
                // 触发快捷键
                // 0x12是数字键1
                CtrlWithKey(keyCode: 0x12)
            }
            if event.scrollingDeltaY<0{
                print("向下滚了")
                // 0x13是数字键2
                CtrlWithKey(keyCode: 0x13)
            }
        }
    }
    
    func middleButtonHandler(event:NSEvent)  {
        let mouseButton = NSEvent.pressedMouseButtons
        if IsInAreaHeight(){
             // 我的鼠标滚轮按下对应的值是4，不确定是否所有的鼠标滚轮按下都是4
            if mouseButton == 4{
                print("按下了鼠标中键")
                // 0x14是数字键3
                CtrlWithKey(keyCode: 0x14)
            }
        }
    }

    override var representedObject: Any? {
        didSet {
        // Update the view, if already loaded.
        }
    }
}

// 获得鼠标所在的那个屏幕
func getScreenWithMouse() -> NSScreen? {
  let mouseLocation = NSEvent.mouseLocation
  let screens = NSScreen.screens
  let screenWithMouse = (screens.first { NSMouseInRect(mouseLocation, $0.frame, false) })

  return screenWithMouse
}

func IsInAreaHeight() -> Bool {
    // 获得鼠标所在的那个屏幕
    let screen = getScreenWithMouse()
    // 获取屏幕高度
    let height = screen?.frame.height
    // 获取左下角屏幕坐标起点
    // 坐标起点是以左下角为原点
    let originY = screen?.frame.origin.y
    // 获取Y坐标点
    let y = NSEvent.mouseLocation.y
    // 获得菜单栏的高度
    let appleMenuBarHeight = (screen?.frame.height)! - (screen?.visibleFrame.height)! - ((screen?.visibleFrame.origin.y)! - (screen?.frame.origin.y)!) - 1
    // 判断鼠标y坐标点是否在检测高度内
    if (height! - (y-originY!)) < appleMenuBarHeight{
        return true
    }
    return false
}





// 这里有一张完整的按键表：https://i.stack.imgur.com/LD8pT.png
// 来源：https://stackoverflow.com/questions/3202629/where-can-i-find-a-list-of-mac-virtual-key-codes/16125341
func CtrlWithKey(keyCode:UInt) {
    // 0x3b is Ctrl key
    let controlKeyDownEvent = CGEvent(keyboardEventSource: nil, virtualKey: CGKeyCode(0x3B), keyDown: true)
    controlKeyDownEvent?.flags = CGEventFlags.maskControl
    controlKeyDownEvent?.post(tap: CGEventTapLocation.cghidEventTap)

    let letterKeyDownEvent = CGEvent(keyboardEventSource: nil, virtualKey: CGKeyCode(keyCode), keyDown: true)
    letterKeyDownEvent?.flags = CGEventFlags.maskControl
    letterKeyDownEvent?.post(tap: CGEventTapLocation.cghidEventTap)

    let letterKeyUpEvent = CGEvent(keyboardEventSource: nil, virtualKey: CGKeyCode(keyCode), keyDown: false)
    letterKeyUpEvent?.flags = CGEventFlags.maskControl
    letterKeyUpEvent?.post(tap: CGEventTapLocation.cghidEventTap)

    let controlKeyUpEvent = CGEvent(keyboardEventSource: nil, virtualKey: CGKeyCode(0x3B), keyDown: false)
    controlKeyUpEvent?.flags = CGEventFlags.maskControl
    controlKeyUpEvent?.post(tap: CGEventTapLocation.cghidEventTap)
}

// 通过脚本来调用快捷键，但是权限问题搞不定
func callShortcutByAppleScript(){
    let script = NSAppleScript(source: "tell application \"System Events\" to key code 124 using control down")!
    var errorDict : NSDictionary?
    script.executeAndReturnError(&errorDict)
    if errorDict != nil { print(errorDict!) }
}
