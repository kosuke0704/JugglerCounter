import SwiftUI

// MARK: - ゲーム数入力シート
struct SpinInputSheet: View {
    @Binding var totalSpins: Int
    @Environment(\.dismiss) private var dismiss
    @State private var inputValue: String = ""
    
    var body: some View {
        VStack(spacing: 16) {
            // ハンドル
            RoundedRectangle(cornerRadius: 3)
                .fill(AppColors.textSecondary)
                .frame(width: 36, height: 4)
                .padding(.top, 8)
            
            Text("総ゲーム数を入力")
                .font(.system(size: 16, weight: .bold))
                .foregroundStyle(AppColors.textPrimary)
            
            TextField("0", text: $inputValue)
                .font(.system(size: 28, weight: .bold, design: .monospaced))
                .multilineTextAlignment(.center)
                .keyboardType(.numberPad)
                .foregroundColor(AppColors.grape)
                .tint(AppColors.grape)
                .padding(.vertical, 12)
                .padding(.horizontal)
                .background(
                    RoundedRectangle(cornerRadius: 10)
                        .fill(AppColors.cardBackgroundLight)
                )
                .padding(.horizontal, 40)
                .contentShape(Rectangle())
            
            // クイック入力ボタン
            HStack(spacing: 10) {
                QuickAddButton(label: "+100", action: { addSpins(100) })
                QuickAddButton(label: "+500", action: { addSpins(500) })
                QuickAddButton(label: "+1000", action: { addSpins(1000) })
            }
            
            // 確定ボタン
            Button {
                if let value = Int(inputValue) {
                    totalSpins = value
                }
                dismiss()
            } label: {
                HStack(spacing: 6) {
                    Image(systemName: "checkmark.circle.fill")
                        .font(.system(size: 16, weight: .bold))
                    Text("確定")
                        .font(.system(size: 14, weight: .bold))
                }
                .frame(maxWidth: .infinity)
                .padding(.vertical, 12)
                .foregroundStyle(.white)
                .background(
                    RoundedRectangle(cornerRadius: 12)
                        .fill(AppColors.accent)
                        .shadow(color: AppColors.accent.opacity(0.3), radius: 4, x: 0, y: 2)
                )
            }
            .buttonStyle(PressableButtonStyle(color: AppColors.accent))
            .padding(.horizontal, 20)
            
            Spacer()
        }
        .background(AppColors.background)
        .onAppear {
            inputValue = "\(totalSpins)"
        }
    }
    
    private func addSpins(_ amount: Int) {
        let current = Int(inputValue) ?? 0
        inputValue = "\(current + amount)"
    }
}

// MARK: - クイック追加ボタン
struct QuickAddButton: View {
    let label: String
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Text(label)
                .font(.system(size: 13, weight: .bold))
                .foregroundStyle(.white)
                .padding(.horizontal, 18)
                .padding(.vertical, 8)
                .background(
                    RoundedRectangle(cornerRadius: 10)
                        .fill(AppColors.accent.opacity(0.7))
                        .shadow(color: AppColors.accent.opacity(0.3), radius: 3, x: 0, y: 2)
                )
        }
        .buttonStyle(PressableButtonStyle(color: AppColors.accent))
    }
}
