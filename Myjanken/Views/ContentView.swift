import SwiftUI

// MARK: - メインビュー
struct ContentView: View {
    @StateObject private var store = GameSessionStore()
    @State private var selectedTab = 0
    @State private var isShowingSplash = true
    
    var body: some View {
        ZStack {
            // メインコンテンツ
            TabView(selection: $selectedTab) {
                GameHistoryView(gameSessions: $store.sessions)
                    .environmentObject(store)
                    .tabItem {
                        Image(systemName: "house.fill")
                        Text("ホーム")
                    }
                    .tag(0)
                
                SettingJudgmentView()
                    .tabItem {
                        Image(systemName: "chart.bar.fill")
                        Text("設定判別")
                    }
                    .tag(1)
                
                BrowserView()
                    .tabItem {
                        Image(systemName: "globe")
                        Text("ブラウザ")
                    }
                    .tag(2)
            }
            .preferredColorScheme(.dark)
            .tint(AppColors.accent)
            
            // スプラッシュ画面
            if isShowingSplash {
                SplashScreenView()
                    .transition(.opacity)
                    .zIndex(1)
            }
        }
        .onAppear {
            // 1.5秒後にスプラッシュ画面を非表示
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                withAnimation(.easeOut(duration: 0.5)) {
                    isShowingSplash = false
                }
            }
        }
    }
}

#Preview {
    ContentView()
}
