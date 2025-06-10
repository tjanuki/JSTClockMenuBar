import Cocoa
import SwiftUI
import Combine

class StatusBarController: NSObject {
    private var statusItem: NSStatusItem?
    private var popover: NSPopover?
    private var eventMonitor: EventMonitor?
    private var cancellables = Set<AnyCancellable>()
    
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
            // Set action for click
            button.action = #selector(togglePopover)
            button.target = self
            
            // Update the title when clock updates
            clockManager.$dateString.combineLatest(clockManager.$timeString)
                .sink { [weak self] date, time in
                    self?.updateStatusItemTitle(date: date, time: time)
                }
                .store(in: &cancellables)
        }
    }
    
    private func updateStatusItemTitle(date: String, time: String) {
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.alignment = .center
        paragraphStyle.lineSpacing = -4
        paragraphStyle.paragraphSpacingBefore = 0
        paragraphStyle.paragraphSpacing = 0
        paragraphStyle.maximumLineHeight = 12
        
        let dateAttributes: [NSAttributedString.Key: Any] = [
            .font: NSFont.monospacedDigitSystemFont(ofSize: 11, weight: .regular),
            .paragraphStyle: paragraphStyle,
            .baselineOffset: -25
        ]
        
        let timeAttributes: [NSAttributedString.Key: Any] = [
            .font: NSFont.monospacedDigitSystemFont(ofSize: 12, weight: .regular),
            .paragraphStyle: paragraphStyle,
            .baselineOffset: -6
        ]
        
        let attributedString = NSMutableAttributedString()
        attributedString.append(NSAttributedString(string: date + "\n", attributes: dateAttributes))
        attributedString.append(NSAttributedString(string: time, attributes: timeAttributes))
        
        statusItem?.button?.attributedTitle = attributedString
    }
    
    private func setupPopover() {
        popover = NSPopover()
        popover?.contentSize = NSSize(width: 250, height: 50)
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
