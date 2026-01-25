import SwiftUI

// MARK: - アニメーション付き数字表示
struct AnimatedNumberText: View {
    let value: String
    let fontSize: CGFloat
    let color: Color
    
    var body: some View {
        Text(value)
            .font(.system(size: fontSize, weight: .bold, design: .monospaced))
            .foregroundStyle(color)
            .contentTransition(.numericText(countsDown: false))
            .animation(.spring(response: 0.4, dampingFraction: 0.8), value: value)
    }
}
