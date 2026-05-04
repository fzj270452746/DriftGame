//
//  LevelData.swift
//  DriftGame
//
//  60 level definitions across 6 chapters, increasing difficulty
//

import Foundation

struct LevelData {

    static let all: [GameLevel] = [
        level1,  level2,  level3,  level4,  level5,
        level6,  level7,  level8,  level9,  level10,
        level11, level12, level13, level14, level15,
        level16, level17, level18, level19, level20,
        level21, level22, level23, level24, level25,
        level26, level27, level28, level29, level30,
        level31, level32, level33, level34, level35,
        level36, level37, level38, level39, level40,
        level41, level42, level43, level44, level45,
        level46, level47, level48, level49, level50,
        level51, level52, level53, level54, level55,
        level56, level57, level58, level59, level60
    ]

    // MARK: - Chapter 1: Awakening (1–10)

    static let level1 = GameLevel(
        id: 1,
        name: "First Drift",
        subtitle: "Find a matching pair",
        rows: 3, cols: 3,
        initialValues: [
            [1, 3, 5],
            [7, 2, 4],
            [6, 3, 8]
        ],
        specialTiles: [:],
        driftRule: .standard,
        maxMoves: 6,
        winCondition: .anyComboCount(1),
        allowedCombinations: [.pair],
        targetSum: nil,
        difficulty: 1,
        hint: "Swap tiles until two identical numbers are adjacent — that forms a Pair."
    )

    static let level2 = GameLevel(
        id: 2,
        name: "Sequence Path",
        subtitle: "Form a sequence (3 consecutive numbers)",
        rows: 3, cols: 3,
        initialValues: [
            [2, 5, 7],
            [4, 1, 3],
            [8, 6, 9]
        ],
        specialTiles: [:],
        driftRule: .standard,
        maxMoves: 8,
        winCondition: .anyComboCount(1),
        allowedCombinations: [.sequence],
        targetSum: nil,
        difficulty: 1,
        hint: "Line up 3 consecutive numbers in the same row or column."
    )

    static let level3 = GameLevel(
        id: 3,
        name: "Triple Match",
        subtitle: "Form a triplet (3 identical tiles)",
        rows: 3, cols: 3,
        initialValues: [
            [1, 3, 5],
            [5, 2, 7],
            [4, 5, 9]
        ],
        specialTiles: [:],
        driftRule: .standard,
        maxMoves: 6,
        winCondition: .combinationCount(1, type: .triplet),
        allowedCombinations: [.triplet],
        targetSum: nil,
        difficulty: 2,
        hint: "Drift changes all values — use it to align 3 tiles to the same number."
    )

    static let level4 = GameLevel(
        id: 4,
        name: "Target 15",
        subtitle: "Make 3 adjacent tiles sum to 15",
        rows: 3, cols: 3,
        initialValues: [
            [2, 7, 1],
            [5, 4, 9],
            [3, 6, 8]
        ],
        specialTiles: [:],
        driftRule: .standard,
        maxMoves: 10,
        winCondition: .anyComboCount(1),
        allowedCombinations: [.targetSum],
        targetSum: 15,
        difficulty: 2,
        hint: "Find 3 adjacent tiles whose values add up to exactly 15."
    )

    static let level5 = GameLevel(
        id: 5,
        name: "Double Joy",
        subtitle: "Form 2 combinations at once",
        rows: 4, cols: 4,
        initialValues: [
            [1, 3, 2, 5],
            [4, 1, 7, 3],
            [8, 6, 4, 9],
            [2, 5, 6, 7]
        ],
        specialTiles: [:],
        driftRule: .standard,
        maxMoves: 12,
        winCondition: .anyComboCount(2),
        allowedCombinations: [.pair, .sequence, .triplet],
        targetSum: nil,
        difficulty: 2,
        hint: "On the 4×4 board you need 2 valid combinations — any type counts."
    )

    static let level6 = GameLevel(
        id: 6,
        name: "Shackles",
        subtitle: "Locked tiles can't move — use drift instead",
        rows: 4, cols: 4,
        initialValues: [
            [7, 2, 5, 1],
            [3, 8, 4, 6],
            [1, 5, 9, 2],
            [4, 3, 7, 8]
        ],
        specialTiles: [
            Position(row: 0, col: 0): .locked,
            Position(row: 1, col: 1): .locked,
            Position(row: 2, col: 3): .locked,
            Position(row: 3, col: 2): .locked
        ],
        driftRule: .standard,
        maxMoves: 10,
        winCondition: .anyComboCount(2),
        allowedCombinations: [.pair, .sequence, .triplet],
        targetSum: nil,
        difficulty: 3,
        hint: "Locked tiles cannot be swapped. Let drift bring the values to you."
    )

    static let level7 = GameLevel(
        id: 7,
        name: "Reverse Flow",
        subtitle: "Numbers drift −1 each round (1→9)",
        rows: 4, cols: 4,
        initialValues: [
            [8, 3, 6, 1],
            [5, 9, 2, 7],
            [4, 1, 8, 3],
            [6, 5, 9, 2]
        ],
        specialTiles: [:],
        driftRule: .reverse,
        maxMoves: 10,
        winCondition: .anyComboCount(2),
        allowedCombinations: [.pair, .sequence, .triplet],
        targetSum: nil,
        difficulty: 3,
        hint: "Values count down! 1 wraps to 9. Think backwards."
    )

    static let level8 = GameLevel(
        id: 8,
        name: "Frozen",
        subtitle: "Frozen tiles are immune to drift",
        rows: 4, cols: 4,
        initialValues: [
            [3, 7, 2, 6],
            [5, 1, 8, 4],
            [9, 3, 5, 1],
            [2, 6, 7, 9]
        ],
        specialTiles: [
            Position(row: 0, col: 1): .frozen,
            Position(row: 1, col: 2): .frozen,
            Position(row: 2, col: 0): .frozen,
            Position(row: 3, col: 3): .frozen
        ],
        driftRule: .standard,
        maxMoves: 12,
        winCondition: .anyComboCount(3),
        allowedCombinations: [.pair, .sequence, .triplet],
        targetSum: nil,
        difficulty: 3,
        hint: "Frozen tiles hold their value — use them as stable anchors."
    )

