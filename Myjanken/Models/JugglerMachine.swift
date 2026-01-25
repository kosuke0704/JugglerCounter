import Foundation

// MARK: - ジャグラー機種
enum JugglerMachine: String, CaseIterable, Identifiable {
    case aimuJugglerEX = "アイムジャグラーEX"
    case funkyJuggler2 = "ファンキージャグラー2"
    case myJugglerV = "マイジャグラーV"
    case happyJugglerV3 = "ハッピージャグラーVⅢ"
    case gogoJuggler3 = "ゴーゴージャグラー3"
    case jugglerGirlsSS = "ジャグラーガールズSS"
    case misterJuggler = "ミスタージャグラー"
    case ultraMiracleJuggler = "ウルトラミラクルジャグラー"
    case neoAimuJugglerEX = "ネオアイムジャグラーEX"
    
    var id: String { rawValue }
}
