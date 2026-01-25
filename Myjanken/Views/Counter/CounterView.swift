import SwiftUI

// MARK: - カウンター画面
struct CounterView: View {
    @Binding var gameSessions: [GameSession]
    @Binding var navigationPath: NavigationPath
    @EnvironmentObject var store: GameSessionStore
    
    var existingSession: GameSession?
    var initialData: InitialInputView.InitialGameData?
    
    @State private var items: [CounterItem] = []
    @State private var totalSpins: Int = 0
    @State private var logs: [ActionLog] = []
    @State private var sessionId = UUID()
    @State private var sessionStartDate = Date()
    @State private var showResetAlert = false
    @State private var showSpinInput = false
    
    // 初期入力データを保持
    @State private var startSpins: Int = 0
    @State private var startBB: Int = 0
    @State private var startRB: Int = 0
    
    // メモ
    @State private var memo: String = ""
    
    // 機種名
    @State private var machineName: String = "アイムジャグラーEX"
    
    // フラッシュエフェクト用
    @State private var flashColor: Color = .clear
    @State private var showFlash = false
    
    init(gameSessions: Binding<[GameSession]>, existingSession: GameSession? = nil, initialData: InitialInputView.InitialGameData? = nil, navigationPath: Binding<NavigationPath>) {
        self._gameSessions = gameSessions
        self.existingSession = existingSession
        self.initialData = initialData
        self._navigationPath = navigationPath
    }
    
    // 計算プロパティ
    private var bbTotal: Int {
        let single = items.first(where: { $0.type == .bigSingle })?.count ?? 0
        let overlap = items.first(where: { $0.type == .bigOverlap })?.count ?? 0
        let unknown = items.first(where: { $0.type == .bigUnknown })?.count ?? 0
        return single + overlap + unknown
    }
    
    private var rbTotal: Int {
        let single = items.first(where: { $0.type == .regSingle })?.count ?? 0
        let overlap = items.first(where: { $0.type == .regOverlap })?.count ?? 0
        let unknown = items.first(where: { $0.type == .regUnknown })?.count ?? 0
        return single + overlap + unknown
    }
    
    private var combinedTotal: Int { bbTotal + rbTotal }
    
    // 単独・重複用の実効ゲーム数（初期ゲーム数を引いた値）
    private var effectiveSpins: Int {
        max(totalSpins - startSpins, 0)
    }
    
    private func saveSession() {
        var counters: [String: Int] = [:]
        for item in items {
            counters[item.type.rawValue] = item.count
        }
        
        let session = GameSession(
            id: sessionId,
            startDate: sessionStartDate,
            endDate: Date(),
            totalSpins: totalSpins,
            counters: counters,
            initialSpins: startSpins,
            initialBB: startBB,
            initialRB: startRB,
            memo: memo,
            machineName: machineName
        )
        
        if let index = gameSessions.firstIndex(where: { $0.id == sessionId }) {
            gameSessions[index] = session
        } else {
            gameSessions.append(session)
        }
        
        // ディスクに保存
        store.saveSessions()
    }

    private func increment(_ type: CoinType) {
        if let idx = items.firstIndex(where: { $0.type == type }) {
            items[idx].count += 1
            logs.append(ActionLog(type: type, timestamp: Date()))
            
            // フラッシュエフェクト
            triggerFlash(color: type.color)
            
            // 触覚フィードバック
            let generator = UIImpactFeedbackGenerator(style: .medium)
            generator.impactOccurred()
        }
    }
    
    private func triggerFlash(color: Color) {
        flashColor = color
        withAnimation(.easeIn(duration: 0.08)) {
            showFlash = true
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.08) {
            withAnimation(.easeOut(duration: 0.15)) {
                showFlash = false
            }
        }
    }

    private func decrement(_ type: CoinType) {
        if let idx = items.firstIndex(where: { $0.type == type }), items[idx].count > 0 {
            items[idx].count -= 1
        }
    }

    private func undoLast() {
        guard let last = logs.popLast(), let idx = items.firstIndex(where: { $0.type == last.type }) else { return }
        if items[idx].count > 0 { items[idx].count -= 1 }
        
        let generator = UINotificationFeedbackGenerator()
        generator.notificationOccurred(.warning)
    }

    private func resetAll() {
        for i in items.indices { items[i].count = 0 }
        totalSpins = 0
        logs.removeAll()
    }
    