    static let level9 = GameLevel(
        id: 9,
        name: "Dual Speed",
        subtitle: "Top half +2, bottom half +1 per round",
        rows: 4, cols: 4,
        initialValues: [
            [1, 5, 3, 7],
            [4, 2, 8, 1],
            [6, 9, 2, 5],
            [3, 4, 7, 6]
        ],
        specialTiles: [:],
        driftRule: .zone(rowRange: 0...1, colRange: 0...3, amount: 2),
        maxMoves: 12,
        winCondition: .anyComboCount(3),
        allowedCombinations: [.pair, .sequence, .triplet, .targetSum],
        targetSum: 15,
        difficulty: 4,
        hint: "Top 2 rows drift +2, bottom 2 rows drift +1. Exploit the speed gap."
    )

    static let level10 = GameLevel(
        id: 10,
        name: "Drift Master",
        subtitle: "Ultimate challenge: complete 5 combos",
        rows: 5, cols: 5,
        initialValues: [
            [1, 3, 7, 2, 5],
            [8, 5, 1, 9, 3],
            [4, 6, 2, 7, 1],
            [9, 1, 8, 3, 6],
            [2, 7, 4, 5, 9]
        ],
        specialTiles: [
            Position(row: 0, col: 2): .locked,
            Position(row: 2, col: 2): .frozen,
            Position(row: 4, col: 2): .locked
        ],
        driftRule: .standard,
        maxMoves: 20,
        winCondition: .anyComboCount(5),
        allowedCombinations: [.pair, .sequence, .triplet, .targetSum],
        targetSum: 15,
        difficulty: 5,
        hint: "5×5 board, 5 combos needed. Use every strategy you've learned."
    )

    // MARK: - Chapter 2: Rising Tide (11–20)

    static let level11 = GameLevel(
        id: 11,
        name: "Double Draw",
        subtitle: "Find two matching pairs",
        rows: 3, cols: 3,
        initialValues: [
            [4, 2, 7],
            [1, 4, 3],
            [8, 6, 2]
        ],
        specialTiles: [:],
        driftRule: .standard,
        maxMoves: 8,
        winCondition: .anyComboCount(2),
        allowedCombinations: [.pair],
        targetSum: nil,
        difficulty: 1,
        hint: "Two pairs needed. Drift creates new values — let it bring duplicates to you."
    )

    static let level12 = GameLevel(
        id: 12,
        name: "Countdown Path",
        subtitle: "Form a sequence while values fall",
        rows: 3, cols: 3,
        initialValues: [
            [9, 4, 7],
            [2, 6, 5],
            [8, 1, 3]
        ],
        specialTiles: [:],
        driftRule: .reverse,
        maxMoves: 8,
        winCondition: .anyComboCount(1),
        allowedCombinations: [.sequence],
        targetSum: nil,
        difficulty: 2,
        hint: "Values drop by 1 each round. Plan ahead — the window for each sequence is short."
    )

    static let level13 = GameLevel(
        id: 13,
        name: "Sum of Nine",
        subtitle: "Make 3 tiles sum to exactly 9",
        rows: 3, cols: 3,
        initialValues: [
            [1, 6, 4],
            [7, 2, 8],
            [3, 5, 9]
        ],
        specialTiles: [:],
        driftRule: .standard,
        maxMoves: 8,
        winCondition: .anyComboCount(1),
        allowedCombinations: [.targetSum],
        targetSum: 9,
        difficulty: 2,
        hint: "Three adjacent tiles summing to 9. Try: 1+3+5, 2+3+4, 1+2+6."
    )

    static let level14 = GameLevel(
        id: 14,
        name: "Four of a Kind",
        subtitle: "Make 3 pairs on the 4×4 board",
        rows: 4, cols: 4,
        initialValues: [
            [3, 7, 1, 5],
            [6, 3, 8, 2],
            [4, 9, 5, 7],
            [1, 2, 4, 6]
        ],
        specialTiles: [:],
        driftRule: .standard,
        maxMoves: 12,
        winCondition: .anyComboCount(3),
        allowedCombinations: [.pair],
        targetSum: nil,
        difficulty: 2,
        hint: "More tiles means more possible pairs. Watch how drift creates new matches."
    )

    static let level15 = GameLevel(
        id: 15,
        name: "Running Dragon",
        subtitle: "Form 2 sequences on the 4×4 board",
        rows: 4, cols: 4,
        initialValues: [
            [5, 8, 2, 6],
            [1, 4, 9, 3],
            [7, 2, 5, 8],
            [3, 6, 1, 4]
        ],
        specialTiles: [:],
        driftRule: .standard,
        maxMoves: 14,
        winCondition: .anyComboCount(2),
        allowedCombinations: [.sequence],
        targetSum: nil,
        difficulty: 2,
        hint: "Sequences wrap: 7-8-9, 8-9-1, 9-1-2 all count. Use drift to align three."
    )

    static let level16 = GameLevel(
        id: 16,
        name: "Sum to Twelve",
        subtitle: "Reach target sum 12 twice",
        rows: 4, cols: 4,
        initialValues: [
            [2, 8, 5, 1],
            [9, 3, 7, 4],
            [6, 1, 8, 3],
            [4, 7, 2, 9]
        ],
        specialTiles: [:],
        driftRule: .standard,
        maxMoves: 12,
        winCondition: .anyComboCount(2),
        allowedCombinations: [.targetSum],
        targetSum: 12,
        difficulty: 2,
        hint: "Three adjacent tiles summing to 12. For example: 3+4+5, 4+4+4, 2+5+5."
    )

    static let level17 = GameLevel(
        id: 17,
        name: "First Ice",
        subtitle: "Work around a frozen anchor tile",
        rows: 4, cols: 4,
        initialValues: [
            [6, 2, 8, 4],
            [1, 5, 3, 7],
            [9, 4, 6, 1],
            [2, 7, 5, 8]
        ],
        specialTiles: [
            Position(row: 1, col: 1): .frozen
        ],
        driftRule: .standard,
        maxMoves: 12,
        winCondition: .anyComboCount(2),
        allowedCombinations: [.pair, .sequence, .triplet],
        targetSum: nil,
        difficulty: 2,
        hint: "The frozen tile keeps its value every round. Use it as a stable anchor."
    )

