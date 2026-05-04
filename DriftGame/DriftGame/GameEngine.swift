//
//  GameEngine.swift
//  DriftGame
//
//  核心游戏逻辑：交换、漂移、组合检测、胜负判断
//

import Foundation

// MARK: - Delegate Protocol

protocol GameEngineDelegate: AnyObject {
    func gameEngine(_ engine: GameEngine, didUpdateBoard board: [[Tile?]])
    func gameEngine(_ engine: GameEngine, didDetectCombinations combos: [DetectedCombination])
    func gameEngine(_ engine: GameEngine, didDrift round: Int)
    func gameEngine(_ engine: GameEngine, didSelectTile at: Position?)
    func gameEngineDidWin(_ engine: GameEngine, score: Int)
    func gameEngineDidLose(_ engine: GameEngine)
    func gameEngine(_ engine: GameEngine, movesLeftChanged moves: Int)
}

// MARK: - Game Engine

class GameEngine {

    // MARK: - State
    private(set) var level: GameLevel
    private(set) var board: [[Tile?]]           // rows × cols
    private(set) var movesLeft: Int
    private(set) var currentRound: Int = 1
    private(set) var score: Int = 0
    private(set) var selectedPosition: Position? = nil
    private(set) var detectedCombinations: [DetectedCombination] = []
    private(set) var completedCombosCount: Int = 0
    private(set) var isGameOver: Bool = false

    weak var delegate: GameEngineDelegate?

    // MARK: - Init

    init(level: GameLevel) {
        self.level = level
        self.movesLeft = level.maxMoves
        self.board = GameEngine.buildBoard(from: level)
    }

    private static func buildBoard(from level: GameLevel) -> [[Tile?]] {
        var board: [[Tile?]] = Array(repeating: Array(repeating: nil, count: level.cols), count: level.rows)
        for r in 0..<level.rows {
            for c in 0..<level.cols {
                let v = level.initialValues[r][c]
                if v > 0 {
                    let pos = Position(row: r, col: c)
                    let special = level.specialTiles[pos] ?? .normal
                    board[r][c] = Tile(value: v, specialType: special)
                }
            }
        }
        return board
    }

    // MARK: - Tile at Position

    func tile(at pos: Position) -> Tile? {
        guard isValid(pos) else { return nil }
        return board[pos.row][pos.col]
    }

    func isValid(_ pos: Position) -> Bool {
        pos.row >= 0 && pos.row < level.rows && pos.col >= 0 && pos.col < level.cols
    }

    // MARK: - Select & Swap

    func selectOrSwap(at position: Position) {
        guard !isGameOver else { return }
        guard let _ = tile(at: position) else { return }

        if let selected = selectedPosition {
            if selected == position {
                // 取消选中
                selectedPosition = nil
                delegate?.gameEngine(self, didSelectTile: nil)
            } else {
                // 尝试交换
                attemptSwap(from: selected, to: position)
            }
        } else {
            // 选中牌
            if board[position.row][position.col]?.isLocked == false {
                selectedPosition = position
                delegate?.gameEngine(self, didSelectTile: position)
            }
        }
    }

    private func attemptSwap(from: Position, to: Position) {
        guard !board[from.row][from.col]!.isLocked,
              !(board[to.row][to.col]?.isLocked ?? false) else {
            // 目标锁定，重新选择
            selectedPosition = to
            delegate?.gameEngine(self, didSelectTile: to)
            return
        }

        // 执行交换
        let temp = board[from.row][from.col]
        board[from.row][from.col] = board[to.row][to.col]
        board[to.row][to.col] = temp

        selectedPosition = nil
        movesLeft -= 1
        delegate?.gameEngine(self, movesLeftChanged: movesLeft)
        delegate?.gameEngine(self, didSelectTile: nil)

        // 检测组合
        refreshCombinations()
        delegate?.gameEngine(self, didUpdateBoard: board)

        // 检查胜利
        if checkWin() { return }

        // 检查步数耗尽
        if movesLeft <= 0 {
            if !checkWin() {
                isGameOver = true
                delegate?.gameEngineDidLose(self)
            }
        }
    }

    // MARK: - End Round (Drift)

    func endRound() {
        guard !isGameOver else { return }

        applyDrift()
        currentRound += 1
        refreshCombinations()

        delegate?.gameEngine(self, didDrift: currentRound)
        delegate?.gameEngine(self, didUpdateBoard: board)

        if checkWin() { return }
        if movesLeft <= 0 {
            isGameOver = true
            delegate?.gameEngineDidLose(self)
        }
    }

