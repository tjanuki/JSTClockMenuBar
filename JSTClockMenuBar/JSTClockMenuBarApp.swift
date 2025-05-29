//
//  JSTClockMenuBarApp.swift
//  JSTClockMenuBar
//

import SwiftUI

@main
struct JSTClockMenuBarApp: App {
    @NSApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    
    var body: some Scene {
        Settings {
            EmptyView()
        }
    }
}