    static let level18 = GameLevel(
        id: 18,
        name: "First Chain",
        subtitle: "Drift past the locked tile",
        rows: 4, cols: 4,
        initialValues: [
            [4, 9, 3, 7],
            [8, 2, 6, 1],
            [5, 3, 9, 4],
            [1, 6, 2, 5]
        ],
        specialTiles: [
            Position(row: 2, col: 2): .locked
        ],
        driftRule: .standard,
        maxMoves: 10,
        winCondition: .anyComboCount(2),
        allowedCombinations: [.pair, .sequence, .triplet],
        targetSum: nil,
        difficulty: 2,
        hint: "Locked tiles can't be swapped. Route your combos around it."
    )

    static let level19 = GameLevel(
        id: 19,
        name: "Falling Stars",
        subtitle: "Reverse drift + two corner locks",
        rows: 4, cols: 4,
        initialValues: [
            [7, 3, 9, 5],
            [2, 8, 1, 6],
            [4, 5, 7, 2],
            [9, 1, 4, 8]
        ],
        specialTiles: [
            Position(row: 0, col: 3): .locked,
            Position(row: 3, col: 0): .locked
        ],
        driftRule: .reverse,
        maxMoves: 12,
        winCondition: .anyComboCount(2),
        allowedCombinations: [.pair, .sequence, .triplet],
        targetSum: nil,
        difficulty: 3,
        hint: "Values fall each round AND two corners are locked. Adapt your plans quickly."
    )

    static let level20 = GameLevel(
        id: 20,
        name: "Quad Harmony",
        subtitle: "Form 4 combinations of any type",
        rows: 4, cols: 4,
        initialValues: [
            [1, 5, 3, 8],
            [7, 2, 6, 4],
            [9, 4, 1, 6],
            [3, 8, 7, 2]
        ],
        specialTiles: [:],
        driftRule: .standard,
        maxMoves: 16,
        winCondition: .anyComboCount(4),
        allowedCombinations: [.pair, .sequence, .triplet],
        targetSum: nil,
        difficulty: 3,
        hint: "Four combos needed — any type counts. Mix pairs and sequences for efficiency."
    )

    // MARK: - Chapter 3: Twisted Currents (21–30)

    static let level21 = GameLevel(
        id: 21,
        name: "Bamboo Forest",
        subtitle: "Sequences only — form 3",
        rows: 4, cols: 4,
        initialValues: [
            [8, 3, 6, 1],
            [4, 7, 2, 9],
            [5, 1, 8, 4],
            [2, 6, 3, 7]
        ],
        specialTiles: [:],
        driftRule: .standard,
        maxMoves: 14,
        winCondition: .anyComboCount(3),
        allowedCombinations: [.sequence],
        targetSum: nil,
        difficulty: 2,
        hint: "Sequences only: three consecutive values in a line. Don't forget the 9→1 wrap."
    )

    static let level22 = GameLevel(
        id: 22,
        name: "Stone Triplets",
        subtitle: "Two triplets required",
        rows: 4, cols: 4,
        initialValues: [
            [2, 7, 4, 2],
            [6, 1, 9, 6],
            [3, 8, 5, 3],
            [7, 4, 1, 8]
        ],
        specialTiles: [:],
        driftRule: .standard,
        maxMoves: 12,
        winCondition: .combinationCount(2, type: .triplet),
        allowedCombinations: [.triplet],
        targetSum: nil,
        difficulty: 3,
        hint: "Two triplets needed. Drift steadily converges values — be patient and plan ahead."
    )

    static let level23 = GameLevel(
        id: 23,
        name: "Speed Zone",
        subtitle: "Left columns drift +2, right columns +1",
        rows: 4, cols: 4,
        initialValues: [
            [3, 8, 5, 1],
            [9, 2, 7, 4],
            [6, 4, 9, 3],
            [1, 5, 2, 8]
        ],
        specialTiles: [:],
        driftRule: .zone(rowRange: 0...3, colRange: 0...1, amount: 2),
        maxMoves: 12,
        winCondition: .anyComboCount(3),
        allowedCombinations: [.pair, .sequence, .triplet],
        targetSum: nil,
        difficulty: 3,
        hint: "Left two columns drift at double speed. Predict where values land before drifting past."
    )

    static let level24 = GameLevel(
        id: 24,
        name: "Iron Wall",
        subtitle: "Four corner locks block the board",
        rows: 4, cols: 4,
        initialValues: [
            [5, 2, 8, 3],
            [1, 6, 4, 9],
            [7, 3, 5, 1],
            [4, 8, 2, 6]
        ],
        specialTiles: [
            Position(row: 0, col: 0): .locked,
            Position(row: 0, col: 3): .locked,
            Position(row: 3, col: 0): .locked,
            Position(row: 3, col: 3): .locked
        ],
        driftRule: .standard,
        maxMoves: 12,
        winCondition: .anyComboCount(2),
        allowedCombinations: [.pair, .sequence, .triplet],
        targetSum: nil,
        difficulty: 3,
        hint: "All four corners are locked. Work with the 8 free center and edge tiles."
    )

    static let level25 = GameLevel(
        id: 25,
        name: "Ice Shelf",
        subtitle: "Four frozen anchors hold the grid",
        rows: 4, cols: 4,
        initialValues: [
            [4, 7, 2, 8],
            [1, 5, 9, 3],
            [6, 2, 7, 4],
            [3, 8, 1, 5]
        ],
        specialTiles: [
            Position(row: 0, col: 1): .frozen,
            Position(row: 1, col: 3): .frozen,
            Position(row: 2, col: 0): .frozen,
            Position(row: 3, col: 2): .frozen
        ],
        driftRule: .standard,
        maxMoves: 14,
        winCondition: .anyComboCount(3),
        allowedCombinations: [.pair, .sequence, .triplet],
        targetSum: nil,
        difficulty: 3,
        hint: "Four frozen anchors don't drift. Plan combos around their stable values."
    )

