import SwiftUI

// MARK: - メモセクション
struct MemoSection: View {
    @Binding var memo: String
    
    var body: some View {
        VStack(spacing: 8) {
            // セクションヘッダー
            HStack {
                Rectangle()
                    .fill(AppColors.accent)
                    .frame(width: 3, height: 12)
                    .clipShape(RoundedRectangle(cornerRadius: 2))
                
                Text("メモ")
                    .font(.system(size: 11, weight: .bold))
                    .foregroundStyle(AppColors.textPrimary)
                    .tracking(1)
                
                Spacer()
            }
            
            // メモ入力欄
            ZStack(alignment: .topLeading) {
                // プレースホルダー
                if memo.isEmpty {
                    Text("店舗名や台番号が記録できます")
                        .font(.system(size: 13))
                        .foregroundStyle(AppColors.textSecondary)
                        .padding(.horizontal, 12)
                        .padding(.vertical, 10)
                }
                
                // テキストエディタ
                TextEditor(text: $memo)
                    .font(.system(size: 13))
                    .foregroundStyle(AppColors.textPrimary)
                    .scrollContentBackground(.hidden)
                    .padding(.horizontal, 8)
                    .padding(.vertical, 6)
            }
            .frame(minHeight: 60, maxHeight: 80)
            .background(
                RoundedRectangle(cornerRadius: 10)
                    .fill(AppColors.cardBackgroundLight)
                    .overlay(
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(AppColors.accent.opacity(0.3), lineWidth: 1)
                    )
            )
        }
        .padding(12)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(AppColors.cardBackground)
        )
    }
}
