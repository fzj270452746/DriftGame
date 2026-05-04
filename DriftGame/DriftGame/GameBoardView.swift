//
//  GameBoardView.swift
//  DriftGame
//
//  棋盘视图：动态布局 TileView 网格，处理点击/长按手势
//

import UIKit

protocol GameBoardViewDelegate: AnyObject {
    func gameBoardView(_ view: GameBoardView, didTapAt position: Position)
    func gameBoardView(_ view: GameBoardView, didLongPressAt position: Position)
    func gameBoardViewDidEndLongPress(_ view: GameBoardView)
}

class GameBoardView: UIView {

    weak var delegate: GameBoardViewDelegate?

    // MARK: - State
    private var tileViews: [[TileView?]] = []
    private var rows: Int = 0
    private var cols: Int = 0
    private let gap: CGFloat = 6

    // MARK: - Setup Board

    func configure(rows: Int, cols: Int) {
        self.rows = rows
        self.cols = cols

        // Remove old views
        subviews.forEach { $0.removeFromSuperview() }
        tileViews = Array(repeating: Array(repeating: nil, count: cols), count: rows)

        // Create tile views
        for r in 0..<rows {
            for c in 0..<cols {
                let tv = TileView()
                tv.isUserInteractionEnabled = true

                // Tap
                let tap = UITapGestureRecognizer(target: self, action: #selector(handleTap(_:)))
                tv.addGestureRecognizer(tap)

                // Long Press
                let lp = UILongPressGestureRecognizer(target: self, action: #selector(handleLongPress(_:)))
                lp.minimumPressDuration = 0.4
                tv.addGestureRecognizer(lp)

                addSubview(tv)
                tileViews[r][c] = tv
            }
        }
    }

    // MARK: - Layout

    override func layoutSubviews() {
        super.layoutSubviews()
        guard rows > 0, cols > 0 else { return }

        let totalGapH = gap * CGFloat(cols - 1)
        let totalGapV = gap * CGFloat(rows - 1)
        let tileW = (bounds.width - totalGapH) / CGFloat(cols)
        let tileH = (bounds.height - totalGapV) / CGFloat(rows)

        for r in 0..<rows {
            for c in 0..<cols {
                let x = CGFloat(c) * (tileW + gap)
                let y = CGFloat(r) * (tileH + gap)
                tileViews[r][c]?.frame = CGRect(x: x, y: y, width: tileW, height: tileH)
            }
        }
    }

    // MARK: - Update from Engine

    func updateBoard(_ board: [[Tile?]]) {
        guard board.count == rows else { return }
        for r in 0..<rows {
            guard board[r].count == cols else { continue }
            for c in 0..<cols {
                tileViews[r][c]?.tile = board[r][c]
            }
        }
    }

    func setSelected(_ pos: Position?) {
        for r in 0..<rows {
            for c in 0..<cols {
                tileViews[r][c]?.isSelected = (pos != nil && pos!.row == r && pos!.col == c)
            }
        }
    }

    func setHighlighted(_ combos: [DetectedCombination]) {
        // Reset all
        for r in 0..<rows {
            for c in 0..<cols {
                tileViews[r][c]?.isHighlighted = false
            }
        }
        // Highlight combo positions
        for combo in combos {
            for pos in combo.positions {
                tileViews[pos.row][pos.col]?.isHighlighted = true
                tileViews[pos.row][pos.col]?.animateCombinationFlash()
            }
        }
    }

    func showPreview(_ engine: GameEngine) {
        for r in 0..<rows {
            for c in 0..<cols {
                let pos = Position(row: r, col: c)
                tileViews[r][c]?.previewValue = engine.previewNextValue(at: pos)
            }
        }
    }

    func hidePreview() {
        for r in 0..<rows {
            for c in 0..<cols {
                tileViews[r][c]?.previewValue = nil
            }
        }
    }

    // MARK: - Drift Animation

    func animateDrift(newBoard: [[Tile?]], completion: (() -> Void)? = nil) {
        var count = rows * cols
        if count == 0 { completion?(); return }

        for r in 0..<rows {
            for c in 0..<cols {
                guard let tv = tileViews[r][c], let newTile = newBoard[r][c] else {
                    count -= 1
                    if count == 0 { completion?() }
                    continue
                }
                let delay = Double(r * cols + c) * 0.03
                DispatchQueue.main.asyncAfter(deadline: .now() + delay) {
                    tv.animateDrift(to: newTile.value) {
                        count -= 1
                        if count == 0 { completion?() }
                    }
                }
            }
        }
    }

    // MARK: - Pulse Animation (round transition)

    func animatePulse() {
        UIView.animateKeyframes(withDuration: 0.5, delay: 0, options: [], animations: {
            UIView.addKeyframe(withRelativeStartTime: 0, relativeDuration: 0.4) {
                self.transform = CGAffineTransform(scaleX: 1.04, y: 1.04)
                self.alpha = 0.85
            }
            UIView.addKeyframe(withRelativeStartTime: 0.4, relativeDuration: 0.6) {
                self.transform = .identity
                self.alpha = 1
            }
        })
    }

    // MARK: - Gesture Handlers

    @objc private func handleTap(_ gr: UITapGestureRecognizer) {
        guard let tv = gr.view as? TileView else { return }
        if let pos = position(of: tv) {
            if tv.tile?.isLocked == true {
                tv.animateShake()
            } else {
                delegate?.gameBoardView(self, didTapAt: pos)
            }
        }
    }

    @objc private func handleLongPress(_ gr: UILongPressGestureRecognizer) {
        guard let tv = gr.view as? TileView else { return }
        if gr.state == .began {
            if let pos = position(of: tv) {
                delegate?.gameBoardView(self, didLongPressAt: pos)
            }
        } else if gr.state == .ended || gr.state == .cancelled {
            delegate?.gameBoardViewDidEndLongPress(self)
        }
    }

    private func position(of view: TileView) -> Position? {
        for r in 0..<rows {
            for c in 0..<cols {
                if tileViews[r][c] === view {
                    return Position(row: r, col: c)
                }
            }
        }
        return nil
    }
}