    static let level26 = GameLevel(
        id: 26,
        name: "Grand Stage",
        subtitle: "Welcome to the 5×5 board",
        rows: 5, cols: 5,
        initialValues: [
            [2, 7, 4, 9, 1],
            [6, 3, 8, 5, 2],
            [1, 5, 7, 3, 8],
            [4, 9, 2, 6, 4],
            [8, 1, 5, 7, 3]
        ],
        specialTiles: [:],
        driftRule: .standard,
        maxMoves: 18,
        winCondition: .anyComboCount(3),
        allowedCombinations: [.pair, .sequence, .triplet],
        targetSum: nil,
        difficulty: 3,
        hint: "The 5×5 board offers many paths. Look for opportunities across all rows and columns."
    )

    static let level27 = GameLevel(
        id: 27,
        name: "Five Pillars",
        subtitle: "Locked cross pattern on 5×5",
        rows: 5, cols: 5,
        initialValues: [
            [3, 8, 1, 6, 4],
            [7, 2, 9, 3, 8],
            [5, 4, 6, 1, 7],
            [2, 9, 4, 5, 2],
            [8, 1, 7, 4, 9]
        ],
        specialTiles: [
            Position(row: 0, col: 2): .locked,
            Position(row: 2, col: 0): .locked,
            Position(row: 2, col: 2): .locked,
            Position(row: 2, col: 4): .locked,
            Position(row: 4, col: 2): .locked
        ],
        driftRule: .standard,
        maxMoves: 16,
        winCondition: .anyComboCount(3),
        allowedCombinations: [.pair, .sequence, .triplet],
        targetSum: nil,
        difficulty: 3,
        hint: "Five locks form a cross. Navigate the four open quadrants to build combos."
    )

    static let level28 = GameLevel(
        id: 28,
        name: "Snowstorm",
        subtitle: "Five frozen tiles scatter the board",
        rows: 5, cols: 5,
        initialValues: [
            [6, 1, 8, 3, 7],
            [4, 9, 5, 2, 6],
            [2, 7, 1, 8, 4],
            [9, 3, 6, 5, 1],
            [5, 8, 2, 9, 3]
        ],
        specialTiles: [
            Position(row: 0, col: 0): .frozen,
            Position(row: 1, col: 2): .frozen,
            Position(row: 2, col: 4): .frozen,
            Position(row: 3, col: 1): .frozen,
            Position(row: 4, col: 3): .frozen
        ],
        driftRule: .standard,
        maxMoves: 18,
        winCondition: .anyComboCount(4),
        allowedCombinations: [.pair, .sequence, .triplet],
        targetSum: nil,
        difficulty: 3,
        hint: "Five frozen anchors diagonal across the board. Build combos using adjacent tiles."
    )

    static let level29 = GameLevel(
        id: 29,
        name: "Backward Flow",
        subtitle: "Reverse drift on 5×5 — form 4 combos",
        rows: 5, cols: 5,
        initialValues: [
            [9, 4, 7, 2, 6],
            [1, 8, 3, 5, 9],
            [5, 2, 8, 1, 4],
            [7, 6, 4, 9, 3],
            [3, 1, 6, 8, 7]
        ],
        specialTiles: [:],
        driftRule: .reverse,
        maxMoves: 18,
        winCondition: .anyComboCount(4),
        allowedCombinations: [.pair, .sequence, .triplet],
        targetSum: nil,
        difficulty: 4,
        hint: "Values fall by 1 each round on this big board. Plan sequences that count down."
    )

    static let level30 = GameLevel(
        id: 30,
        name: "Chapter's End",
        subtitle: "5 combos, all types allowed",
        rows: 5, cols: 5,
        initialValues: [
            [4, 9, 2, 7, 5],
            [8, 1, 6, 3, 9],
            [3, 7, 5, 1, 6],
            [6, 2, 8, 4, 2],
            [1, 5, 3, 9, 8]
        ],
        specialTiles: [:],
        driftRule: .standard,
        maxMoves: 22,
        winCondition: .anyComboCount(5),
        allowedCombinations: [.pair, .sequence, .triplet, .targetSum],
        targetSum: 15,
        difficulty: 4,
        hint: "All combo types allowed. Mix strategies to reach 5 combos efficiently."
    )

    // MARK: - Chapter 4: Storm Season (31–40)

    static let level31 = GameLevel(
        id: 31,
        name: "Three of Clubs",
        subtitle: "3 triplets required",
        rows: 4, cols: 4,
        initialValues: [
            [5, 1, 5, 8],
            [3, 7, 3, 2],
            [9, 5, 4, 9],
            [1, 6, 7, 1]
        ],
        specialTiles: [:],
        driftRule: .standard,
        maxMoves: 14,
        winCondition: .combinationCount(3, type: .triplet),
        allowedCombinations: [.triplet],
        targetSum: nil,
        difficulty: 3,
        hint: "Three triplets needed. Notice repeated values already in the grid — drift will do the rest."
    )

    static let level32 = GameLevel(
        id: 32,
        name: "Chain Reaction",
        subtitle: "3 sequences, consecutive values only",
        rows: 4, cols: 4,
        initialValues: [
            [1, 6, 3, 8],
            [9, 4, 7, 2],
            [5, 2, 9, 5],
            [3, 7, 1, 4]
        ],
        specialTiles: [:],
        driftRule: .standard,
        maxMoves: 14,
        winCondition: .combinationCount(3, type: .sequence),
        allowedCombinations: [.sequence],
        targetSum: nil,
        difficulty: 3,
        hint: "Three sequences needed. Each must be exactly 3 consecutive values. Plan ahead."
    )

    static let level33 = GameLevel(
        id: 33,
        name: "Perfect Sum",
        subtitle: "Hit sum 12 exactly — 3 times",
        rows: 4, cols: 4,
        initialValues: [
            [3, 8, 1, 7],
            [6, 2, 9, 4],
            [5, 7, 3, 8],
            [2, 4, 6, 1]
        ],
        specialTiles: [:],
        driftRule: .standard,
        maxMoves: 14,
        winCondition: .combinationCount(3, type: .targetSum),
        allowedCombinations: [.targetSum],
        targetSum: 12,
        difficulty: 4,
        hint: "Target 12 three times. Try: 3+4+5, 4+4+4, 2+5+5, 1+5+6, 2+4+6."
    )