    private func loadExistingSession() {
        if let session = existingSession {
            // 既存セッションを読み込み
            sessionId = session.id
            sessionStartDate = session.startDate
            totalSpins = session.totalSpins
            startSpins = session.initialSpins
            startBB = session.initialBB
            startRB = session.initialRB
            memo = session.memo
            machineName = session.machineName
            items = CoinType.allCases.map { type in
                let count = session.counters[type.rawValue] ?? 0
                return CounterItem(type: type, count: count)
            }
        } else if let data = initialData {
            // 初期データから新規セッション
            items = CoinType.allCases.map { CounterItem(type: $0, count: 0) }
            totalSpins = data.spins
            startSpins = data.spins
            startBB = data.bb
            startRB = data.rb
            machineName = data.machineName
            // BB/RBは不明に割り当て
            if let bbIdx = items.firstIndex(where: { $0.type == .bigUnknown }) {
                items[bbIdx].count = data.bb
            }
            if let rbIdx = items.firstIndex(where: { $0.type == .regUnknown }) {
                items[rbIdx].count = data.rb
            }
        } else {
            // 完全新規
            items = CoinType.allCases.map { CounterItem(type: $0, count: 0) }
        }
    }
    
    var body: some View {
        ZStack {
            AppColors.background.ignoresSafeArea()
            
            VStack(spacing: 0) {
                // ステータスヘッダー
                StatusHeaderView(
                    totalSpins: totalSpins,
                    bbTotal: bbTotal,
                    rbTotal: rbTotal,
                    combinedTotal: combinedTotal,
                    startSpins: startSpins,
                    startBB: startBB,
                    startRB: startRB,
                    onSpinTap: { showSpinInput = true }
                )
                
                // ヘッダーとコンテンツの間の空白
                Rectangle()
                    .fill(AppColors.background)
                    .frame(height: 8)
                
                // メインカウンターエリア
                ScrollView(showsIndicators: false) {
                    VStack(spacing: 12) {
                        // BB セクション
                        BonusSection(
                            title: "BIG BONUS",
                            color: AppColors.bb,
                            items: items.filter { $0.type.group == .bb },
                            totalSpins: totalSpins,
                            effectiveSpins: effectiveSpins,
                            increment: increment
                        )
                        
                        // RB セクション
                        BonusSection(
                            title: "REG BONUS",
                            color: AppColors.rb,
                            items: items.filter { $0.type.group == .rb },
                            totalSpins: totalSpins,
                            effectiveSpins: effectiveSpins,
                            increment: increment
                        )
                        
                        // 小役セクション（チェリー・ブドウ）
                        KoyakuSection(
                            items: items.filter { $0.type.group == .koyaku },
                            totalSpins: effectiveSpins,
                            increment: increment
                        )
                        
                        // メモ欄
                        MemoSection(memo: $memo)
                    }
                    .padding(12)
                }
                
                // 下部アクションバー
                ActionBar(
                    onUndo: undoLast,
                    onReset: { showResetAlert = true },
                    canUndo: !logs.isEmpty
                )
            }
            
            // フラッシュオーバーレイ
            if showFlash {
                flashColor.opacity(0.25)
                    .ignoresSafeArea()
                    .allowsHitTesting(false)
            }
        }
        .alert("リセット確認", isPresented: $showResetAlert) {
            Button("キャンセル", role: .cancel) { }
            Button("リセット", role: .destructive) { resetAll() }
        } message: {
            Text("全てのカウントと総ゲーム数をリセットしますか？")
        }
        .sheet(isPresented: $showSpinInput) {
            SpinInputSheet(totalSpins: $totalSpins)
                .presentationDetents([.height(260)])
                .presentationDragIndicator(.visible)
        }
        .navigationTitle("")
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarBackButtonHidden(true)
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button {
                    saveSession()
                    // ホーム画面まで戻る（NavigationPathをクリア）
                    navigationPath = NavigationPath()
                } label: {
                    HStack(spacing: 4) {
                        Image(systemName: "chevron.left")
                            .font(.system(size: 13, weight: .semibold))
                        Text("保存して戻る")
                            .font(.system(size: 13, weight: .medium))
                    }
                    .foregroundStyle(AppColors.accent)
                }
            }
            
            ToolbarItem(placement: .principal) {
                Menu {
                    ForEach(JugglerMachine.allCases) { machine in
                        Button(action: {
                            machineName = machine.rawValue
                        }) {
                            HStack {
                                Text(machine.rawValue)
                                if machineName == machine.rawValue {
                                    Image(systemName: "checkmark")
                                }
                            }
                        }
                    }
                } label: {
                    HStack(spacing: 4) {
                        Text(machineName)
                            .font(.system(size: 12, weight: .bold, design: .rounded))
                            .foregroundStyle(AppColors.textPrimary)
                            .lineLimit(1)
                            .minimumScaleFactor(0.7)
                        
                        Image(systemName: "chevron.down")
                            .font(.system(size: 9, weight: .bold))
                            .foregroundStyle(AppColors.accent)
                    }
                }
            }
        }
        .toolbarBackground(AppColors.cardBackground, for: .navigationBar)
        .toolbarBackground(.visible, for: .navigationBar)
        .onChange(of: totalSpins) { _, _ in saveSession() }
        .onChange(of: items) { _, _ in saveSession() }
        .onChange(of: memo) { _, _ in saveSession() }
        .onChange(of: machineName) { _, _ in saveSession() }
        .onAppear { loadExistingSession() }
    }
}
