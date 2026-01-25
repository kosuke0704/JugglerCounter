import SwiftUI

// MARK: - 初期入力画面（ゲーム数・BB・RB入力）
struct InitialInputView: View {
    @Binding var gameSessions: [GameSession]
    @Binding var navigationPath: NavigationPath
    
    @State private var initialSpins: String = ""
    @State private var initialBB: String = ""
    @State private var initialRB: String = ""
    @State private var selectedMachine: JugglerMachine = .aimuJugglerEX
    
    // 元の構造に合わせて内部に定義
    struct InitialGameData: Hashable {
        var spins: Int
        var bb: Int
        var rb: Int
        var machineName: String
    }
    
    var body: some View {
        ZStack {
            AppColors.background.ignoresSafeArea()
            
            ScrollView {
                VStack(spacing: 20) {
                    // ヘッダー
                    VStack(spacing: 4) {
                        Text("初期データ入力")
                            .font(.system(size: 20, weight: .bold))
                            .foregroundStyle(AppColors.textPrimary)
                        Text("途中から始める場合は現在の値を入力")
                            .font(.system(size: 12, weight: .medium))
                            .foregroundStyle(AppColors.textSecondary)
                    }
                    .padding(.top, 10)
                    
                    VStack(spacing: 14) {
                        // 機種選択
                        MachinePickerRow(selectedMachine: $selectedMachine)
                        
                        // 総ゲーム数
                        InputRow(
                            label: "総ゲーム数",
                            value: $initialSpins,
                            placeholder: "0",
                            color: AppColors.grape,
                            icon: "gamecontroller.fill"
                        )
                        
                        // BB回数
                        InputRow(
                            label: "BB回数",
                            value: $initialBB,
                            placeholder: "0",
                            color: AppColors.bb,
                            icon: "7.circle.fill"
                        )
                        
                        // RB回数
                        InputRow(
                            label: "RB回数",
                            value: $initialRB,
                            placeholder: "0",
                            color: AppColors.rb,
                            icon: "b.circle.fill"
                        )
                    }
                    .padding(.horizontal, 20)
                    
                    Spacer(minLength: 40)
                    
                    // ボタンエリア
                    VStack(spacing: 10) {
                        // スタートボタン
                        Button {
                            let spins = Int(initialSpins) ?? 0
                            let bb = Int(initialBB) ?? 0
                            let rb = Int(initialRB) ?? 0
                            let data = InitialGameData(spins: spins, bb: bb, rb: rb, machineName: selectedMachine.rawValue)
                            // 初期入力画面を置き換えてカウンター画面へ
                            navigationPath.removeLast()
                            navigationPath.append(data)
                        } label: {
                            HStack(spacing: 8) {
                                Image(systemName: "play.circle.fill")
                                    .font(.system(size: 18, weight: .bold))
                                Text("ゲーム開始")
                                    .font(.system(size: 15, weight: .bold))
                            }
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 14)
                            .foregroundStyle(.white)
                            .background(
                                RoundedRectangle(cornerRadius: 12)
                                    .fill(AppColors.accent)
                                    .shadow(color: AppColors.accent.opacity(0.4), radius: 6, x: 0, y: 3)
                            )
                        }
                        .buttonStyle(PressableButtonStyle(color: AppColors.accent))
                        
                        // スキップリンク
                        Button {
                            let data = InitialGameData(spins: 0, bb: 0, rb: 0, machineName: selectedMachine.rawValue)
                            navigationPath.removeLast()
                            navigationPath.append(data)
                        } label: {
                            Text("スキップして0から開始")
                                .font(.system(size: 13, weight: .medium))
                                .foregroundStyle(AppColors.textSecondary)
                        }
                    }
                    .padding(.horizontal, 20)
                    .padding(.bottom, 20)
                }
            }
            .scrollDismissesKeyboard(.interactively)
        }
        .navigationTitle("新規ゲーム")
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarBackButtonHidden(true)
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button {
                    navigationPath.removeLast()
                } label: {
                    HStack(spacing: 4) {
                        Image(systemName: "chevron.left")
                            .font(.system(size: 13, weight: .semibold))
                        Text("戻る")
                            .font(.system(size: 14, weight: .medium))
                    }
                    .foregroundStyle(AppColors.accent)
                }
            }
        }
        .toolbarBackground(AppColors.cardBackground, for: .navigationBar)
        .toolbarBackground(.visible, for: .navigationBar)
    }
}