    static let level34 = GameLevel(
        id: 34,
        name: "Score Rush",
        subtitle: "Reach 60 points before moves run out",
        rows: 5, cols: 5,
        initialValues: [
            [7, 2, 5, 9, 3],
            [1, 8, 4, 6, 7],
            [4, 6, 1, 3, 8],
            [9, 3, 7, 5, 1],
            [5, 1, 9, 2, 6]
        ],
        specialTiles: [:],
        driftRule: .standard,
        maxMoves: 20,
        winCondition: .reachScore(60),
        allowedCombinations: [.pair, .sequence, .triplet, .targetSum],
        targetSum: 15,
        difficulty: 4,
        hint: "Triplets and high-value tiles score more. Focus on big combos to reach 60 points."
    )

    static let level35 = GameLevel(
        id: 35,
        name: "Fortress",
        subtitle: "Navigate 6 locked tiles on the 5×5",
        rows: 5, cols: 5,
        initialValues: [
            [8, 3, 6, 1, 9],
            [5, 4, 2, 7, 5],
            [1, 9, 8, 4, 2],
            [7, 2, 5, 8, 3],
            [4, 6, 3, 9, 7]
        ],
        specialTiles: [
            Position(row: 0, col: 1): .locked,
            Position(row: 0, col: 3): .locked,
            Position(row: 2, col: 1): .locked,
            Position(row: 2, col: 3): .locked,
            Position(row: 4, col: 1): .locked,
            Position(row: 4, col: 3): .locked
        ],
        driftRule: .standard,
        maxMoves: 18,
        winCondition: .anyComboCount(5),
        allowedCombinations: [.pair, .sequence, .triplet],
        targetSum: nil,
        difficulty: 4,
        hint: "Six locks create columns of obstacles. Exploit the free columns and rows."
    )

    static let level36 = GameLevel(
        id: 36,
        name: "Deep Freeze",
        subtitle: "Six frozen tiles hold the grid",
        rows: 5, cols: 5,
        initialValues: [
            [2, 7, 4, 8, 3],
            [9, 5, 1, 6, 9],
            [6, 3, 7, 2, 5],
            [4, 8, 3, 1, 7],
            [1, 2, 9, 5, 4]
        ],
        specialTiles: [
            Position(row: 0, col: 0): .frozen,
            Position(row: 0, col: 4): .frozen,
            Position(row: 1, col: 2): .frozen,
            Position(row: 2, col: 2): .frozen,
            Position(row: 4, col: 0): .frozen,
            Position(row: 4, col: 4): .frozen
        ],
        driftRule: .standard,
        maxMoves: 20,
        winCondition: .anyComboCount(5),
        allowedCombinations: [.pair, .sequence, .triplet],
        targetSum: nil,
        difficulty: 4,
        hint: "Six frozen anchors define the landscape. Use their fixed values as combo endpoints."
    )

    static let level37 = GameLevel(
        id: 37,
        name: "Cold Reversal",
        subtitle: "Reverse drift + four frozen anchors",
        rows: 5, cols: 5,
        initialValues: [
            [6, 1, 8, 3, 7],
            [3, 9, 5, 2, 4],
            [8, 4, 2, 7, 9],
            [1, 6, 9, 4, 2],
            [5, 3, 1, 8, 6]
        ],
        specialTiles: [
            Position(row: 1, col: 1): .frozen,
            Position(row: 1, col: 3): .frozen,
            Position(row: 3, col: 1): .frozen,
            Position(row: 3, col: 3): .frozen
        ],
        driftRule: .reverse,
        maxMoves: 18,
        winCondition: .anyComboCount(5),
        allowedCombinations: [.pair, .sequence, .triplet],
        targetSum: nil,
        difficulty: 4,
        hint: "Values fall AND frozen tiles stay put. Use frozen anchors as fixed sequence endpoints."
    )

    static let level38 = GameLevel(
        id: 38,
        name: "Speed Trial",
        subtitle: "8 combos within 10 rounds",
        rows: 4, cols: 4,
        initialValues: [
            [4, 9, 3, 7],
            [2, 6, 8, 1],
            [5, 1, 4, 9],
            [8, 3, 6, 2]
        ],
        specialTiles: [:],
        driftRule: .standard,
        maxMoves: 20,
        winCondition: .withinRounds(maxRounds: 10, neededCombos: 8),
        allowedCombinations: [.pair, .sequence, .triplet],
        targetSum: nil,
        difficulty: 4,
        hint: "Time matters! Use drift strategically — don't waste moves on bad swaps."
    )

    static let level39 = GameLevel(
        id: 39,
        name: "Fast Lane",
        subtitle: "Top rows +3, frozen midpoints",
        rows: 5, cols: 5,
        initialValues: [
            [3, 7, 1, 5, 9],
            [8, 2, 6, 4, 3],
            [4, 9, 8, 2, 7],
            [1, 5, 3, 9, 4],
            [7, 4, 2, 6, 1]
        ],
        specialTiles: [
            Position(row: 2, col: 1): .frozen,
            Position(row: 2, col: 3): .frozen
        ],
        driftRule: .zone(rowRange: 0...1, colRange: 0...4, amount: 3),
        maxMoves: 20,
        winCondition: .anyComboCount(5),
        allowedCombinations: [.pair, .sequence, .triplet, .targetSum],
        targetSum: 15,
        difficulty: 4,
        hint: "Top rows race ahead at +3. The speed gap creates unique combo windows."
    )

    static let level40 = GameLevel(
        id: 40,
        name: "Crossroads",
        subtitle: "Zone drift + edge locks: 6 combos",
        rows: 5, cols: 5,
        initialValues: [
            [5, 2, 9, 4, 8],
            [3, 7, 1, 6, 3],
            [8, 4, 5, 2, 7],
            [1, 6, 3, 8, 1],
            [9, 3, 7, 5, 4]
        ],
        specialTiles: [
            Position(row: 1, col: 0): .locked,
            Position(row: 1, col: 4): .locked,
            Position(row: 3, col: 0): .locked,
            Position(row: 3, col: 4): .locked
        ],
        driftRule: .zone(rowRange: 0...2, colRange: 0...4, amount: 2),
        maxMoves: 22,
        winCondition: .anyComboCount(6),
        allowedCombinations: [.pair, .sequence, .triplet, .targetSum],
        targetSum: 15,
        difficulty: 4,
        hint: "Upper half drifts faster while side tiles are locked. Exploit the speed gap."
    )

