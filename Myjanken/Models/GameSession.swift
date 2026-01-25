import Foundation

// MARK: - データ構造
struct CounterItem: Identifiable, Hashable {
    let id = UUID()
    let type: CoinType
    var count: Int = 0
}

struct ActionLog: Identifiable {
    let id = UUID()
    let type: CoinType
    let timestamp: Date
}

struct GameSession: Identifiable, Codable {
    let id: UUID
    let startDate: Date
    var endDate: Date
    var totalSpins: Int
    var counters: [String: Int]
    // 初期入力データ
    var initialSpins: Int
    var initialBB: Int
    var initialRB: Int
    // メモ
    var memo: String
    // 機種名
    var machineName: String
    
    init(id: UUID = UUID(), startDate: Date = Date(), endDate: Date = Date(), totalSpins: Int = 0, counters: [String: Int] = [:], initialSpins: Int = 0, initialBB: Int = 0, initialRB: Int = 0, memo: String = "", machineName: String = "アイムジャグラーEX") {
        self.id = id
        self.startDate = startDate
        self.endDate = endDate
        self.totalSpins = totalSpins
        self.counters = counters
        self.initialSpins = initialSpins
        self.initialBB = initialBB
        self.initialRB = initialRB
        self.memo = memo
        self.machineName = machineName
    }
    
    var bbTotal: Int {
        (counters[CoinType.bigSingle.rawValue] ?? 0) +
        (counters[CoinType.bigOverlap.rawValue] ?? 0) +
        (counters[CoinType.bigUnknown.rawValue] ?? 0)
    }
    
    var rbTotal: Int {
        (counters[CoinType.regSingle.rawValue] ?? 0) +
        (counters[CoinType.regOverlap.rawValue] ?? 0) +
        (counters[CoinType.regUnknown.rawValue] ?? 0)
    }
    
    var combinedRate: String {
        let total = bbTotal + rbTotal
        let games = max(totalSpins, 1)
        let rate = Double(games) / Double(max(total, 1))
        return String(format: "1/%.0f", rate)
    }
}
