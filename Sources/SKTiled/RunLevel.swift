//    Copyright 2020 Swift Studies
//
//    Licensed under the Apache License, Version 2.0 (the "License");
//    you may not use this file except in compliance with the License.
//    You may obtain a copy of the License at
//
//    http://www.apache.org/licenses/LICENSE-2.0
//
//    Unless required by applicable law or agreed to in writing, software
//    distributed under the License is distributed on an "AS IS" BASIS,
//    WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
//    See the License for the specific language governing permissions and
//    limitations under the License.


import Foundation
import SpriteKit
import SKTiledKit
import SwiftUI

#if os(macOS)
import Cocoa

fileprivate class WindowDelegate: NSObject, NSWindowDelegate {
    func windowWillClose(_ notification: Notification) {
        NSApplication.shared.terminate(0)
    }
}

fileprivate class SKTiledApp : NSApplication {
    override func run() {
        print("Here")
        self.finishLaunching()
        print("Here")
        super.run()
        print("Here")
    }
}

fileprivate class ApplicationDelegate: NSObject, NSApplicationDelegate {
    var _window: NSWindow
    var scene : SKScene

    init(window: NSWindow, showing scene: SKScene) {
        self._window = window
        self.scene = scene
    }
        
    func applicationDidFinishLaunching(_ notification: Notification) {
        let skView = SKView(frame: NSRect(x: 0, y: 0, width: _window.contentView!.frame.size.width, height: _window.contentView!.frame.size.height))
        skView.autoresizingMask = [.width, .height]
        
        self._window.contentView!.addSubview(skView)
        
        skView.presentScene(scene)
    }
    
}

fileprivate var windowDelegate : WindowDelegate!
fileprivate var applicationDelegate : ApplicationDelegate!

internal func start(_ scene:SKScene, from url:URL, windowSize:CGSize? = nil){
    let application = NSApplication.shared
    application.setActivationPolicy(.regular)
    
    let frame : NSRect
    if let windowSize = windowSize {
        frame = NSRect(x: 0, y: 0, width: windowSize.width, height: windowSize.height)
    } else {
        frame = NSRect(x: 0, y: 0, width: scene.size.width, height: scene.size.height)
    }
    
    let window = NSWindow(contentRect: frame,
                          styleMask: [.titled , .closable, .miniaturizable, .resizable],
                          backing: .buffered, defer: false)

    window.center()
    window.title = "sktiled - \(scene.name ?? url.path)"
    window.makeKeyAndOrderFront(window)

    windowDelegate = WindowDelegate()
    window.delegate = windowDelegate

    
    applicationDelegate = ApplicationDelegate(window: window, showing: scene)
    application.delegate = applicationDelegate
    application.activate(ignoringOtherApps: true)
    
    application.run()
}

// Want to make it Swift UI as soon as I can install and use Big Sur on a daily basis
//struct RunLevel : App {
//    var body: some Scene {
//        WindowGroup {
//            Text("Hello, world!")
//        }
//    }
//
//    static func main(){
//
//    }
//}
//
//@available(macOS 10.16, iOS 14, watchOS 7, tvOS 14, *)
//struct RunLevel_Previews: PreviewProvider {
//    static var previews: some View {
//        /*@START_MENU_TOKEN@*/Text("Hello, World!")/*@END_MENU_TOKEN@*/
//    }
//}
#else
    //Only supported on MacOS but lets add enough of a stub for a warning at least
    internal func start(_ scene:SKScene, from url:URL){
        print("Can only preview scenes on macOS")
    }
#endif
