import SwiftUI

// MARK: - ボーナスセクション
struct BonusSection: View {
    let title: String
    let color: Color
    let items: [CounterItem]
    let totalSpins: Int
    let effectiveSpins: Int  // 初期ゲーム数を引いた実効ゲーム数
    let increment: (CoinType) -> Void
    
    // 不明は全ゲーム数で計算、単独・重複は実効ゲーム数で計算
    private func rate(for item: CounterItem) -> String {
        let isUnknown = item.type == .bigUnknown || item.type == .regUnknown
        let spins = isUnknown ? totalSpins : effectiveSpins
        let games = max(spins, 1)
        let per = Double(games) / Double(max(item.count, 1))
        return String(format: "1/%.1f", per)
    }
    
    var body: some View {
        VStack(spacing: 8) {
            // セクションヘッダー
            HStack {
                Rectangle()
                    .fill(color)
                    .frame(width: 3, height: 12)
                    .clipShape(RoundedRectangle(cornerRadius: 2))
                
                Text(title)
                    .font(.system(size: 11, weight: .bold))
                    .foregroundStyle(color)
                    .tracking(1)
                
                Spacer()
            }
            
            // カウンターグリッド
            HStack(spacing: 6) {
                ForEach(items, id: \.id) { item in
                    CounterCard(
                        item: item,
                        rate: rate(for: item),
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

// MARK: - カウンターカード
struct CounterCard: View {
    let item: CounterItem
    let rate: String
    let onTap: () -> Void
    @State private var isPressed = false
    
    var body: some View {
        Button(action: onTap) {
            VStack(spacing: 4) {
                // ラベル（上部）
                Text(item.type.shortName)
                    .font(.system(size: 10, weight: .bold))
                    .foregroundStyle(.white)
                    .padding(.horizontal, 8)
                    .padding(.vertical, 4)
                    .frame(maxWidth: .infinity)
                    .background(item.type.color)
                    .clipShape(RoundedRectangle(cornerRadius: 6))
                
                // カウント表示（アニメーション付き）
                Text("\(item.count)")
                    .font(.system(size: 26, weight: .bold, design: .rounded))
                    .foregroundStyle(AppColors.textPrimary)
                    .contentTransition(.numericText(countsDown: false))
                    .animation(.spring(response: 0.4, dampingFraction: 0.7), value: item.count)
                
                // 確率表示
                Text(rate)
                    .font(.system(size: 9, weight: .medium, design: .monospaced))
                    .foregroundStyle(AppColors.textSecondary)
                
                // タップ促進インジケーター（指アイコンに統一）
                Image(systemName: "hand.tap.fill")
                    .font(.system(size: 10))
                    .foregroundStyle(item.type.color.opacity(0.7))
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, 8)
            .padding(.horizontal, 4)
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(AppColors.cardBackgroundLight)
                    .shadow(color: item.type.color.opacity(0.2), radius: 4, x: 0, y: 2)
            )
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(item.type.color.opacity(0.4), lineWidth: 1.5)
            )
        }
        .buttonStyle(PressableButtonStyle(color: item.type.color))
    }
}
