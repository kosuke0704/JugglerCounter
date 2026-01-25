import SwiftUI

// MARK: - 機種選択コンポーネント
struct MachinePickerRow: View {
    @Binding var selectedMachine: JugglerMachine
    
    var body: some View {
        HStack(spacing: 12) {
            // アイコン
            ZStack {
                Circle()
                    .fill(AppColors.accent.opacity(0.2))
                    .frame(width: 36, height: 36)
                Image(systemName: "display")
                    .font(.system(size: 14, weight: .bold))
                    .foregroundStyle(AppColors.accent)
            }
            
            // ラベル
            Text("機種")
                .font(.system(size: 14, weight: .semibold))
                .foregroundStyle(AppColors.textPrimary)
                .frame(width: 80, alignment: .leading)
            
            Spacer()
            
            // プルダウン（横幅拡張）
            Menu {
                ForEach(JugglerMachine.allCases) { machine in
                    Button(action: {
                        selectedMachine = machine
                    }) {
                        HStack {
                            Text(machine.rawValue)
                            if selectedMachine == machine {
                                Image(systemName: "checkmark")
                            }
                        }
                    }
                }
            } label: {
                HStack(spacing: 6) {
                    Text(selectedMachine.rawValue)
                        .font(.system(size: 13, weight: .bold))
                        .foregroundStyle(AppColors.accent)
                        .lineLimit(1)
                        .minimumScaleFactor(0.8)
                        .frame(maxWidth: .infinity, alignment: .leading)
                    
                    Image(systemName: "chevron.down")
                        .font(.system(size: 10, weight: .bold))
                        .foregroundStyle(AppColors.accent.opacity(0.7))
                }
                .padding(.horizontal, 14)
                .padding(.vertical, 11)
                .frame(minWidth: 180)
                .background(
                    RoundedRectangle(cornerRadius: 10)
                        .fill(AppColors.cardBackgroundLight)
                        .overlay(
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(AppColors.accent.opacity(0.3), lineWidth: 1)
                        )
                )
            }
        }
        .padding(12)
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(AppColors.cardBackground)
        )
    }
}