    // MARK: - Chapter 5: Dragon's Gate (41–50)

    static let level41 = GameLevel(
        id: 41,
        name: "Dragon Rising",
        subtitle: "Reverse drift + 6 locked tiles",
        rows: 5, cols: 5,
        initialValues: [
            [7, 4, 9, 2, 6],
            [3, 8, 5, 1, 7],
            [9, 2, 6, 4, 3],
            [5, 1, 8, 7, 9],
            [2, 6, 3, 5, 1]
        ],
        specialTiles: [
            Position(row: 0, col: 1): .locked,
            Position(row: 0, col: 3): .locked,
            Position(row: 2, col: 0): .locked,
            Position(row: 2, col: 4): .locked,
            Position(row: 4, col: 1): .locked,
            Position(row: 4, col: 3): .locked
        ],
        driftRule: .reverse,
        maxMoves: 22,
        winCondition: .anyComboCount(6),
        allowedCombinations: [.pair, .sequence, .triplet],
        targetSum: nil,
        difficulty: 5,
        hint: "Falling values plus many locks. Find the open corridors and exploit them fast."
    )

    static let level42 = GameLevel(
        id: 42,
        name: "Heaven's Gate",
        subtitle: "Zone + locked + frozen: all at once",
        rows: 5, cols: 5,
        initialValues: [
            [4, 8, 2, 7, 5],
            [9, 3, 6, 1, 9],
            [6, 5, 3, 8, 2],
            [2, 1, 9, 4, 6],
            [7, 4, 7, 3, 8]
        ],
        specialTiles: [
            Position(row: 0, col: 2): .locked,
            Position(row: 1, col: 1): .frozen,
            Position(row: 2, col: 0): .frozen,
            Position(row: 2, col: 4): .frozen,
            Position(row: 4, col: 2): .locked
        ],
        driftRule: .zone(rowRange: 0...1, colRange: 0...4, amount: 2),
        maxMoves: 24,
        winCondition: .anyComboCount(6),
        allowedCombinations: [.pair, .sequence, .triplet, .targetSum],
        targetSum: 15,
        difficulty: 5,
        hint: "Three mechanics at once. Map out frozen anchors, avoid locks, ride the zone speed."
    )

    static let level43 = GameLevel(
        id: 43,
        name: "Seven Stars",
        subtitle: "Reach 7 combos on the 5×5",
        rows: 5, cols: 5,
        initialValues: [
            [2, 6, 9, 4, 1],
            [7, 3, 5, 8, 7],
            [5, 1, 4, 2, 9],
            [8, 9, 7, 6, 3],
            [3, 4, 1, 5, 8]
        ],
        specialTiles: [:],
        driftRule: .standard,
        maxMoves: 24,
        winCondition: .anyComboCount(7),
        allowedCombinations: [.pair, .sequence, .triplet, .targetSum],
        targetSum: 15,
        difficulty: 5,
        hint: "Seven combos — use every combo type available to maximize efficiency."
    )

    static let level44 = GameLevel(
        id: 44,
        name: "Tight Window",
        subtitle: "6 combos within only 8 rounds",
        rows: 5, cols: 5,
        initialValues: [
            [5, 9, 3, 7, 2],
            [1, 6, 8, 4, 5],
            [7, 2, 5, 1, 8],
            [4, 8, 2, 9, 3],
            [9, 3, 6, 5, 1]
        ],
        specialTiles: [:],
        driftRule: .standard,
        maxMoves: 24,
        winCondition: .withinRounds(maxRounds: 8, neededCombos: 6),
        allowedCombinations: [.pair, .sequence, .triplet, .targetSum],
        targetSum: 15,
        difficulty: 5,
        hint: "Only 8 rounds! Prioritize combos over perfect positioning — every round must count."
    )

    static let level45 = GameLevel(
        id: 45,
        name: "Triple Crown",
        subtitle: "4 triplets — drift is your only tool",
        rows: 5, cols: 5,
        initialValues: [
            [3, 7, 3, 8, 5],
            [6, 2, 6, 1, 6],
            [9, 4, 2, 7, 3],
            [5, 8, 9, 4, 9],
            [1, 3, 5, 2, 7]
        ],
        specialTiles: [:],
        driftRule: .standard,
        maxMoves: 22,
        winCondition: .combinationCount(4, type: .triplet),
        allowedCombinations: [.triplet],
        targetSum: nil,
        difficulty: 5,
        hint: "Four triplets is demanding. Drift steadily converges values — trust the process."
    )

    static let level46 = GameLevel(
        id: 46,
        name: "Score Hunter",
        subtitle: "Reach 80 points — score big combos",
        rows: 5, cols: 5,
        initialValues: [
            [8, 3, 7, 1, 5],
            [2, 9, 4, 6, 8],
            [6, 5, 2, 9, 3],
            [4, 1, 8, 3, 7],
            [9, 7, 6, 4, 1]
        ],
        specialTiles: [:],
        driftRule: .standard,
        maxMoves: 22,
        winCondition: .reachScore(80),
        allowedCombinations: [.pair, .sequence, .triplet, .targetSum],
        targetSum: 15,
        difficulty: 5,
        hint: "High-value tiles score more. Aim for triplets with 7-8-9 tiles."
    )

    static let level47 = GameLevel(
        id: 47,
        name: "Eight Pillars",
        subtitle: "8 combos — an endurance test",
        rows: 5, cols: 5,
        initialValues: [
            [1, 7, 4, 9, 2],
            [6, 3, 8, 5, 6],
            [4, 9, 1, 3, 7],
            [8, 2, 6, 1, 4],
            [3, 5, 7, 8, 9]
        ],
        specialTiles: [:],
        driftRule: .standard,
        maxMoves: 26,
        winCondition: .anyComboCount(8),
        allowedCombinations: [.pair, .sequence, .triplet, .targetSum],
        targetSum: 15,
        difficulty: 5,
        hint: "Eight is a lot. Methodically build combos across the whole board — don't rush."
    )