    // MARK: - Drift Logic

    private func applyDrift() {
        switch level.driftRule {
        case .standard:
            applyUniformDrift(amount: 1)
        case .reverse:
            applyUniformDrift(amount: -1)
        case .randomDrift:
            applyRandomDrift()
        case .zone(let rowRange, let colRange, let amount):
            applyZoneDrift(rowRange: rowRange, colRange: colRange, amount: amount)
        case .delayed(let interval):
            if currentRound % interval == 0 {
                applyUniformDrift(amount: 1)
            }
        case .mixed(let rules):
            for rule in rules {
                let subEngine = GameEngine(level: level)
                subEngine.board = board
                // simplified: just apply first rule
                _ = rule
            }
            applyUniformDrift(amount: 1)
        }
    }

    private func applyUniformDrift(amount: Int) {
        for r in 0..<level.rows {
            for c in 0..<level.cols {
                guard var tile = board[r][c], !tile.isFrozen else { continue }
                if tile.isRandom {
                    let delta = Bool.random() ? 1 : -1
                    tile.value = cycleValue(tile.value + delta)
                } else {
                    tile.value = cycleValue(tile.value + amount)
                }
                board[r][c] = tile
            }
        }
    }

    private func applyRandomDrift() {
        for r in 0..<level.rows {
            for c in 0..<level.cols {
                guard var tile = board[r][c], !tile.isFrozen else { continue }
                let delta = Bool.random() ? 1 : -1
                tile.value = cycleValue(tile.value + delta)
                board[r][c] = tile
            }
        }
    }

    private func applyZoneDrift(rowRange: ClosedRange<Int>, colRange: ClosedRange<Int>, amount: Int) {
        for r in 0..<level.rows {
            for c in 0..<level.cols {
                guard var tile = board[r][c], !tile.isFrozen else { continue }
                let zoneAmount = (rowRange.contains(r) && colRange.contains(c)) ? amount : 1
                tile.value = cycleValue(tile.value + zoneAmount)
                board[r][c] = tile
            }
        }
    }

    private func cycleValue(_ v: Int) -> Int {
        var result = v % 9
        if result <= 0 { result += 9 }
        return result
    }

    // MARK: - Combination Detection

    func refreshCombinations() {
        detectedCombinations = detectCombinations()
    }

    func detectCombinations() -> [DetectedCombination] {
        var results: [DetectedCombination] = []
        let allowed = level.allowedCombinations

        // Scan rows
        for r in 0..<level.rows {
            for c in 0..<level.cols {
                // 3-tile window horizontal
                if c + 2 < level.cols {
                    let positions = [Position(row: r, col: c),
                                     Position(row: r, col: c + 1),
                                     Position(row: r, col: c + 2)]
                    if let combo = detectInWindow(positions, allowed: allowed) {
                        results.append(combo)
                    }
                }
                // 2-tile window horizontal (pairs)
                if c + 1 < level.cols, allowed.contains(.pair) {
                    let positions = [Position(row: r, col: c),
                                     Position(row: r, col: c + 1)]
                    if let combo = detectPair(positions) {
                        results.append(combo)
                    }
                }
            }
        }

        // Scan columns
        for c in 0..<level.cols {
            for r in 0..<level.rows {
                // 3-tile window vertical
                if r + 2 < level.rows {
                    let positions = [Position(row: r, col: c),
                                     Position(row: r + 1, col: c),
                                     Position(row: r + 2, col: c)]
                    if let combo = detectInWindow(positions, allowed: allowed) {
                        results.append(combo)
                    }
                }
                // 2-tile vertical pairs
                if r + 1 < level.rows, allowed.contains(.pair) {
                    let positions = [Position(row: r, col: c),
                                     Position(row: r + 1, col: c)]
                    if let combo = detectPair(positions) {
                        results.append(combo)
                    }
                }
            }
        }

        // Deduplicate: remove overlapping combos (prefer longer)
        return deduplicate(results)
    }

