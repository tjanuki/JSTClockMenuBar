import SwiftUI

struct ClockView: View {
    @ObservedObject var clockManager: ClockManager
    
    var body: some View {
        VStack(spacing: -2) {
            Text(clockManager.dateString)
                .font(.system(size: 9, weight: .regular))
                .foregroundColor(.primary)
            
            Text(clockManager.timeString)
                .font(.system(size: 11, weight: .medium))
                .foregroundColor(.primary)
        }
        .frame(width: 50, height: 30)
    }
}