    static let level48 = GameLevel(
        id: 48,
        name: "Storm Surge",
        subtitle: "Zone + frozen: bottom rows surge",
        rows: 5, cols: 5,
        initialValues: [
            [9, 5, 2, 7, 4],
            [3, 8, 6, 1, 9],
            [7, 2, 8, 5, 3],
            [4, 6, 1, 9, 7],
            [1, 4, 7, 3, 5]
        ],
        specialTiles: [
            Position(row: 0, col: 0): .frozen,
            Position(row: 2, col: 2): .frozen,
            Position(row: 4, col: 4): .frozen
        ],
        driftRule: .zone(rowRange: 3...4, colRange: 0...4, amount: 2),
        maxMoves: 22,
        winCondition: .anyComboCount(6),
        allowedCombinations: [.pair, .sequence, .triplet, .targetSum],
        targetSum: 15,
        difficulty: 5,
        hint: "Bottom rows surge at +2. Frozen anchors hold steady. Exploit the speed difference."
    )

    static let level49 = GameLevel(
        id: 49,
        name: "Labyrinth",
        subtitle: "Locked + frozen + zone: find the path",
        rows: 5, cols: 5,
        initialValues: [
            [6, 2, 8, 4, 9],
            [3, 7, 5, 1, 6],
            [9, 4, 2, 7, 3],
            [5, 1, 9, 3, 8],
            [2, 8, 4, 6, 1]
        ],
        specialTiles: [
            Position(row: 0, col: 1): .locked,
            Position(row: 0, col: 3): .locked,
            Position(row: 1, col: 2): .frozen,
            Position(row: 3, col: 2): .frozen,
            Position(row: 4, col: 1): .locked,
            Position(row: 4, col: 3): .locked
        ],
        driftRule: .zone(rowRange: 0...2, colRange: 0...4, amount: 2),
        maxMoves: 24,
        winCondition: .anyComboCount(7),
        allowedCombinations: [.pair, .sequence, .triplet, .targetSum],
        targetSum: 15,
        difficulty: 5,
        hint: "Locked edges, frozen midpoints, fast top half. Map the free paths before moving."
    )

    static let level50 = GameLevel(
        id: 50,
        name: "Final Journey",
        subtitle: "All mechanics — form 8 combos",
        rows: 5, cols: 5,
        initialValues: [
            [7, 3, 9, 5, 1],
            [4, 8, 2, 6, 4],
            [1, 5, 7, 3, 8],
            [9, 2, 4, 8, 5],
            [6, 9, 1, 7, 2]
        ],
        specialTiles: [
            Position(row: 0, col: 0): .locked,
            Position(row: 0, col: 4): .locked,
            Position(row: 2, col: 2): .frozen,
            Position(row: 4, col: 0): .locked,
            Position(row: 4, col: 4): .locked
        ],
        driftRule: .zone(rowRange: 0...1, colRange: 0...4, amount: 2),
        maxMoves: 28,
        winCondition: .anyComboCount(8),
        allowedCombinations: [.pair, .sequence, .triplet, .targetSum],
        targetSum: 15,
        difficulty: 5,
        hint: "Everything you've learned is needed here. Stay calm, read the board, and execute."
    )

    // MARK: - Chapter 6: Master's Trial (51–60)

    static let level51 = GameLevel(
        id: 51,
        name: "The Gauntlet",
        subtitle: "Top & bottom edge locks: 6 combos",
        rows: 5, cols: 5,
        initialValues: [
            [3, 8, 5, 1, 7],
            [6, 2, 9, 4, 3],
            [8, 5, 3, 7, 6],
            [1, 9, 6, 2, 9],
            [4, 7, 1, 8, 2]
        ],
        specialTiles: [
            Position(row: 0, col: 0): .locked,
            Position(row: 0, col: 2): .locked,
            Position(row: 0, col: 4): .locked,
            Position(row: 4, col: 0): .locked,
            Position(row: 4, col: 2): .locked,
            Position(row: 4, col: 4): .locked
        ],
        driftRule: .standard,
        maxMoves: 20,
        winCondition: .anyComboCount(6),
        allowedCombinations: [.pair, .sequence, .triplet, .targetSum],
        targetSum: 15,
        difficulty: 5,
        hint: "Top and bottom edges locked. Use the three middle rows as your main arena."
    )

    static let level52 = GameLevel(
        id: 52,
        name: "Race Against Time",
        subtitle: "5 combos in just 7 rounds",
        rows: 5, cols: 5,
        initialValues: [
            [2, 5, 8, 3, 6],
            [9, 1, 4, 7, 2],
            [5, 8, 2, 6, 9],
            [3, 6, 9, 1, 4],
            [7, 4, 1, 5, 8]
        ],
        specialTiles: [:],
        driftRule: .standard,
        maxMoves: 22,
        winCondition: .withinRounds(maxRounds: 7, neededCombos: 5),
        allowedCombinations: [.pair, .sequence, .triplet],
        targetSum: nil,
        difficulty: 5,
        hint: "Seven rounds maximum. Look for near-miss combos at the start — just one swap away."
    )

    static let level53 = GameLevel(
        id: 53,
        name: "Sequence Master",
        subtitle: "5 sequences — no other combos",
        rows: 5, cols: 5,
        initialValues: [
            [4, 7, 1, 9, 5],
            [2, 8, 6, 3, 1],
            [9, 3, 4, 7, 8],
            [6, 1, 8, 2, 4],
            [5, 9, 3, 6, 2]
        ],
        specialTiles: [:],
        driftRule: .standard,
        maxMoves: 24,
        winCondition: .combinationCount(5, type: .sequence),
        allowedCombinations: [.sequence],
        targetSum: nil,
        difficulty: 5,
        hint: "Five sequences is the entire win condition. Remember: 9-1-2 wraps also count."
    )

    static let level54 = GameLevel(
        id: 54,
        name: "Century Score",
        subtitle: "Reach 100 points — score efficiently",
        rows: 5, cols: 5,
        initialValues: [
            [9, 4, 7, 2, 8],
            [5, 1, 6, 9, 3],
            [3, 8, 5, 4, 7],
            [7, 6, 2, 8, 1],
            [1, 3, 9, 5, 6]
        ],
        specialTiles: [:],
        driftRule: .standard,
        maxMoves: 26,
        winCondition: .reachScore(100),
        allowedCombinations: [.pair, .sequence, .triplet, .targetSum],
        targetSum: 15,
        difficulty: 5,
        hint: "100 points. Triplets of 7, 8, 9 score highest. Chain multiple combos per round."
    )

