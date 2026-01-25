import SwiftUI

// MARK: - スプラッシュ画面
struct SplashScreenView: View {
    @State private var isAnimating = false
    
    var body: some View {
        ZStack {
            // 背景
            AppColors.background
                .ignoresSafeArea()
            
            VStack(spacing: 20) {
                // ロゴアニメーション
                VStack(spacing: 8) {
                    Text("JUGGLER")
                        .font(.system(size: 48, weight: .black, design: .rounded))
                        .foregroundStyle(
                            LinearGradient(
                                colors: [AppColors.accent, AppColors.accent.opacity(0.7)],
                                startPoint: .leading,
                                endPoint: .trailing
                            )
                        )
                        .scaleEffect(isAnimating ? 1.0 : 0.8)
                        .opacity(isAnimating ? 1.0 : 0.0)
                    
                    Text("COUNTER")
                        .font(.system(size: 16, weight: .bold, design: .rounded))
                        .foregroundStyle(AppColors.textSecondary)
                        .tracking(6)
                        .opacity(isAnimating ? 1.0 : 0.0)
                }
                
                // インジケーター
                ProgressView()
                    .progressViewStyle(.circular)
                    .tint(AppColors.accent)
                    .scaleEffect(1.2)
                    .opacity(isAnimating ? 1.0 : 0.0)
            }
        }
        .onAppear {
            withAnimation(.easeOut(duration: 0.8)) {
                isAnimating = true
            }
        }
    }
}
