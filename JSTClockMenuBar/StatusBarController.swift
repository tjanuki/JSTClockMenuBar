import Cocoa
import SwiftUI

class StatusBarController: NSObject {
    private var statusItem: NSStatusItem?
    private var popover: NSPopover?
    private var eventMonitor: EventMonitor?
    private var clockView: ClockView?
    
    @ObservedObject private var clockManager = ClockManager()
    
    override init() {
        super.init()
        setupStatusItem()
        setupPopover()
        setupEventMonitor()
    }
    
    private func setupStatusItem() {
        statusItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.variableLength)
        
        if let button = statusItem?.button {
            // Create the clock view
            clockView = ClockView(clockManager: clockManager)
            let hostingView = NSHostingView(rootView: clockView)
            hostingView.frame = NSRect(x: 0, y: 0, width: 50, height: 30)
            
            // Add to button
            button.addSubview(hostingView)
            button.frame = hostingView.frame
            
            // Set action for click
            button.action = #selector(togglePopover)
            button.target = self
        }
    }
    
    private func setupPopover() {
        popover = NSPopover()
        popover?.contentSize = NSSize(width: 250, height: 200)
        popover?.behavior = .transient
        popover?.contentViewController = NSHostingController(
            rootView: PopoverView(clockManager: clockManager)
        )
    }
    
    private func setupEventMonitor() {
        eventMonitor = EventMonitor(mask: [.leftMouseDown, .rightMouseDown]) { [weak self] event in
            if let self = self, self.popover?.isShown == true {
                self.closePopover()
            }
        }
    }
    
    @objc private func togglePopover() {
        if let button = statusItem?.button {
            if popover?.isShown == true {
                closePopover()
            } else {
                showPopover(button)
            }
        }
    }
    
    private func showPopover(_ sender: NSStatusBarButton) {
        popover?.show(relativeTo: sender.bounds, of: sender, preferredEdge: .minY)
        eventMonitor?.start()
    }
    
    private func closePopover() {
        popover?.performClose(nil)
        eventMonitor?.stop()
    }
}
