import SwiftUI

// MARK: - ステータスヘッダー
struct StatusHeaderView: View {
    let totalSpins: Int
    let bbTotal: Int
    let rbTotal: Int
    let combinedTotal: Int
    let startSpins: Int
    let startBB: Int
    let startRB: Int
    let onSpinTap: () -> Void
    
    private func rate(total: Int, spins: Int) -> String {
        let games = max(spins, 1)
        let per = Double(games) / Double(max(total, 1))
        return String(format: "1/%.0f", per)
    }
    
    var body: some View {
        VStack(spacing: 0) {
            HStack(spacing: 0) {
                // 総ゲーム数（タップ可能）
                Button(action: onSpinTap) {
                    VStack(spacing: 2) {
                        HStack(spacing: 3) {
                            Text("GAMES")
                                .font(.system(size: 9, weight: .bold))
                                .foregroundStyle(AppColors.grape)
                                .tracking(1)
                            Image(systemName: "pencil.circle.fill")
                                .font(.system(size: 10))
                                .foregroundStyle(AppColors.grape.opacity(0.7))
                        }
                        
                        AnimatedNumberText(
                            value: "\(totalSpins)",
                            fontSize: 20,
                            color: AppColors.textPrimary
                        )
                        
                        // 常にstart値を表示
                        Text("start:\(startSpins)")
                            .font(.system(size: 8, weight: .medium, design: .monospaced))
                            .foregroundStyle(AppColors.grape.opacity(0.6))
                    }
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 8)
                    .background(AppColors.grape.opacity(0.1))
                }
                .buttonStyle(PlainButtonStyle())
                
                Divider()
                    .frame(height: 50)
                    .background(AppColors.divider)
                
                // 合算
                StatusCell(
                    label: "TOTAL",
                    value: rate(total: combinedTotal, spins: totalSpins),
                    subValue: nil,
                    startValue: nil,
                    color: AppColors.accent,
                    isLarge: true
                )
                
                Divider()
                    .frame(height: 50)
                    .background(AppColors.divider)
                
                // BB
                StatusCell(
                    label: "BB",
                    value: "\(bbTotal)",
                    subValue: nil,
                    startValue: startBB,
                    color: AppColors.bb,
                    isLarge: false
                )
                
                Divider()
                    .frame(height: 50)
                    .background(AppColors.divider)
                
                // RB
                StatusCell(
                    label: "RB",
                    value: "\(rbTotal)",
                    subValue: nil,
                    startValue: startRB,
                    color: AppColors.rb,
                    isLarge: false
                )
            }
            .background(AppColors.cardBackground)
        }
    }
}

// MARK: - ステータスセル
struct StatusCell: View {
    let label: String
    let value: String
    let subValue: String?
    let startValue: Int?
    let color: Color
    let isLarge: Bool
    
    var body: some View {
        VStack(spacing: 1) {
            Text(label)
                .font(.system(size: 9, weight: .bold))
                .foregroundStyle(color)
                .tracking(1)
            
            // アニメーション付き数字表示（全て20ptに統一）
            AnimatedNumberText(
                value: value,
                fontSize: 20,
                color: AppColors.textPrimary
            )
            
            if let sub = subValue {
                Text(sub)
                    .font(.system(size: 8, weight: .medium, design: .monospaced))
                    .foregroundStyle(AppColors.textSecondary)
            }
            
            if let start = startValue {
                Text("start:\(start)")
                    .font(.system(size: 8, weight: .medium, design: .monospaced))
                    .foregroundStyle(color.opacity(0.6))
            }
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 6)
    }
}
