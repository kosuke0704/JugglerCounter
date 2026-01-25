# JugglerCounter ファイル分割ガイド

## ディレクトリ構成

```
JugglerCounter/
├── Models/                          # データ層
│   ├── JugglerMachine.swift         # 機種enum（14行）
│   ├── CoinType.swift               # 子役enum（72行）
│   ├── GameSession.swift            # セッションデータ構造（60行）
│   └── GameSessionStore.swift       # データ永続化マネージャー（38行）
│
├── Views/                           # 画面層
│   ├── ContentView.swift            # メインTabView（55行）
│   ├── SplashScreenView.swift       # スプラッシュ画面（45行）
│   │
│   ├── Home/                        # ホーム画面関連
│   │   ├── GameHistoryView.swift    # 履歴一覧画面（155行）
│   │   ├── GameSessionRow.swift     # セッション行コンポーネント（115行）
│   │   └── InitialInputView.swift   # 初期入力画面（130行）
│   │
│   ├── Counter/                     # カウンター画面関連
│   │   ├── CounterView.swift        # カウンター画面（270行）
│   │   ├── StatusHeaderView.swift   # ステータスヘッダー（115行）
│   │   ├── BonusSection.swift       # BB/RBセクション（100行）
│   │   ├── KoyakuSection.swift      # 小役セクション（95行）
│   │   ├── MemoSection.swift        # メモセクション（55行）
│   │   ├── ActionBar.swift          # アクションバー（60行）
│   │   └── SpinInputSheet.swift     # ゲーム数入力シート（85行）
│   │
│   ├── Settings/
│   │   └── SettingJudgmentView.swift # 設定判別画面（40行）
│   │
│   └── Browser/
│       └── BrowserView.swift        # ブラウザ画面+WebView（165行）
│
├── Components/                      # 共通コンポーネント
│   ├── InputRow.swift               # 入力行コンポーネント（50行）
│   ├── MachinePickerRow.swift       # 機種選択コンポーネント（70行）
│   └── AnimatedNumberText.swift     # アニメーション数字（15行）
│
└── Styles/                          # スタイル定義
    ├── AppColors.swift              # カラー定義（17行）
    └── ButtonStyles.swift           # ボタンスタイル（35行）
```

## Xcodeプロジェクトへの導入手順

### 1. 既存のContentView.swiftを削除
Xcodeプロジェクトから元の`ContentView.swift`（2,089行）を削除します。

### 2. フォルダ構造を作成
Xcodeのプロジェクトナビゲーターで以下のグループを作成：
- `Models`
- `Views` → `Home`, `Counter`, `Settings`, `Browser`
- `Components`
- `Styles`

### 3. ファイルを追加
各フォルダに対応するSwiftファイルをドラッグ＆ドロップで追加します。

**追加順序（依存関係を考慮）:**
1. `Styles/AppColors.swift` ← 他の全ファイルが依存
2. `Styles/ButtonStyles.swift`
3. `Models/JugglerMachine.swift`
4. `Models/CoinType.swift` ← AppColorsに依存
5. `Models/GameSession.swift` ← CoinTypeに依存
6. `Models/GameSessionStore.swift`
7. `Components/` 配下すべて
8. `Views/` 配下すべて

### 4. ビルド確認
`Cmd + B` でビルドし、エラーがないことを確認します。

---

## 分割のメリット

| Before | After |
|--------|-------|
| 1ファイル 2,089行 | 19ファイル 平均80行 |
| 全機能が混在 | 機能ごとに分離 |
| 変更影響が大きい | 変更影響が局所的 |
| チーム開発困難 | 並行作業可能 |

---

## ファイル間の依存関係

```
AppColors ←─────────────────────────────────┐
    ↑                                       │
ButtonStyles                                │
    ↑                                       │
JugglerMachine                              │
    ↑                                       │
CoinType ──────────────────────────────────→│
    ↑                                       │
GameSession ───────────────────────────────→│
    ↑                                       │
GameSessionStore ──────────────────────────→│
    ↑                                       │
Components (InputRow, MachinePickerRow等) ─→│
    ↑                                       │
Views (各画面) ────────────────────────────→┘
```

---

## 注意事項

1. **import文**: 各ファイルで必要な`import SwiftUI`や`import WebKit`を記載済み
2. **アクセス修飾子**: すべて`internal`（デフォルト）なので、同一モジュール内で参照可能
3. **InitialGameData**: `InitialInputView.swift`内で定義されています
4. **Preview**: `ContentView.swift`のみに`#Preview`を配置

---

## トラブルシューティング

### エラー: "Cannot find 'AppColors' in scope"
→ `Styles/AppColors.swift`がプロジェクトに追加されているか確認

### エラー: "Cannot find 'GameSession' in scope"
→ `Models/GameSession.swift`がプロジェクトに追加されているか確認

### エラー: "Cannot find 'InitialGameData' in scope"
→ `Views/Home/InitialInputView.swift`がプロジェクトに追加されているか確認
