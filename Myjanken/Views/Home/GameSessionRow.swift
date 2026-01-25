import SwiftUI

// MARK: - セッション行コンポーネント
struct GameSessionRow: View {
    let session: GameSession
    let onDelete: (() -> Void)?
    
    init(session: GameSession, onDelete: (() -> Void)? = nil) {
        self.session = session
        self.onDelete = onDelete
    }
    
    var body: some View {
        HStack(spacing: 12) {
            // 日付インジケーター
            VStack(spacing: 2) {
                Text(session.startDate, format: .dateTime.day())
                    .font(.system(size: 20, weight: .bold, design: .rounded))
                    .foregroundStyle(AppColors.textPrimary)
                Text(session.startDate, format: .dateTime.month(.abbreviated))
                    .font(.system(size: 10, weight: .medium))
                    .foregroundStyle(AppColors.textSecondary)
                    .textCase(.uppercase)
            }
            .frame(width: 44)
            
            // 区切り線
            Rectangle()
                .fill(AppColors.divider)
                .frame(width: 1, height: 50)
            
            // メイン情報
            VStack(alignment: .leading, spacing: 6) {
                // 機種名
                Text(session.machineName)
                    .font(.system(size: 11, weight: .semibold))
                    .foregroundStyle(AppColors.accent)
                    .lineLimit(1)
                
                HStack(spacing: 10) {
                    // ゲーム数
                    HStack(spacing: 3) {
                        Image(systemName: "gamecontroller.fill")
                            .font(.system(size: 10))
                            .foregroundStyle(AppColors.grape)
                        Text("\(session.totalSpins)G")
                            .font(.system(size: 12, weight: .bold, design: .monospaced))
                            .foregroundStyle(AppColors.grape)
                    }
                    
                    // 合算
                    HStack(spacing: 3) {
                        Image(systemName: "sum")
                            .font(.system(size: 10))
                            .foregroundStyle(AppColors.accent)
                        Text(session.combinedRate)
                            .font(.system(size: 12, weight: .bold, design: .monospaced))
                            .foregroundStyle(AppColors.accent)
                    }
                }
                
                // BB/RB詳細
                HStack(spacing: 12) {
                    HStack(spacing: 3) {
                        Text("BB")
                            .font(.system(size: 10, weight: .bold))
                            .foregroundStyle(AppColors.bb)
                        Text("\(session.bbTotal)")
                            .font(.system(size: 10, weight: .medium, design: .monospaced))
                            .foregroundStyle(AppColors.textSecondary)
                    }
                    
                    HStack(spacing: 3) {
                        Text("RB")
                            .font(.system(size: 10, weight: .bold))
                            .foregroundStyle(AppColors.rb)
                        Text("\(session.rbTotal)")
                            .font(.system(size: 10, weight: .medium, design: .monospaced))
                            .foregroundStyle(AppColors.textSecondary)
                    }
                }
            }
            
            Spacer()
            
            // 削除ボタン（オプション表示）
            if let onDelete = onDelete {
                Button(action: onDelete) {
                    ZStack {
                        Circle()
                            .fill(Color.red.opacity(0.15))
                            .frame(width: 28, height: 28)
                        Image(systemName: "trash.fill")
                            .font(.system(size: 11, weight: .bold))
                            .foregroundStyle(.red)
                    }
                }
                .buttonStyle(PlainButtonStyle())
            }
            
            // タップ促進アイコン
            ZStack {
                Circle()
                    .fill(AppColors.accent.opacity(0.15))
                    .frame(width: 28, height: 28)
                Image(systemName: "chevron.right")
                    .font(.system(size: 11, weight: .bold))
                    .foregroundStyle(AppColors.accent)
            }
        }
        .padding(12)
        .background(
            RoundedRectangle(cornerRadius: 14)
                .fill(AppColors.cardBackground)
                .shadow(color: Color.black.opacity(0.15), radius: 4, x: 0, y: 2)
        )
        .overlay(
            RoundedRectangle(cornerRadius: 14)
                .stroke(AppColors.divider, lineWidth: 1)
        )
    }
}