    static let level55 = GameLevel(
        id: 55,
        name: "The Grind",
        subtitle: "Eight frozen anchors — 8 combos",
        rows: 5, cols: 5,
        initialValues: [
            [5, 9, 3, 7, 2],
            [8, 1, 6, 4, 8],
            [3, 7, 9, 2, 5],
            [6, 4, 1, 8, 3],
            [2, 5, 8, 1, 9]
        ],
        specialTiles: [
            Position(row: 0, col: 0): .frozen,
            Position(row: 0, col: 2): .frozen,
            Position(row: 0, col: 4): .frozen,
            Position(row: 2, col: 1): .frozen,
            Position(row: 2, col: 3): .frozen,
            Position(row: 4, col: 0): .frozen,
            Position(row: 4, col: 2): .frozen,
            Position(row: 4, col: 4): .frozen
        ],
        driftRule: .standard,
        maxMoves: 26,
        winCondition: .anyComboCount(8),
        allowedCombinations: [.pair, .sequence, .triplet],
        targetSum: nil,
        difficulty: 5,
        hint: "Eight frozen anchors — scattered to give maximum reference points. Use them all."
    )

    static let level56 = GameLevel(
        id: 56,
        name: "Reverse Storm",
        subtitle: "Reverse drift + 6 locks: 7 combos",
        rows: 5, cols: 5,
        initialValues: [
            [8, 5, 2, 9, 4],
            [1, 7, 4, 6, 1],
            [6, 3, 8, 2, 7],
            [4, 9, 1, 5, 3],
            [2, 6, 7, 8, 9]
        ],
        specialTiles: [
            Position(row: 0, col: 1): .locked,
            Position(row: 1, col: 0): .locked,
            Position(row: 1, col: 4): .locked,
            Position(row: 3, col: 0): .locked,
            Position(row: 3, col: 4): .locked,
            Position(row: 4, col: 3): .locked
        ],
        driftRule: .reverse,
        maxMoves: 24,
        winCondition: .anyComboCount(7),
        allowedCombinations: [.pair, .sequence, .triplet],
        targetSum: nil,
        difficulty: 5,
        hint: "Falling values and many obstacles. Every swap must create future opportunities."
    )

    static let level57 = GameLevel(
        id: 57,
        name: "Triplet Summit",
        subtitle: "5 triplets on the grand board",
        rows: 5, cols: 5,
        initialValues: [
            [4, 1, 7, 4, 8],
            [2, 9, 5, 2, 6],
            [7, 4, 3, 9, 1],
            [5, 8, 6, 5, 3],
            [9, 2, 8, 7, 5]
        ],
        specialTiles: [:],
        driftRule: .standard,
        maxMoves: 26,
        winCondition: .combinationCount(5, type: .triplet),
        allowedCombinations: [.triplet],
        targetSum: nil,
        difficulty: 5,
        hint: "Five triplets. Notice repeated values in the initial layout — some triplets are close."
    )

    static let level58 = GameLevel(
        id: 58,
        name: "Precision Strike",
        subtitle: "5 combos in 6 rounds",
        rows: 5, cols: 5,
        initialValues: [
            [6, 2, 7, 4, 9],
            [3, 8, 5, 1, 6],
            [9, 4, 3, 7, 2],
            [5, 1, 9, 8, 4],
            [7, 6, 2, 3, 8]
        ],
        specialTiles: [:],
        driftRule: .standard,
        maxMoves: 24,
        winCondition: .withinRounds(maxRounds: 6, neededCombos: 5),
        allowedCombinations: [.pair, .sequence, .triplet, .targetSum],
        targetSum: 15,
        difficulty: 5,
        hint: "Six rounds only. Find combos that are one move away at the start, then chain quickly."
    )

    static let level59 = GameLevel(
        id: 59,
        name: "The Final Wall",
        subtitle: "Locks + frozen + zone drift: 7 combos",
        rows: 5, cols: 5,
        initialValues: [
            [7, 3, 9, 5, 2],
            [4, 8, 1, 7, 6],
            [2, 6, 4, 3, 9],
            [8, 1, 7, 9, 5],
            [5, 4, 2, 6, 1]
        ],
        specialTiles: [
            Position(row: 0, col: 0): .locked,
            Position(row: 0, col: 4): .locked,
            Position(row: 1, col: 2): .frozen,
            Position(row: 2, col: 0): .frozen,
            Position(row: 2, col: 4): .frozen,
            Position(row: 3, col: 2): .frozen,
            Position(row: 4, col: 0): .locked,
            Position(row: 4, col: 4): .locked
        ],
        driftRule: .zone(rowRange: 0...2, colRange: 0...4, amount: 2),
        maxMoves: 26,
        winCondition: .anyComboCount(7),
        allowedCombinations: [.pair, .sequence, .triplet, .targetSum],
        targetSum: 15,
        difficulty: 5,
        hint: "The most constrained board yet. Every free tile is precious — make each swap count."
    )

    static let level60 = GameLevel(
        id: 60,
        name: "Drift Master Reborn",
        subtitle: "The ultimate challenge — 10 combos",
        rows: 5, cols: 5,
        initialValues: [
            [1, 8, 3, 6, 9],
            [5, 2, 7, 4, 1],
            [9, 6, 1, 8, 5],
            [3, 7, 5, 2, 7],
            [8, 4, 9, 3, 6]
        ],
        specialTiles: [
            Position(row: 0, col: 2): .locked,
            Position(row: 1, col: 0): .frozen,
            Position(row: 1, col: 4): .frozen,
            Position(row: 2, col: 2): .locked,
            Position(row: 3, col: 0): .frozen,
            Position(row: 3, col: 4): .frozen,
            Position(row: 4, col: 2): .locked
        ],
        driftRule: .zone(rowRange: 0...1, colRange: 0...4, amount: 2),
        maxMoves: 30,
        winCondition: .anyComboCount(10),
        allowedCombinations: [.pair, .sequence, .triplet, .targetSum],
        targetSum: 15,
        difficulty: 5,
        hint: "Ten combos. All mechanics active. This is everything — show what you've mastered."
    )
}
