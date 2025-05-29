import Foundation
import SwiftUI
import ServiceManagement

class ClockManager: ObservableObject {
    @Published var dateString = ""
    @Published var timeString = ""
    @Published var fullDateTime = ""
    @Published var isLoginItem = false
    
    private var timer: Timer?
    
    init() {
        updateTime()
        startTimer()
        checkLoginItemStatus()
    }
    
    private func updateTime() {
        let formatter = DateFormatter()
        formatter.timeZone = TimeZone(identifier: "Asia/Tokyo")
        
        // Date for menu bar (top line)
        formatter.dateFormat = "MMM dd"
        dateString = formatter.string(from: Date())
        
        // Time for menu bar (bottom line)
        formatter.dateFormat = "HH:mm"
        timeString = formatter.string(from: Date())
        
        // Full date/time for popover
        formatter.dateFormat = "EEEE, MMMM d, yyyy"
        let fullDate = formatter.string(from: Date())
        formatter.dateFormat = "HH:mm:ss"
        let fullTime = formatter.string(from: Date())
        fullDateTime = "\(fullDate)\n\(fullTime) JST"
    }
    
    private func startTimer() {
        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { [weak self] _ in
            self?.updateTime()
        }
    }
    
    func toggleLoginItem() {
        if #available(macOS 13.0, *) {
            do {
                if isLoginItem {
                    try SMAppService.mainApp.unregister()
                } else {
                    try SMAppService.mainApp.register()
                }
                isLoginItem.toggle()
            } catch {
                print("Failed to toggle login item: \(error)")
            }
        }
    }
    
    private func checkLoginItemStatus() {
        if #available(macOS 13.0, *) {
            isLoginItem = SMAppService.mainApp.status == .enabled
        }
    }
    
    deinit {
        timer?.invalidate()
    }
}
