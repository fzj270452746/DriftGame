//
//  GameViewController.swift
//  DriftGame
//
//  游戏主界面：棋盘、状态栏、操作按钮、胜负弹窗、漂移动画
//

import UIKit

class GameViewController: UIViewController {

    // MARK: - Engine
    private let engine: GameEngine
    private let level: GameLevel

    // MARK: - UI
    private let bgLayer         = CAGradientLayer()
    private let headerView      = UIView()
    private let levelNameLabel  = UILabel()
    private let roundLabel      = UILabel()
    private let movesLabel      = UILabel()
    private let objectiveCard   = UIView()
    private let objectiveLabel  = UILabel()
    private let comboCountLabel = UILabel()
    private let boardContainer  = UIView()
    private let boardView       = GameBoardView()
    private let driftRuleLabel  = UILabel()
    private let endRoundButton  = UIButton(type: .system)
    private let previewToggleBtn = UIButton(type: .system)
    private let hintButton      = UIButton(type: .system)
    private let overlayView     = UIView()

    private var isPreviewOn = false
    private var isDrifting = false

    // MARK: - Init

    init(level: GameLevel) {
        self.level = level
        self.engine = GameEngine(level: level)
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) { fatalError() }

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        engine.delegate = self
        setupBackground()
        setupNavigationBar()
        setupHeader()
        setupObjectiveCard()
        setupBoard()
        setupDriftRuleLabel()
        setupActionButtons()
        setupOverlay()
        refreshUI()

