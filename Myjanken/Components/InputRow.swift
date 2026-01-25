import SwiftUI

// MARK: - 入力行コンポーネント
struct InputRow: View {
    let label: String
    @Binding var value: String
    let placeholder: String
    let color: Color
    let icon: String
    
    var body: some View {
        HStack(spacing: 12) {
            // アイコン
            ZStack {
                Circle()
                    .fill(color.opacity(0.2))
                    .frame(width: 36, height: 36)
                Image(systemName: icon)
                    .font(.system(size: 14, weight: .bold))
                    .foregroundStyle(color)
            }
            
            // ラベル
            Text(label)
                .font(.system(size: 14, weight: .semibold))
                .foregroundStyle(AppColors.textPrimary)
                .frame(width: 80, alignment: .leading)
            
            Spacer()
            
            // 入力フィールド
            TextField(placeholder, text: $value)
                .font(.system(size: 20, weight: .bold, design: .monospaced))
                .multilineTextAlignment(.center)
                .keyboardType(.numberPad)
                .foregroundColor(color)
                .tint(color)
                .frame(width: 100)
                .padding(.vertical, 10)
                .padding(.horizontal, 8)
                .background(
                    RoundedRectangle(cornerRadius: 10)
                        .fill(AppColors.cardBackgroundLight)
                        .overlay(
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(color.opacity(0.3), lineWidth: 1)
                        )
                )
                .contentShape(Rectangle())
        }
        .padding(12)
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(AppColors.cardBackground)
        )
    }
}
