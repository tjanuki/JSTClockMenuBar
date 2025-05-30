import SwiftUI

struct ClockView: View {
    @ObservedObject var clockManager: ClockManager
    
    var body: some View {
        VStack(spacing: -3) {
            Text(clockManager.dateString)
                .font(.system(size: 10, weight: .regular))
                .foregroundColor(.primary)
            
            Text(clockManager.timeString)
                .font(.system(size: 10, weight: .regular))
                .foregroundColor(.primary)
        }
        .frame(width: 50, height: 30)
        .offset(y: -4)
    }
}
