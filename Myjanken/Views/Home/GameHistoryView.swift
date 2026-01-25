import SwiftUI

// MARK: - ゲーム履歴画面
struct GameHistoryView: View {
    @Binding var gameSessions: [GameSession]
    @EnvironmentObject var store: GameSessionStore
    @State private var navigationPath = NavigationPath()
    @State private var sessionToDelete: GameSession?
    @State private var showDeleteAlert = false
    
    var body: some View {
        NavigationStack(path: $navigationPath) {
            ZStack {
                AppColors.background.ignoresSafeArea()
                
                VStack(spacing: 0) {
                    // ヘッダーカード
                    VStack(spacing: 12) {
                        // ロゴ/タイトルエリア
                        HStack {
                            VStack(alignment: .leading, spacing: 2) {
                                Text("JUGGLER")
                                    .font(.system(size: 24, weight: .black, design: .rounded))
                                    .foregroundStyle(
                                        LinearGradient(
                                            colors: [AppColors.accent, AppColors.accent.opacity(0.7)],
                                            startPoint: .leading,
                                            endPoint: .trailing
                                        )
                                    )
                                Text("COUNTER")
                                    .font(.system(size: 10, weight: .bold, design: .rounded))
                                    .foregroundStyle(AppColors.textSecondary)
                                    .tracking(3)
                            }
                            Spacer()
                            
                            // 統計サマリー
                            if !gameSessions.isEmpty {
                                VStack(alignment: .trailing, spacing: 2) {
                                    Text("総セッション")
                                        .font(.caption2)
                                        .foregroundStyle(AppColors.textSecondary)
                                    Text("\(gameSessions.count)")
                                        .font(.system(size: 20, weight: .bold, design: .monospaced))
                                        .foregroundStyle(AppColors.accent)
                                }
                            }
                        }
                        
                        // 新規ゲームボタン
                        Button {
                            navigationPath.append("initialInput")
                        } label: {
                            HStack(spacing: 12) {
                                ZStack {
                                    Circle()
                                        .fill(AppColors.accent)
                                        .frame(width: 40, height: 40)
                                        .shadow(color: AppColors.accent.opacity(0.4), radius: 6, x: 0, y: 3)
                                    Image(systemName: "play.fill")
                                        .font(.system(size: 16, weight: .bold))
                                        .foregroundStyle(.white)
                                }
                                
                                VStack(alignment: .leading, spacing: 2) {
                                    Text("新規ゲーム開始")
                                        .font(.system(size: 15, weight: .bold))
                                        .foregroundStyle(AppColors.textPrimary)
                                    Text("タップしてカウンターを開始")
                                        .font(.system(size: 11, weight: .medium))
                                        .foregroundStyle(AppColors.textSecondary)
                                }
                                
                                Spacer()
                                
                                Image(systemName: "chevron.right.circle.fill")
                                    .font(.system(size: 20))
                                    .foregroundStyle(AppColors.accent)
                            }
                            .padding(14)
                            .background(
                                RoundedRectangle(cornerRadius: 14)
                                    .fill(AppColors.cardBackgroundLight)
                                    .shadow(color: AppColors.accent.opacity(0.2), radius: 8, x: 0, y: 4)
                            )
                            .overlay(
                                RoundedRectangle(cornerRadius: 14)
                                    .stroke(AppColors.accent.opacity(0.4), lineWidth: 1.5)
                            )
                        }
                        .buttonStyle(PressableButtonStyle(color: AppColors.accent))
                    }
                    .padding(16)
                    .background(
                        AppColors.cardBackground
                            .clipShape(
                                .rect(bottomLeadingRadius: 20, bottomTrailingRadius: 20)
                            )
                    )
                    
                    // 履歴リスト
                    if gameSessions.isEmpty {
                        VStack(spacing: 12) {
                            Spacer()
                            
                            ZStack {
                                Circle()
                                    .fill(AppColors.cardBackground)
                                    .frame(width: 80, height: 80)
                                Image(systemName: "tray")
                                    .font(.system(size: 32))
                                    .foregroundStyle(AppColors.textSecondary)
                            }
                            
                            VStack(spacing: 6) {
                                Text("履歴がありません")
                                    .font(.subheadline)
                                    .foregroundStyle(AppColors.textPrimary)
                                Text("上のボタンから\n新規ゲームを開始してください")
                                    .font(.caption)
                                    .foregroundStyle(AppColors.textSecondary)
                                    .multilineTextAlignment(.center)
                            }
                            
                            Spacer()
                        }
                    } else {
                        ScrollView {
                            LazyVStack(spacing: 10) {
                                ForEach(gameSessions.sorted(by: { $0.endDate > $1.endDate }), id: \.id) { session in
                                    Button {
                                        navigationPath.append(session.id)
                                    } label: {
                                        GameSessionRow(
                                            session: session,
                                            onDelete: {
                                                sessionToDelete = session
                                                showDeleteAlert = true
                                            }
                                        )
                                    }
                                    .buttonStyle(ScaleButtonStyle())
                                }
                            }
                            .padding(16)
                        }
                    }
                }
            }
            .navigationBarHidden(true)
            .alert("セッションを削除", isPresented: $showDeleteAlert) {
                Button("キャンセル", role: .cancel) { }
                Button("削除", role: .destructive) {
                    if let session = sessionToDelete {
                        store.delete(session)
                        sessionToDelete = nil
                    }
                }
            } message: {
                Text("このゲームセッションを削除してもよろしいですか？")
            }
            .navigationDestination(for: String.self) { destination in
                if destination == "initialInput" {
                    InitialInputView(gameSessions: $gameSessions, navigationPath: $navigationPath)
                }
            }
            .navigationDestination(for: UUID.self) { sessionId in
                if let session = gameSessions.first(where: { $0.id == sessionId }) {
                    CounterView(gameSessions: $gameSessions, existingSession: session, navigationPath: $navigationPath)
                        .environmentObject(store)
                }
            }
            .navigationDestination(for: InitialInputView.InitialGameData.self) { data in
                CounterView(gameSessions: $gameSessions, initialData: data, navigationPath: $navigationPath)
                    .environmentObject(store)
            }
        }
    }
}
