import SwiftUI

// MARK: - 子役の種類を定義
enum CoinType: String, CaseIterable, Identifiable {
    case bigSingle = "単独BB"
    case bigOverlap = "重複BB"
    case bigUnknown = "不明BB"
    case regSingle = "単独RB"
    case regOverlap = "重複RB"
    case regUnknown = "不明RB"
    case cherry = "チェリー"
    case grape = "ブドウ"

    var id: String { rawValue }

    var color: Color {
        switch self {
        case .bigSingle, .bigOverlap, .bigUnknown: return AppColors.bb
        case .regSingle, .regOverlap, .regUnknown: return AppColors.rb
        case .cherry: return AppColors.cherry
        case .grape: return AppColors.grape
        }
    }
    
    var shortName: String {
        switch self {
        case .bigSingle: return "単独"
        case .bigOverlap: return "重複"
        case .bigUnknown: return "不明"
        case .regSingle: return "単独"
        case .regOverlap: return "重複"
        case .regUnknown: return "不明"
        case .cherry: return "チェリー"
        case .grape: return "ブドウ"
        }
    }
    
    var iconName: String? {
        switch self {
        case .bigSingle, .bigOverlap, .bigUnknown: return "bb_icon"
        case .regSingle, .regOverlap, .regUnknown: return "rb_icon"
        default: return nil
        }
    }
    
    var buttonAssetImage: String? {
        switch self {
        case .cherry: return "cherry"
        case .grape: return "grape"
        default: return nil
        }
    }
    
    var isTextButton: Bool {
        switch self {
        case .bigSingle, .bigOverlap, .bigUnknown, .regSingle, .regOverlap, .regUnknown:
            return true
        default:
            return false
        }
    }
    
    enum Group: Equatable {
        case bb, rb, koyaku
    }
    
    var group: Group {
        switch self {
        case .bigSingle, .bigOverlap, .bigUnknown: return .bb
        case .regSingle, .regOverlap, .regUnknown: return .rb
        case .cherry, .grape: return .koyaku
        }
    }
}
