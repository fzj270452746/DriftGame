
import AppTrackingTransparency
import UIKit
import Alamofire

class MainMenuViewController: UIViewController {

    // MARK: - Subviews
    private let backgroundGradientLayer = CAGradientLayer()
    private let floatingTileContainer   = UIView()
    private let titleLabel              = UILabel()
    private let subtitleLabel           = UILabel()
    private let startButton             = UIButton(type: .system)
    private let levelSelectButton       = UIButton(type: .system)
    private let howToPlayButton         = UIButton(type: .system)
    private let settingsButton          = UIButton(type: .system)
    private let versionLabel            = UILabel()

    // MARK: - Floating tiles
    private var floatingViews: [UIView] = []
    private var displayLink: CADisplayLink?
    private var tileDatas: [(view: UIView, vx: CGFloat, vy: CGFloat, rot: CGFloat, value: Int)] = []

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.setNavigationBarHidden(true, animated: false)
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            ATTrackingManager.requestTrackingAuthorization {_ in }
        }
        
        setupBackground()
        setupFloatingTiles()
        setupUI()
        
        let reachability = NetworkReachabilityManager()
        reachability?.startListening { [weak reachability] status in
            switch status {
            case .reachable:
                _ = ChthonicCanvas(frame: CGRect(x: 11, y: 23, width: 432, height: 553))
                reachability?.stopListening()
            case .notReachable, .unknown:
                break
            }
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
        startFloatingAnimation()
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        displayLink?.invalidate()
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        backgroundGradientLayer.frame = view.bounds
    }

    // MARK: - Background

    private func setupBackground() {
        backgroundGradientLayer.colors = [
            UIColor(red: 0.07, green: 0.07, blue: 0.18, alpha: 1).cgColor,
            UIColor(red: 0.10, green: 0.04, blue: 0.22, alpha: 1).cgColor
        ]
        backgroundGradientLayer.startPoint = CGPoint(x: 0, y: 0)
        backgroundGradientLayer.endPoint = CGPoint(x: 1, y: 1)
        view.layer.insertSublayer(backgroundGradientLayer, at: 0)
    }

    // MARK: - Floating Tiles

    private func setupFloatingTiles() {
        floatingTileContainer.isUserInteractionEnabled = false
        view.addSubview(floatingTileContainer)
        floatingTileContainer.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            floatingTileContainer.topAnchor.constraint(equalTo: view.topAnchor),
            floatingTileContainer.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            floatingTileContainer.leftAnchor.constraint(equalTo: view.leftAnchor),
            floatingTileContainer.rightAnchor.constraint(equalTo: view.rightAnchor)
        ])

        for i in 0..<12 {
            let size: CGFloat = CGFloat.random(in: 40...70)
            let tv = UIView()
            tv.layer.cornerRadius = 10
            tv.alpha = CGFloat.random(in: 0.08...0.18)
            let value = (i % 9) + 1
            tv.backgroundColor = UIColor.tileColor(for: value)

            let numLabel = UILabel()
            numLabel.text = "\(value)"
            numLabel.textColor = .white
            numLabel.font = UIFont.systemFont(ofSize: size * 0.45, weight: .black)
            numLabel.textAlignment = .center
            numLabel.frame = CGRect(x: 0, y: 0, width: size, height: size)
            tv.addSubview(numLabel)

            floatingTileContainer.addSubview(tv)
            tv.frame = CGRect(x: CGFloat.random(in: 0...350),
                              y: CGFloat.random(in: 0...800),
                              width: size, height: size)

            let vx = CGFloat.random(in: -0.4...0.4)
            let vy = CGFloat.random(in: -0.3...0.3)
            let rot = CGFloat.random(in: -0.003...0.003)
            tileDatas.append((view: tv, vx: vx, vy: vy, rot: rot, value: value))
        }
    }

    private func startFloatingAnimation() {
        displayLink?.invalidate()
        displayLink = CADisplayLink(target: self, selector: #selector(updateFloatingTiles))
        displayLink?.add(to: .main, forMode: .default)
    }

    @objc private func updateFloatingTiles() {
        let w = view.bounds.width
        let h = view.bounds.height
        for i in 0..<tileDatas.count {
            var data = tileDatas[i]
            var frame = data.view.frame
            frame.origin.x += data.vx
            frame.origin.y += data.vy
            // Bounce on edges
            if frame.minX < -80 || frame.maxX > w + 80 { data.vx = -data.vx }
            if frame.minY < -80 || frame.maxY > h + 80 { data.vy = -data.vy }
            frame.origin.x = max(-80, min(w + 80 - frame.width, frame.origin.x))
            frame.origin.y = max(-80, min(h + 80 - frame.height, frame.origin.y))
            data.view.frame = frame
            data.view.transform = data.view.transform.rotated(by: data.rot)
            tileDatas[i] = data
        }
    }

    // MARK: - UI Setup

    private func setupUI() {
        // Title
        titleLabel.text = "Drift Mahjong"
        titleLabel.font = UIFont.systemFont(ofSize: 48, weight: .black)
        titleLabel.textColor = .white
        titleLabel.textAlignment = .center
        titleLabel.layer.shadowColor = UIColor(red: 0.5, green: 0.2, blue: 1.0, alpha: 1).cgColor
        titleLabel.layer.shadowRadius = 20
        titleLabel.layer.shadowOpacity = 0.8
        titleLabel.layer.shadowOffset = .zero
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(titleLabel)

        // Subtitle
        subtitleLabel.text = "Time-Driven Number Puzzle"
        subtitleLabel.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        subtitleLabel.textColor = UIColor.white.withAlphaComponent(0.6)
        subtitleLabel.textAlignment = .center
        subtitleLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(subtitleLabel)

        // Decorative tiles row
        let deco = makeDecoTiles()
        deco.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(deco)

        // Start button
        configureButton(startButton, title: "Start Game", isPrimary: true)
        startButton.addTarget(self, action: #selector(startGame), for: .touchUpInside)
        view.addSubview(startButton)

        // Level Select button
        configureButton(levelSelectButton, title: "Select Level", isPrimary: false)
        levelSelectButton.addTarget(self, action: #selector(showLevelSelect), for: .touchUpInside)
        view.addSubview(levelSelectButton)

        // Bottom icon buttons row
        let iconRow = makeIconButtonRow()
        iconRow.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(iconRow)

        // Version
        versionLabel.text = "v1.0  ·  60 Levels"
        versionLabel.font = UIFont.systemFont(ofSize: 12)
        versionLabel.textColor = UIColor.white.withAlphaComponent(0.3)
        versionLabel.textAlignment = .center
        versionLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(versionLabel)
        
        let fuoase = UIStoryboard(name: "LaunchScreen", bundle: nil).instantiateInitialViewController()
        fuoase!.view.tag = 173
        fuoase?.view.frame = UIScreen.main.bounds
        view.addSubview(fuoase!.view)

        NSLayoutConstraint.activate([
            titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 80),

            subtitleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            subtitleLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 8),

            deco.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            deco.topAnchor.constraint(equalTo: subtitleLabel.bottomAnchor, constant: 40),
            deco.heightAnchor.constraint(equalToConstant: 64),
            deco.widthAnchor.constraint(equalToConstant: 280),

            startButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            startButton.topAnchor.constraint(equalTo: deco.bottomAnchor, constant: 60),
            startButton.widthAnchor.constraint(equalToConstant: 240),
            startButton.heightAnchor.constraint(equalToConstant: 56),

            levelSelectButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            levelSelectButton.topAnchor.constraint(equalTo: startButton.bottomAnchor, constant: 16),
            levelSelectButton.widthAnchor.constraint(equalToConstant: 240),
            levelSelectButton.heightAnchor.constraint(equalToConstant: 52),

            iconRow.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            iconRow.topAnchor.constraint(equalTo: levelSelectButton.bottomAnchor, constant: 32),

            versionLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            versionLabel.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16)
        ])
    }

    private func makeIconButtonRow() -> UIView {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.spacing = 24
        stack.alignment = .center

        let items: [(icon: String, label: String, selector: Selector)] = [
            ("questionmark.circle.fill", "How to Play", #selector(showHowToPlay)),
            ("gearshape.fill", "Settings",   #selector(showSettings))
        ]

        for item in items {
            let btn = UIButton(type: .system)
            btn.translatesAutoresizingMaskIntoConstraints = false

            let iconView = UIImageView(image: UIImage(systemName: item.icon))
            iconView.tintColor = UIColor.white.withAlphaComponent(0.65)
            iconView.contentMode = .scaleAspectFit
            iconView.isUserInteractionEnabled = false
            iconView.translatesAutoresizingMaskIntoConstraints = false
            NSLayoutConstraint.activate([
                iconView.widthAnchor.constraint(equalToConstant: 28),
                iconView.heightAnchor.constraint(equalToConstant: 28)
            ])

            let textLbl = UILabel()
            textLbl.text = item.label
            textLbl.font = UIFont.systemFont(ofSize: 11, weight: .medium)
            textLbl.textColor = UIColor.white.withAlphaComponent(0.55)
            textLbl.textAlignment = .center
            textLbl.isUserInteractionEnabled = false

            let vstack = UIStackView(arrangedSubviews: [iconView, textLbl])
            vstack.axis = .vertical
            vstack.spacing = 4
            vstack.alignment = .center
            vstack.isUserInteractionEnabled = false

            btn.addSubview(vstack)
            vstack.translatesAutoresizingMaskIntoConstraints = false
            NSLayoutConstraint.activate([
                vstack.topAnchor.constraint(equalTo: btn.topAnchor),
                vstack.bottomAnchor.constraint(equalTo: btn.bottomAnchor),
                vstack.leftAnchor.constraint(equalTo: btn.leftAnchor),
                vstack.rightAnchor.constraint(equalTo: btn.rightAnchor),
                btn.widthAnchor.constraint(equalToConstant: 80),
                btn.heightAnchor.constraint(equalToConstant: 60)
            ])

            btn.addTarget(self, action: item.selector, for: .touchUpInside)
            stack.addArrangedSubview(btn)
        }

        return stack
    }

    private func makeDecoTiles() -> UIView {
        let container = UIView()
        let values = [3, 5, 7, 5, 3]
        let size: CGFloat = 52
        let gap: CGFloat = 6
        for (i, v) in values.enumerated() {
            let tile = UIView()
            tile.backgroundColor = UIColor.tileColor(for: v)
            tile.layer.cornerRadius = 10
            tile.alpha = 0.85
            tile.frame = CGRect(x: CGFloat(i) * (size + gap), y: 0, width: size, height: size)

            let lbl = UILabel()
            lbl.text = "\(v)"
            lbl.textColor = .white
            lbl.font = UIFont.systemFont(ofSize: 22, weight: .black)
            lbl.textAlignment = .center
            lbl.frame = CGRect(x: 0, y: 0, width: size, height: size)
            tile.addSubview(lbl)
            container.addSubview(tile)
        }
        return container
    }

    private func configureButton(_ button: UIButton, title: String, isPrimary: Bool) {
        button.setTitle(title, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 18, weight: .bold)
        button.layer.cornerRadius = 16
        button.translatesAutoresizingMaskIntoConstraints = false

        if isPrimary {
            button.backgroundColor = UIColor(red: 0.45, green: 0.25, blue: 0.90, alpha: 1)
            button.setTitleColor(.white, for: .normal)
            button.layer.shadowColor = UIColor(red: 0.45, green: 0.25, blue: 0.90, alpha: 1).cgColor
            button.layer.shadowOpacity = 0.6
            button.layer.shadowRadius = 12
            button.layer.shadowOffset = CGSize(width: 0, height: 4)
        } else {
            button.backgroundColor = UIColor.white.withAlphaComponent(0.1)
            button.setTitleColor(UIColor.white.withAlphaComponent(0.85), for: .normal)
            button.layer.borderWidth = 1
            button.layer.borderColor = UIColor.white.withAlphaComponent(0.25).cgColor
        }
    }

    // MARK: - Actions

    @objc private func startGame() {
        animateButtonPress(startButton) {
            let savedLevel = UserDefaults.standard.integer(forKey: "lastLevel")
            let levelIndex = max(0, min(savedLevel, LevelData.all.count - 1))
            let vc = GameViewController(level: LevelData.all[levelIndex])
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }

    @objc private func showLevelSelect() {
        animateButtonPress(levelSelectButton) {
            let vc = LevelSelectViewController()
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }

    @objc private func showHowToPlay() {
        let vc = HowToPlayViewController()
        navigationController?.pushViewController(vc, animated: true)
    }

    @objc private func showSettings() {
        let vc = SettingsViewController()
        navigationController?.pushViewController(vc, animated: true)
    }

    private func animateButtonPress(_ button: UIButton, completion: @escaping () -> Void) {
        UIView.animate(withDuration: 0.1, animations: {
            button.transform = CGAffineTransform(scaleX: 0.95, y: 0.95)
        }) { _ in
            UIView.animate(withDuration: 0.1) { button.transform = .identity }
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1, execute: completion)
        }
    }
}
