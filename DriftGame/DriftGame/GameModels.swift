//
//  GameModels.swift
//  DriftGame
//
//  核心数据模型：Tile、Position、Combination、WinCondition、DriftRule
//

import UIKit

// MARK: - Position

struct Position: Hashable, Equatable {
    let row: Int
    let col: Int
}

// MARK: - Tile Special Type

enum TileSpecialType: String {
    case normal      = "normal"
    case locked      = "locked"      // 🔒 不可移动
    case frozen      = "frozen"      // ❄️ 不漂移
    case random      = "random"      // 🎲 每回合随机值
}

// MARK: - Tile

struct Tile {
    var value: Int                  // 1~9
    var specialType: TileSpecialType
    var driftDelay: Int             // 剩余延迟回合数（延迟漂移机制）
    let id: UUID

    init(value: Int, specialType: TileSpecialType = .normal, driftDelay: Int = 0) {
        self.value = max(1, min(9, value))
        self.specialType = specialType
        self.driftDelay = driftDelay
        self.id = UUID()
    }

    var isLocked: Bool  { specialType == .locked }
    var isFrozen: Bool  { specialType == .frozen }
    var isRandom: Bool  { specialType == .random }
}

// MARK: - Combination Type

enum CombinationType: String {
    case pair       = "Pair"       // same value x2
    case triplet    = "Triplet"    // same value x3
    case sequence   = "Sequence"   // consecutive x3 (incl. 9-1-2 wrap)
    case targetSum  = "Sum"        // total == target
}

// MARK: - Detected Combination

struct DetectedCombination: Equatable {
    let type: CombinationType
    let positions: [Position]
    let score: Int

    static func == (lhs: DetectedCombination, rhs: DetectedCombination) -> Bool {
        return Set(lhs.positions) == Set(rhs.positions)
    }
}

// MARK: - Drift Rule

enum DriftRule {
    case standard               // 全体 +1，9→1
    case reverse                // 全体 -1，1→9
    case randomDrift            // 随机 ±1
    case zone(rowRange: ClosedRange<Int>, colRange: ClosedRange<Int>, amount: Int)  // 区域+N
    case delayed(interval: Int) // 每隔 N 回合才漂移
    case mixed(rules: [DriftRule])
}

// MARK: - Win Condition

enum WinCondition {
    case combinationCount(Int, type: CombinationType?)   // 完成 N 个组合（可指定类型）
    case anyComboCount(Int)                              // 任意类型共 N 个
    case reachScore(Int)                                 // 达到分数 N
    case withinRounds(maxRounds: Int, neededCombos: Int) // N 回合内完成
}

// MARK: - Game Level

struct GameLevel {
    let id: Int
    let name: String
    let subtitle: String
    let rows: Int
    let cols: Int
    let initialValues: [[Int]]          // 初始牌面，0 = 空格
    let specialTiles: [Position: TileSpecialType]
    let driftRule: DriftRule
    let maxMoves: Int                   // 总交换次数限制
    let winCondition: WinCondition
    let allowedCombinations: [CombinationType]
    let targetSum: Int?                 // 目标和模式时的目标值
    let difficulty: Int                 // 1~5 星
    let hint: String
}

// MARK: - UIColor Helper

extension UIColor {
    static func tileColor(for value: Int) -> UIColor {
        switch value {
        case 1: return UIColor(red: 0.29, green: 0.76, blue: 0.98, alpha: 1) // 冰蓝
        case 2: return UIColor(red: 0.30, green: 0.85, blue: 0.69, alpha: 1) // 青绿
        case 3: return UIColor(red: 0.40, green: 0.78, blue: 0.42, alpha: 1) // 绿
        case 4: return UIColor(red: 0.78, green: 0.90, blue: 0.27, alpha: 1) // 黄绿
        case 5: return UIColor(red: 1.00, green: 0.86, blue: 0.15, alpha: 1) // 金黄
        case 6: return UIColor(red: 1.00, green: 0.60, blue: 0.14, alpha: 1) // 橙
        case 7: return UIColor(red: 0.96, green: 0.39, blue: 0.25, alpha: 1) // 橙红
        case 8: return UIColor(red: 0.91, green: 0.19, blue: 0.22, alpha: 1) // 红
        case 9: return UIColor(red: 0.68, green: 0.11, blue: 0.55, alpha: 1) // 紫红
        default: return .systemGray
        }
    }
}