        // Initial combination check
        engine.refreshCombinations()
        boardView.setHighlighted(engine.detectedCombinations)
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        bgLayer.frame = view.bounds
        layoutBoard()
    }

    // MARK: - Background

    private func setupBackground() {
        bgLayer.colors = [
            UIColor(red: 0.07, green: 0.07, blue: 0.18, alpha: 1).cgColor,
            UIColor(red: 0.10, green: 0.04, blue: 0.22, alpha: 1).cgColor
        ]
        bgLayer.startPoint = CGPoint(x: 0, y: 0)
        bgLayer.endPoint = CGPoint(x: 1, y: 1)
        view.layer.insertSublayer(bgLayer, at: 0)
    }

    // MARK: - Navigation

    private func setupNavigationBar() {
        navigationController?.setNavigationBarHidden(true, animated: false)
    }

    // MARK: - Header

    private func setupHeader() {
        headerView.backgroundColor = UIColor.white.withAlphaComponent(0.06)
        headerView.layer.cornerRadius = 0
        headerView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(headerView)

        // Back button
        let backBtn = UIButton(type: .system)
        backBtn.setImage(UIImage(systemName: "chevron.left"), for: .normal)
        backBtn.tintColor = .white
        backBtn.addTarget(self, action: #selector(goBack), for: .touchUpInside)
        backBtn.translatesAutoresizingMaskIntoConstraints = false
        headerView.addSubview(backBtn)

        // Level name
        levelNameLabel.font = UIFont.systemFont(ofSize: 17, weight: .bold)
        levelNameLabel.textColor = .white
        levelNameLabel.textAlignment = .center
        levelNameLabel.translatesAutoresizingMaskIntoConstraints = false
        headerView.addSubview(levelNameLabel)

        // Round info
        roundLabel.font = UIFont.monospacedDigitSystemFont(ofSize: 13, weight: .medium)
        roundLabel.textColor = UIColor.white.withAlphaComponent(0.7)
        roundLabel.textAlignment = .right
        roundLabel.translatesAutoresizingMaskIntoConstraints = false
        headerView.addSubview(roundLabel)

        NSLayoutConstraint.activate([
            headerView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            headerView.leftAnchor.constraint(equalTo: view.leftAnchor),
            headerView.rightAnchor.constraint(equalTo: view.rightAnchor),
            headerView.heightAnchor.constraint(equalToConstant: 52),

            backBtn.centerYAnchor.constraint(equalTo: headerView.centerYAnchor),
            backBtn.leftAnchor.constraint(equalTo: headerView.leftAnchor, constant: 16),
            backBtn.widthAnchor.constraint(equalToConstant: 36),

            levelNameLabel.centerYAnchor.constraint(equalTo: headerView.centerYAnchor),
            levelNameLabel.centerXAnchor.constraint(equalTo: headerView.centerXAnchor),

            roundLabel.centerYAnchor.constraint(equalTo: headerView.centerYAnchor),
            roundLabel.rightAnchor.constraint(equalTo: headerView.rightAnchor, constant: -16)
        ])
    }

    // MARK: - Objective Card

    private func setupObjectiveCard() {
        objectiveCard.backgroundColor = UIColor.white.withAlphaComponent(0.08)
        objectiveCard.layer.cornerRadius = 14
        objectiveCard.layer.borderWidth = 1
        objectiveCard.layer.borderColor = UIColor.white.withAlphaComponent(0.12).cgColor
        objectiveCard.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(objectiveCard)

        objectiveLabel.font = UIFont.systemFont(ofSize: 13, weight: .medium)
        objectiveLabel.textColor = UIColor.white.withAlphaComponent(0.8)
        objectiveLabel.numberOfLines = 2
        objectiveLabel.textAlignment = .center
        objectiveLabel.translatesAutoresizingMaskIntoConstraints = false
        objectiveCard.addSubview(objectiveLabel)

        // Moves display
        movesLabel.font = UIFont.monospacedDigitSystemFont(ofSize: 22, weight: .black)
        movesLabel.textColor = .white
        movesLabel.textAlignment = .center
        movesLabel.translatesAutoresizingMaskIntoConstraints = false
        objectiveCard.addSubview(movesLabel)

        // Combo count
        comboCountLabel.font = UIFont.systemFont(ofSize: 13, weight: .semibold)
        comboCountLabel.textColor = UIColor(red: 0.2, green: 1.0, blue: 0.5, alpha: 0.9)
        comboCountLabel.textAlignment = .center
        comboCountLabel.translatesAutoresizingMaskIntoConstraints = false
        objectiveCard.addSubview(comboCountLabel)

        NSLayoutConstraint.activate([
            objectiveCard.topAnchor.constraint(equalTo: headerView.bottomAnchor, constant: 10),
            objectiveCard.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 16),
            objectiveCard.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -16),
            objectiveCard.heightAnchor.constraint(equalToConstant: 70),

            movesLabel.centerYAnchor.constraint(equalTo: objectiveCard.centerYAnchor),
            movesLabel.leftAnchor.constraint(equalTo: objectiveCard.leftAnchor, constant: 20),
            movesLabel.widthAnchor.constraint(equalToConstant: 60),

            objectiveLabel.centerYAnchor.constraint(equalTo: objectiveCard.centerYAnchor, constant: -8),
            objectiveLabel.centerXAnchor.constraint(equalTo: objectiveCard.centerXAnchor),
            objectiveLabel.leftAnchor.constraint(equalTo: movesLabel.rightAnchor, constant: 8),
            objectiveLabel.rightAnchor.constraint(equalTo: comboCountLabel.leftAnchor, constant: -8),

            comboCountLabel.centerYAnchor.constraint(equalTo: objectiveCard.centerYAnchor),
            comboCountLabel.rightAnchor.constraint(equalTo: objectiveCard.rightAnchor, constant: -20),
            comboCountLabel.widthAnchor.constraint(equalToConstant: 70)
        ])
    }

    // MARK: - Board

    private func setupBoard() {
        boardContainer.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(boardContainer)
        boardView.delegate = self
        boardView.translatesAutoresizingMaskIntoConstraints = false
        boardContainer.addSubview(boardView)

        NSLayoutConstraint.activate([
            boardContainer.topAnchor.constraint(equalTo: objectiveCard.bottomAnchor, constant: 16),
            boardContainer.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 16),
            boardContainer.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -16)
        ])

        NSLayoutConstraint.activate([
            boardView.topAnchor.constraint(equalTo: boardContainer.topAnchor),
            boardView.bottomAnchor.constraint(equalTo: boardContainer.bottomAnchor),
            boardView.leftAnchor.constraint(equalTo: boardContainer.leftAnchor),
            boardView.rightAnchor.constraint(equalTo: boardContainer.rightAnchor)
        ])

        boardView.configure(rows: level.rows, cols: level.cols)
        boardView.updateBoard(engine.board)
    }

    private func layoutBoard() {
        let safeH = view.bounds.height - view.safeAreaInsets.top - view.safeAreaInsets.bottom
        let fixedUI: CGFloat = 52 + 10 + 70 + 16 + 24 + 16 + 120 + 16
        let availableH = safeH - fixedUI
        let boardSide = min(availableH, view.bounds.width - 32)

        // Update boardContainer height
        for constraint in boardContainer.constraints {
            if constraint.firstAttribute == .height {
                boardContainer.removeConstraint(constraint)
            }
        }
        boardContainer.heightAnchor.constraint(equalToConstant: boardSide).isActive = true
    }

    // MARK: - Drift Rule Label

    private func setupDriftRuleLabel() {
        driftRuleLabel.font = UIFont.systemFont(ofSize: 12, weight: .medium)
        driftRuleLabel.textColor = UIColor.white.withAlphaComponent(0.5)
        driftRuleLabel.textAlignment = .center
        driftRuleLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(driftRuleLabel)

        NSLayoutConstraint.activate([
            driftRuleLabel.topAnchor.constraint(equalTo: boardContainer.bottomAnchor, constant: 8),
            driftRuleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])

        switch level.driftRule {
        case .standard:   driftRuleLabel.text = "Drift rule: +1 each round (9→1)"
        case .reverse:    driftRuleLabel.text = "Drift rule: −1 each round (1→9)"
        case .randomDrift: driftRuleLabel.text = "Drift rule: random ±1"
        case .zone:       driftRuleLabel.text = "Drift rule: dual-speed zone (top +2, bottom +1)"
        case .delayed:    driftRuleLabel.text = "Drift rule: delayed drift"
        case .mixed:      driftRuleLabel.text = "Drift rule: mixed mode"
        }
    }

    // MARK: - Action Buttons

    private func setupActionButtons() {
        // End Round button
        endRoundButton.setTitle("Next Round  +1", for: .normal)
        endRoundButton.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .bold)
        endRoundButton.backgroundColor = UIColor(red: 0.45, green: 0.25, blue: 0.90, alpha: 1)
        endRoundButton.setTitleColor(.white, for: .normal)
        endRoundButton.layer.cornerRadius = 14
        endRoundButton.layer.shadowColor = UIColor(red: 0.45, green: 0.25, blue: 0.90, alpha: 1).cgColor
        endRoundButton.layer.shadowOpacity = 0.5
        endRoundButton.layer.shadowRadius = 8
        endRoundButton.layer.shadowOffset = CGSize(width: 0, height: 3)
        endRoundButton.addTarget(self, action: #selector(endRoundTapped), for: .touchUpInside)
        endRoundButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(endRoundButton)

        // Preview toggle
        previewToggleBtn.setTitle("Preview", for: .normal)
        previewToggleBtn.setImage(UIImage(systemName: "eye.fill"), for: .normal)
        previewToggleBtn.tintColor = UIColor.white.withAlphaComponent(0.8)
        previewToggleBtn.titleLabel?.font = UIFont.systemFont(ofSize: 13, weight: .medium)
        previewToggleBtn.backgroundColor = UIColor.white.withAlphaComponent(0.1)
        previewToggleBtn.setTitleColor(UIColor.white.withAlphaComponent(0.8), for: .normal)
        previewToggleBtn.layer.cornerRadius = 12
        previewToggleBtn.layer.borderWidth = 1
        previewToggleBtn.layer.borderColor = UIColor.white.withAlphaComponent(0.2).cgColor
        previewToggleBtn.addTarget(self, action: #selector(togglePreview), for: .touchUpInside)
        previewToggleBtn.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(previewToggleBtn)

        // Hint
        hintButton.setTitle("Hint", for: .normal)
        hintButton.setImage(UIImage(systemName: "lightbulb.fill"), for: .normal)
        hintButton.tintColor = UIColor.white.withAlphaComponent(0.8)
        hintButton.titleLabel?.font = UIFont.systemFont(ofSize: 13, weight: .medium)
        hintButton.backgroundColor = UIColor.white.withAlphaComponent(0.1)
        hintButton.setTitleColor(UIColor.white.withAlphaComponent(0.8), for: .normal)
        hintButton.layer.cornerRadius = 12
        hintButton.layer.borderWidth = 1
        hintButton.layer.borderColor = UIColor.white.withAlphaComponent(0.2).cgColor
        hintButton.addTarget(self, action: #selector(showHint), for: .touchUpInside)
        hintButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(hintButton)

        NSLayoutConstraint.activate([
            endRoundButton.topAnchor.constraint(equalTo: driftRuleLabel.bottomAnchor, constant: 14),
            endRoundButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            endRoundButton.widthAnchor.constraint(equalToConstant: 200),
            endRoundButton.heightAnchor.constraint(equalToConstant: 52),

            previewToggleBtn.topAnchor.constraint(equalTo: endRoundButton.bottomAnchor, constant: 10),
            previewToggleBtn.rightAnchor.constraint(equalTo: view.centerXAnchor, constant: -8),
            previewToggleBtn.widthAnchor.constraint(equalToConstant: 96),
            previewToggleBtn.heightAnchor.constraint(equalToConstant: 40),

            hintButton.topAnchor.constraint(equalTo: endRoundButton.bottomAnchor, constant: 10),
            hintButton.leftAnchor.constraint(equalTo: view.centerXAnchor, constant: 8),
            hintButton.widthAnchor.constraint(equalToConstant: 96),
            hintButton.heightAnchor.constraint(equalToConstant: 40)
        ])
    }

    // MARK: - Overlay

    private func setupOverlay() {
        overlayView.backgroundColor = UIColor.black.withAlphaComponent(0.75)
        overlayView.alpha = 0
        overlayView.isUserInteractionEnabled = false
        overlayView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(overlayView)

        NSLayoutConstraint.activate([
            overlayView.topAnchor.constraint(equalTo: view.topAnchor),
            overlayView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            overlayView.leftAnchor.constraint(equalTo: view.leftAnchor),
            overlayView.rightAnchor.constraint(equalTo: view.rightAnchor)
        ])
    }

    // MARK: - Refresh UI

    private func refreshUI() {
        levelNameLabel.text = level.name
        roundLabel.text = "Round \(engine.currentRound)"

        let movesCount = engine.movesLeft
        movesLabel.text = "\(movesCount)"
        movesLabel.textColor = movesCount <= 3
            ? UIColor(red: 1.0, green: 0.35, blue: 0.35, alpha: 1)
            : .white

        // Objective text
        objectiveLabel.text = objectiveText()

        // Combo progress
        let current = engine.detectedCombinations.count
        let needed = neededCombos()
        comboCountLabel.text = "\(current)/\(needed)"
        comboCountLabel.textColor = current >= needed
            ? UIColor(red: 0.2, green: 1.0, blue: 0.5, alpha: 1)
            : UIColor.white.withAlphaComponent(0.7)
    }

    private func objectiveText() -> String {
        switch level.winCondition {
        case .anyComboCount(let n):
            return "Make \(n) combo(s)\n\(level.allowedCombinations.map { $0.rawValue }.joined(separator: " · "))"
        case .combinationCount(let n, let type):
            let typeName = type?.rawValue ?? "any"
            return "Make \(n) \(typeName)(s)"
        case .reachScore(let s):
            return "Reach \(s) points"
        case .withinRounds(let r, let n):
            return "\(n) combo(s) within \(r) rounds"
        }
    }

    private func neededCombos() -> Int {
        switch level.winCondition {
        case .anyComboCount(let n): return n
        case .combinationCount(let n, _): return n
        case .withinRounds(_, let n): return n
        default: return 1
        }
    }

    // MARK: - Actions

    @objc private func goBack() {
        UIView.animate(withDuration: 0.1, animations: {
            self.view.alpha = 0.95
        }) { _ in
            self.navigationController?.popViewController(animated: true)
            UIView.animate(withDuration: 0.1) { self.view.alpha = 1 }
        }
    }

    @objc private func endRoundTapped() {
        guard !isDrifting && !engine.isGameOver else { return }
        isDrifting = true
        endRoundButton.isEnabled = false

        // Visual feedback
        UIView.animate(withDuration: 0.1, animations: {
            self.endRoundButton.transform = CGAffineTransform(scaleX: 0.95, y: 0.95)
        }) { _ in
            UIView.animate(withDuration: 0.1) { self.endRoundButton.transform = .identity }
        }

        // Pulse the board
        boardView.animatePulse()

        // Trigger drift
        let preBoard = engine.board
        engine.endRound()
        let newBoard = engine.board

        boardView.animateDrift(newBoard: newBoard) { [weak self] in
            guard let self = self else { return }
            self.isDrifting = false
            if !self.engine.isGameOver {
                self.endRoundButton.isEnabled = true
            }
        }

        // Haptic
        let impact = UIImpactFeedbackGenerator(style: .medium)
        impact.impactOccurred()

        _ = preBoard // suppress warning
    }

    @objc private func togglePreview() {
        isPreviewOn.toggle()
        if isPreviewOn {
            boardView.showPreview(engine)
            previewToggleBtn.backgroundColor = UIColor(red: 0.45, green: 0.25, blue: 0.90, alpha: 0.4)
        } else {
            boardView.hidePreview()
            previewToggleBtn.backgroundColor = UIColor.white.withAlphaComponent(0.1)
        }
    }

    @objc private func showHint() {
        let alert = UIAlertController(title: "Hint", message: level.hint, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Got it", style: .default))
        present(alert, animated: true)
    }

    // MARK: - Win/Lose UI

    private func showWinOverlay(score: Int) {
        let panel = makeResultPanel(isWin: true, score: score)
        view.addSubview(panel)
        panel.center = view.center
        panel.transform = CGAffineTransform(scaleX: 0.5, y: 0.5)
        panel.alpha = 0

        UIView.animate(withDuration: 0.3, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0.5) {
            self.overlayView.alpha = 1
            self.overlayView.isUserInteractionEnabled = true
            panel.transform = .identity
            panel.alpha = 1
        }

        // Save progress
        var completed = UserDefaults.standard.array(forKey: "completedLevels") as? [Int] ?? []
        if !completed.contains(level.id) { completed.append(level.id) }
        UserDefaults.standard.set(completed, forKey: "completedLevels")
        UserDefaults.standard.set(min(level.id, LevelData.all.count - 1), forKey: "lastLevel")

        let notif = UINotificationFeedbackGenerator()
        notif.notificationOccurred(.success)
    }

    private func showLoseOverlay() {
        let panel = makeResultPanel(isWin: false, score: 0)
        view.addSubview(panel)
        panel.center = view.center
        panel.transform = CGAffineTransform(scaleX: 0.5, y: 0.5)
        panel.alpha = 0

        UIView.animate(withDuration: 0.3, delay: 0, usingSpringWithDamping: 0.75, initialSpringVelocity: 0.3) {
            self.overlayView.alpha = 1
            self.overlayView.isUserInteractionEnabled = true
            panel.transform = .identity
            panel.alpha = 1
        }

        let notif = UINotificationFeedbackGenerator()
        notif.notificationOccurred(.error)
    }

    private func makeResultPanel(isWin: Bool, score: Int) -> UIView {
        let panel = UIView()
        panel.backgroundColor = UIColor(red: 0.12, green: 0.10, blue: 0.25, alpha: 0.97)
        panel.layer.cornerRadius = 24
        panel.layer.borderWidth = 1.5
        panel.layer.borderColor = isWin
            ? UIColor(red: 0.2, green: 1.0, blue: 0.5, alpha: 0.5).cgColor
            : UIColor(red: 1.0, green: 0.35, blue: 0.35, alpha: 0.5).cgColor
        panel.layer.shadowColor = UIColor.black.cgColor
        panel.layer.shadowOpacity = 0.5
        panel.layer.shadowRadius = 20

        let w: CGFloat = min(view.bounds.width - 60, 300)
        panel.frame = CGRect(x: 0, y: 0, width: w, height: isWin ? 260 : 220)

        // Status icon
        let iconView = UIImageView(image: UIImage(systemName: isWin ? "party.popper.fill" : "xmark.circle.fill"))
        iconView.tintColor = isWin
            ? UIColor(red: 0.2, green: 1.0, blue: 0.5, alpha: 1)
            : UIColor(red: 1.0, green: 0.45, blue: 0.45, alpha: 1)
        iconView.contentMode = .scaleAspectFit
        iconView.frame = CGRect(x: (w - 70) / 2, y: 30, width: 70, height: 70)
        panel.addSubview(iconView)

        // Title
        let titleLbl = UILabel()
        titleLbl.text = isWin ? "Level Clear!" : "Out of Moves"
        titleLbl.font = UIFont.systemFont(ofSize: 24, weight: .black)
        titleLbl.textColor = isWin ? UIColor(red: 0.2, green: 1.0, blue: 0.5, alpha: 1) : UIColor(red: 1.0, green: 0.45, blue: 0.45, alpha: 1)
        titleLbl.textAlignment = .center
        titleLbl.frame = CGRect(x: 0, y: 108, width: w, height: 32)
        panel.addSubview(titleLbl)

        if isWin {
            let scoreLbl = UILabel()
            scoreLbl.text = "Score: \(score)"
            scoreLbl.font = UIFont.monospacedDigitSystemFont(ofSize: 16, weight: .medium)
            scoreLbl.textColor = UIColor.white.withAlphaComponent(0.7)
            scoreLbl.textAlignment = .center
            scoreLbl.frame = CGRect(x: 0, y: 146, width: w, height: 24)
            panel.addSubview(scoreLbl)
        }

        let yBtn: CGFloat = isWin ? 186 : 150

        // Retry button
        let retryBtn = UIButton(type: .system)
        retryBtn.setTitle("Retry", for: .normal)
        retryBtn.titleLabel?.font = UIFont.systemFont(ofSize: 15, weight: .semibold)
        retryBtn.backgroundColor = UIColor.white.withAlphaComponent(0.12)
        retryBtn.setTitleColor(.white, for: .normal)
        retryBtn.layer.cornerRadius = 12
        retryBtn.frame = CGRect(x: 20, y: yBtn, width: (w - 52) / 2, height: 44)
        retryBtn.addTarget(self, action: #selector(retryLevel), for: .touchUpInside)
        panel.addSubview(retryBtn)

        // Next / Menu button
        let nextBtn = UIButton(type: .system)
        if isWin && level.id < LevelData.all.count {
            nextBtn.setTitle("Next →", for: .normal)
            nextBtn.addTarget(self, action: #selector(nextLevel), for: .touchUpInside)
        } else {
            nextBtn.setTitle("Menu", for: .normal)
            nextBtn.addTarget(self, action: #selector(backToMenu), for: .touchUpInside)
        }
        nextBtn.titleLabel?.font = UIFont.systemFont(ofSize: 15, weight: .semibold)
        nextBtn.backgroundColor = UIColor(red: 0.45, green: 0.25, blue: 0.90, alpha: 1)
        nextBtn.setTitleColor(.white, for: .normal)
        nextBtn.layer.cornerRadius = 12
        nextBtn.frame = CGRect(x: 32 + (w - 52) / 2, y: yBtn, width: (w - 52) / 2, height: 44)
        panel.addSubview(nextBtn)

        return panel
    }

    @objc private func retryLevel() {
        let vc = GameViewController(level: level)
        var vcs = navigationController?.viewControllers ?? []
        vcs.removeLast()
        vcs.append(vc)
        navigationController?.setViewControllers(vcs, animated: false)
    }

    @objc private func nextLevel() {
        let nextIdx = level.id  // id is 1-based, array is 0-based
        if nextIdx < LevelData.all.count {
            let vc = GameViewController(level: LevelData.all[nextIdx])
            var vcs = navigationController?.viewControllers ?? []
            vcs.removeLast()
            vcs.append(vc)
            navigationController?.setViewControllers(vcs, animated: false)
        } else {
            backToMenu()
        }
    }

    @objc private func backToMenu() {
        navigationController?.popToRootViewController(animated: true)
    }
}

// MARK: - GameEngineDelegate

extension GameViewController: GameEngineDelegate {

    func gameEngine(_ engine: GameEngine, didUpdateBoard board: [[Tile?]]) {
        boardView.updateBoard(board)
        boardView.setHighlighted(engine.detectedCombinations)
        refreshUI()
    }

    func gameEngine(_ engine: GameEngine, didDetectCombinations combos: [DetectedCombination]) {
        boardView.setHighlighted(combos)
        refreshUI()
    }

    func gameEngine(_ engine: GameEngine, didDrift round: Int) {
        roundLabel.text = "Round \(round)"
        refreshUI()
    }

    func gameEngine(_ engine: GameEngine, didSelectTile at: Position?) {
        boardView.setSelected(at)
    }

    func gameEngineDidWin(_ engine: GameEngine, score: Int) {
        endRoundButton.isEnabled = false
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
            self.showWinOverlay(score: score)
        }
    }

    func gameEngineDidLose(_ engine: GameEngine) {
        endRoundButton.isEnabled = false
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            self.showLoseOverlay()
        }
    }

    func gameEngine(_ engine: GameEngine, movesLeftChanged moves: Int) {
        movesLabel.text = "\(moves)"
        movesLabel.textColor = moves <= 3
            ? UIColor(red: 1.0, green: 0.35, blue: 0.35, alpha: 1)
            : .white

        if moves <= 3 && moves > 0 {
            UIView.animate(withDuration: 0.15, animations: {
                self.movesLabel.transform = CGAffineTransform(scaleX: 1.3, y: 1.3)
            }) { _ in
                UIView.animate(withDuration: 0.15) { self.movesLabel.transform = .identity }
            }
        }
    }
}

// MARK: - GameBoardViewDelegate

extension GameViewController: GameBoardViewDelegate {

    func gameBoardView(_ view: GameBoardView, didTapAt position: Position) {
        guard !engine.isGameOver else { return }
        engine.selectOrSwap(at: position)
    }

    func gameBoardView(_ view: GameBoardView, didLongPressAt position: Position) {
        // Show preview for this tile
        boardView.showPreview(engine)
    }

    func gameBoardViewDidEndLongPress(_ view: GameBoardView) {
        if !isPreviewOn {
            boardView.hidePreview()
        }
    }
}
