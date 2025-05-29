import SwiftUI

struct PopoverView: View {
    @ObservedObject var clockManager: ClockManager
    
    var body: some View {
        VStack(spacing: 20) {
            // Header
            Text("Japan Standard Time")
                .font(.headline)
            
            // Current time display
            Text(clockManager.fullDateTime)
                .font(.system(.title3, design: .monospaced))
                .multilineTextAlignment(.center)
            
            Divider()
            
            // Options
            Toggle("Start at Login", isOn: $clockManager.isLoginItem)
                .onChange(of: clockManager.isLoginItem) { _ in
                    clockManager.toggleLoginItem()
                }
            
            Divider()
            
            // Quit button
            Button("Quit JST Clock") {
                NSApplication.shared.terminate(nil)
            }
            .buttonStyle(.borderedProminent)
        }
        .padding()
        .frame(width: 250)
    }
}
