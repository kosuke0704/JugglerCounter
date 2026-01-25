import SwiftUI

// MARK: - アクションバー
struct ActionBar: View {
    let onUndo: () -> Void
    let onReset: () -> Void
    let canUndo: Bool
    
    var body: some View {
        HStack(spacing: 10) {
            // 戻るボタン
            Button(action: onUndo) {
                HStack(spacing: 6) {
                    Image(systemName: "arrow.uturn.backward.circle.fill")
                        .font(.system(size: 16, weight: .bold))
                    Text("1つ戻す")
                        .font(.system(size: 12, weight: .bold))
                }
                .frame(maxWidth: .infinity)
                .padding(.vertical, 12)
                .foregroundStyle(canUndo ? .white : AppColors.textSecondary)
                .background(
                    RoundedRectangle(cornerRadius: 12)
                        .fill(canUndo ? Color.orange : AppColors.cardBackgroundLight)
                        .shadow(color: canUndo ? Color.orange.opacity(0.3) : .clear, radius: 4, x: 0, y: 2)
                )
                .overlay(
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(canUndo ? Color.orange.opacity(0.5) : AppColors.divider, lineWidth: 1.5)
                )
            }
            .disabled(!canUndo)
            .buttonStyle(PressableButtonStyle(color: .orange))

            // リセットボタン
            Button(action: onReset) {
                HStack(spacing: 6) {
                    Image(systemName: "trash.circle.fill")
                        .font(.system(size: 16, weight: .bold))
                    Text("リセット")
                        .font(.system(size: 12, weight: .bold))
                }
                .frame(maxWidth: .infinity)
                .padding(.vertical, 12)
                .foregroundStyle(.white)
                .background(
                    RoundedRectangle(cornerRadius: 12)
                        .fill(AppColors.bb)
                        .shadow(color: AppColors.bb.opacity(0.3), radius: 4, x: 0, y: 2)
                )
                .overlay(
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(AppColors.bb.opacity(0.5), lineWidth: 1.5)
                )
            }
            .buttonStyle(PressableButtonStyle(color: AppColors.bb))
        }
        .padding(12)
        .background(AppColors.cardBackground)
    }
}
