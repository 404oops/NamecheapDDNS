//
//  NamecheapDDNSApp.swift
//  NamecheapDDNS
//
//  Created by Nathan on 15.7.23..
//

import AppKit
import SwiftUI

@main
struct NamecheapDDNSApp: App {
    @NSApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    var body: some Scene {
        WindowGroup {
            ContentView().frame(minHeight: 350)
        }
        .commands {
            SidebarCommands()
        }
    }
}

class AppDelegate: NSObject, NSApplicationDelegate {
    var aboutWindowController: NSWindowController?
    @StateObject var data = Hosts()
    var statusBarItem: NSStatusItem!
    func applicationDidFinishLaunching(_ notification: Notification) {
        let statusBar = NSStatusBar.system
        statusBarItem = statusBar.statusItem(withLength: NSStatusItem.squareLength)
        
        if let button = statusBarItem.button {
            button.image = NSImage(
                systemSymbolName: "network",
                accessibilityDescription: nil
            )
        }
        
        let menu = NSMenu()
        menu.addItem(
            NSMenuItem(
                title: "Refresh DDNS Now",
                action: #selector(RefreshDDNS),
                keyEquivalent: "r"
            )
        )
        menu.addItem(
            NSMenuItem(
                title: "Quit",
                action: #selector(quitAction),
                keyEquivalent: "q"
            )
        )
        
        statusBarItem.menu = menu
        
        let timer = Timer(
            timeInterval: 30 * 60,
            repeats: true
        ) { _ in self.RefreshDDNS()}
        let timerQueue = DispatchQueue(
            label: "Best Timer in Serbia!"
        )
        timerQueue.async {
            RunLoop.current.add(
                timer,
                forMode: .common
            )
            RunLoop.current.run()
        }
        RefreshDDNS()
    }
    
    @objc func RefreshDDNS() {
        if let button = self.statusBarItem.button {
            button.image = NSImage(systemSymbolName: "network.slash", accessibilityDescription: nil)
        }
        data.domains.forEach { host in
            URLSession.shared.dataTask(with: URL(string: "https://dynamicdns.park-your-domain.com/update?host=\(host.subdomain)&domain=\(host.domain)&password=\(host.password)")!).resume()
        }
        
        DispatchQueue.global(qos: .background).async {
            DispatchQueue.main.async {
                if let button = self.statusBarItem.button {
                    button.image = NSImage(
                        systemSymbolName: "network.badge.shield.half.filled",
                        accessibilityDescription: nil
                    )
                }
            }
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                if let button = self.statusBarItem.button {
                    button.image = NSImage(
                        systemSymbolName: "network",
                        accessibilityDescription: nil
                    )
                }
            }
        }
    }
    
    @objc func quitAction() {NSApplication.shared.terminate(self)}
}
