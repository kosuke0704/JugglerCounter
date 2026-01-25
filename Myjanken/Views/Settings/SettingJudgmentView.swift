import SwiftUI

// MARK: - 設定判別画面
struct SettingJudgmentView: View {
    var body: some View {
        NavigationStack {
            ZStack {
                AppColors.background.ignoresSafeArea()
                
                VStack(spacing: 24) {
                    // アイコン
                    ZStack {
                        Circle()
                            .fill(AppColors.accent.opacity(0.1))
                            .frame(width: 120, height: 120)
                        
                        Image(systemName: "chart.bar.fill")
                            .font(.system(size: 50))
                            .foregroundStyle(AppColors.accent)
                    }
                    
                    VStack(spacing: 8) {
                        Text("設定判別機能")
                            .font(.system(size: 24, weight: .bold))
                            .foregroundStyle(AppColors.textPrimary)
                        
                        Text("Coming Soon")
                            .font(.system(size: 14, weight: .medium))
                            .foregroundStyle(AppColors.textSecondary)
                            .tracking(2)
                    }
                }
            }
            .navigationTitle("設定判別")
            .navigationBarTitleDisplayMode(.inline)
            .toolbarBackground(AppColors.cardBackground, for: .navigationBar)
            .toolbarBackground(.visible, for: .navigationBar)
        }
    }
}