    private func detectInWindow(_ positions: [Position], allowed: [CombinationType]) -> DetectedCombination? {
        let tiles = positions.compactMap { tile(at: $0) }
        guard tiles.count == 3 else { return nil }
        let values = tiles.map { $0.value }

        // Triplet
        if allowed.contains(.triplet), values[0] == values[1], values[1] == values[2] {
            return DetectedCombination(type: .triplet, positions: positions, score: values[0] * 3 + 10)
        }

        // Sequence (including ring: 9-1-2, 8-9-1)
        if allowed.contains(.sequence) {
            let sorted = values.sorted()
            let isSequential = (sorted[1] == sorted[0] + 1 && sorted[2] == sorted[1] + 1)
            // Ring: contains 9 and 1
            let isRing = sorted == [1, 2, 9] || sorted == [1, 8, 9] || sorted == [1, 9, 2]
                      || (sorted.contains(9) && sorted.contains(1) && sorted.contains(2))
                      || (sorted.contains(8) && sorted.contains(9) && sorted.contains(1))
            if isSequential || isRing {
                return DetectedCombination(type: .sequence, positions: positions, score: values.reduce(0, +) + 5)
            }
        }

        // Target Sum
        if allowed.contains(.targetSum), let target = level.targetSum {
            if values.reduce(0, +) == target {
                return DetectedCombination(type: .targetSum, positions: positions, score: target + 15)
            }
        }

        return nil
    }

    private func detectPair(_ positions: [Position]) -> DetectedCombination? {
        let tiles = positions.compactMap { tile(at: $0) }
        guard tiles.count == 2 else { return nil }
        if tiles[0].value == tiles[1].value {
            return DetectedCombination(type: .pair, positions: positions, score: tiles[0].value * 2 + 5)
        }
        return nil
    }

    private func deduplicate(_ combos: [DetectedCombination]) -> [DetectedCombination] {
        var used: Set<Position> = []
        var result: [DetectedCombination] = []
        // Sort: prefer longer combos (triplet/sequence) first
        let sorted = combos.sorted { $0.positions.count > $1.positions.count }
        for combo in sorted {
            let posSet = Set(combo.positions)
            if posSet.isDisjoint(with: used) {
                result.append(combo)
                used.formUnion(posSet)
            }
        }
        return result
    }

    // MARK: - Preview (Next Round Values)

    func previewNextValue(at pos: Position) -> Int? {
        guard let tile = tile(at: pos), !tile.isFrozen else {
            return tile(at: pos)?.value
        }
        switch level.driftRule {
        case .standard:
            return cycleValue(tile.value + 1)
        case .reverse:
            return cycleValue(tile.value - 1)
        case .zone(let rowRange, let colRange, let amount):
            let a = (rowRange.contains(pos.row) && colRange.contains(pos.col)) ? amount : 1
            return cycleValue(tile.value + a)
        default:
            return cycleValue(tile.value + 1)
        }
    }

    // MARK: - Win / Lose Check

    @discardableResult
    private func checkWin() -> Bool {
        switch level.winCondition {
        case .anyComboCount(let needed):
            let count = detectedCombinations.count
            if count >= needed {
                score = detectedCombinations.reduce(0) { $0 + $1.score } + movesLeft * 5
                isGameOver = true
                delegate?.gameEngineDidWin(self, score: score)
                return true
            }
        case .combinationCount(let needed, let type):
            let count: Int
            if let t = type {
                count = detectedCombinations.filter { $0.type == t }.count
            } else {
                count = detectedCombinations.count
            }
            if count >= needed {
                score = detectedCombinations.reduce(0) { $0 + $1.score } + movesLeft * 5
                isGameOver = true
                delegate?.gameEngineDidWin(self, score: score)
                return true
            }
        case .reachScore(let target):
            let total = detectedCombinations.reduce(0) { $0 + $1.score }
            if total >= target {
                score = total + movesLeft * 5
                isGameOver = true
                delegate?.gameEngineDidWin(self, score: score)
                return true
            }
        case .withinRounds(let maxRounds, let needed):
            if currentRound > maxRounds {
                isGameOver = true
                delegate?.gameEngineDidLose(self)
                return true
            }
            if detectedCombinations.count >= needed {
                score = detectedCombinations.reduce(0) { $0 + $1.score } + (maxRounds - currentRound) * 10
                isGameOver = true
                delegate?.gameEngineDidWin(self, score: score)
                return true
            }
        }
        return false
    }

    // MARK: - Skills

    func useSkillFreeze() {
        // 冻结一回合：本次漂移不生效（不消耗steps）
        // 简化实现：直接跳过漂移
        currentRound += 1
        refreshCombinations()
        delegate?.gameEngine(self, didDrift: currentRound)
        delegate?.gameEngine(self, didUpdateBoard: board)
        _ = checkWin()
    }

    func useSkillResetTile(at pos: Position) {
        guard var tile = tile(at: pos) else { return }
        tile.value = Int.random(in: 1...9)
        board[pos.row][pos.col] = tile
        refreshCombinations()
        delegate?.gameEngine(self, didUpdateBoard: board)
    }
}
