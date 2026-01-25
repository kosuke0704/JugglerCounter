import SwiftUI

// MARK: - 小役セクション（チェリー・ブドウ統合）
struct KoyakuSection: View {
    let items: [CounterItem]
    let totalSpins: Int
    let increment: (CoinType) -> Void
    
    private func rate(count: Int) -> String {
        let games = max(totalSpins, 1)
        let per = Double(games) / Double(max(count, 1))
        return String(format: "1/%.1f", per)
    }
    
    var body: some View {
        VStack(spacing: 8) {
            // セクションヘッダー
            HStack {
                Rectangle()
                    .fill(
                        LinearGradient(
                            colors: [AppColors.cherry, AppColors.grape],
                            startPoint: .leading,
                            endPoint: .trailing
                        )
                    )
                    .frame(width: 3, height: 12)
                    .clipShape(RoundedRectangle(cornerRadius: 2))
                
                Text("小役")
                    .font(.system(size: 11, weight: .bold))
                    .foregroundStyle(AppColors.textPrimary)
                    .tracking(1)
                
                Spacer()
            }
            
            // カウンターグリッド（横並び）
            HStack(spacing: 8) {
                ForEach(items, id: \.id) { item in
                    KoyakuCounterCard(
                        item: item,
                        rate: rate(count: item.count),
                        onTap: { increment(item.type) }
                    )
                }
            }
        }
        .padding(12)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(AppColors.cardBackground)
        )
    }
}

// MARK: - 小役カウンターカード
struct KoyakuCounterCard: View {
    let item: CounterItem
    let rate: String
    let onTap: () -> Void
    
    var body: some View {
        Button(action: onTap) {
            VStack(spacing: 4) {
                // アイコン/ラベル
                HStack(spacing: 4) {
                    Image(systemName: item.type == .cherry ? "leaf.fill" : "circle.grid.2x2.fill")
                        .font(.system(size: 12, weight: .bold))
                        .foregroundStyle(item.type.color)
                    Text(item.type.shortName)
                        .font(.system(size: 11, weight: .bold))
                        .foregroundStyle(item.type.color)
                }
                .padding(.horizontal, 10)
                .padding(.vertical, 5)
                .background(
                    Capsule()
                        .fill(item.type.color.opacity(0.2))
                )
                
                // カウント表示（アニメーション付き）
                Text("\(item.count)")
                    .font(.system(size: 32, weight: .bold, design: .rounded))
                    .foregroundStyle(AppColors.textPrimary)
                    .contentTransition(.numericText(countsDown: false))
                    .animation(.spring(response: 0.4, dampingFraction: 0.7), value: item.count)
                
                // 確率表示
                Text(rate)
                    .font(.system(size: 11, weight: .semibold, design: .monospaced))
                    .foregroundStyle(item.type.color)
                
                // タップ促進
                Image(systemName: "hand.tap.fill")
                    .font(.system(size: 10))
                    .foregroundStyle(AppColors.textSecondary)
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, 10)
            .background(
                RoundedRectangle(cornerRadius: 14)
                    .fill(AppColors.cardBackgroundLight)
                    .shadow(color: item.type.color.opacity(0.2), radius: 6, x: 0, y: 3)
            )
            .overlay(
                RoundedRectangle(cornerRadius: 14)
                    .stroke(item.type.color.opacity(0.3), lineWidth: 1.5)
            )
        }
        .buttonStyle(PressableButtonStyle(color: item.type.color))
    }
}
