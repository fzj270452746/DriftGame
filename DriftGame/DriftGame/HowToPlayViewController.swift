//
//  HowToPlayViewController.swift
//  DriftGame
//
//  Game instructions screen — all English
//

import UIKit

class HowToPlayViewController: UIViewController {

    private let scrollView = UIScrollView()
    private let contentView = UIView()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupBackground()
        setupNavBar()
        setupScrollView()
        buildContent()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(false, animated: animated)
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
    }

    // MARK: - Background

    private func setupBackground() {
        let gradient = CAGradientLayer()
        gradient.colors = [
            UIColor(red: 0.07, green: 0.07, blue: 0.18, alpha: 1).cgColor,
            UIColor(red: 0.10, green: 0.04, blue: 0.22, alpha: 1).cgColor
        ]
        gradient.startPoint = CGPoint(x: 0, y: 0)
        gradient.endPoint   = CGPoint(x: 1, y: 1)
        gradient.frame      = view.bounds
        view.layer.insertSublayer(gradient, at: 0)
        view.backgroundColor = UIColor(red: 0.07, green: 0.07, blue: 0.18, alpha: 1)
    }

    private func setupNavBar() {
        navigationItem.title = "How to Play"
        let attrs: [NSAttributedString.Key: Any] = [
            .foregroundColor: UIColor.white,
            .font: UIFont.systemFont(ofSize: 18, weight: .bold)
        ]
        navigationController?.navigationBar.titleTextAttributes = attrs
        navigationController?.navigationBar.tintColor = .white
        navigationController?.navigationBar.barStyle  = .black
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationController?.navigationBar.shadowImage = UIImage()
        navigationController?.navigationBar.isTranslucent = true
    }

    // MARK: - Scroll View

    private func setupScrollView() {
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.showsVerticalScrollIndicator = false
        view.addSubview(scrollView)

        contentView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.addSubview(contentView)

        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            scrollView.leftAnchor.constraint(equalTo: view.leftAnchor),
            scrollView.rightAnchor.constraint(equalTo: view.rightAnchor),

            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            contentView.leftAnchor.constraint(equalTo: scrollView.leftAnchor),
            contentView.rightAnchor.constraint(equalTo: scrollView.rightAnchor),
            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor)
        ])
    }

    // MARK: - Content

    private func buildContent() {
        let sections: [(icon: String, title: String, body: String)] = [
            (
                "rectangle.fill",
                "The Basics",
                "Drift Mahjong is a number puzzle game played on a grid of tiles. Each tile shows a value from 1 to 9. Your goal is to form combinations by swapping adjacent tiles."
            ),
            (
                "arrow.triangle.2.circlepath",
                "Drift Mechanic",
                "After every round, all tiles drift — their values shift by a set amount (e.g. +1 each round, so a 5 becomes a 6). Values wrap around: 9 drifts back to 1.\n\nUse drift to your advantage — plan ahead and let the values come to you."
            ),
            (
                "handshake",
                "Combinations",
                "Tap two or more adjacent tiles to select them, then confirm to score:\n\n• Pair — two tiles with the same value\n• Triplet — three tiles with the same value\n• Sequence — three consecutive values (e.g. 3-4-5, or 8-9-1)\n• Sum — tiles whose values add up to the target number\n\nHighlighted tiles (green border) are ready to combine."
            ),
            (
                "arrow.left.and.right",
                "Swapping Tiles",
                "Tap a tile to select it (gold border), then tap an adjacent tile to swap them. Each swap costs one move.\n\nYou have a limited number of moves per level — use them wisely."
            ),
            (
                "stopwatch.fill",
                "End Round",
                "Press End Round to trigger the drift and advance to the next round. Drift happens automatically — you choose when to trigger it.\n\nSome levels have a round limit, so don't waste rounds."
            ),
            (
                "lock.fill",
                "Special Tiles",
                "• Locked — cannot be swapped or moved\n• Frozen — value does not drift\n• Random — value changes randomly each round\n\nWork around special tiles or use them as anchors in your strategy."
            ),
            (
                "map.fill",
                "Drift Rules",
                "Each level has its own drift rule:\n\n• Standard — all tiles +1 per round\n• Reverse — all tiles -1 per round\n• Random — each tile shifts ±1 randomly\n• Zone — only tiles in a specific area drift\n• Delayed — drift only triggers every N rounds"
            ),
            (
                "trophy.fill",
                "Win Conditions",
                "Levels can be won in different ways:\n\n• Combo Count — form a set number of combinations\n• Reach Score — accumulate enough points\n• Speed Run — complete required combos within a round limit\n\nCheck the objective card at the top of the game screen."
            ),
            (
                "lightbulb.fill",
                "Tips",
                "• Long-press any tile to preview its next drift value\n• Let drift do the work — sometimes waiting beats swapping\n• Locked tiles make great anchors for sequences\n• Frozen tiles hold their value — use them as fixed reference points\n• Sequences score more than pairs — aim high when possible"
            )
        ]

        var lastAnchor = contentView.topAnchor
        let sidePad: CGFloat = 20

        for (i, section) in sections.enumerated() {
            let card = makeCard(icon: section.icon, title: section.title, body: section.body)
            card.translatesAutoresizingMaskIntoConstraints = false
            contentView.addSubview(card)

            let topConst: CGFloat = i == 0 ? 20 : 12
            NSLayoutConstraint.activate([
                card.topAnchor.constraint(equalTo: lastAnchor, constant: topConst),
                card.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: sidePad),
                card.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -sidePad)
            ])
            lastAnchor = card.bottomAnchor
        }

        // Bottom spacer
        let spacer = UIView()
        spacer.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(spacer)
        NSLayoutConstraint.activate([
            spacer.topAnchor.constraint(equalTo: lastAnchor, constant: 32),
            spacer.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            spacer.heightAnchor.constraint(equalToConstant: 1)
        ])
    }

    private func makeCard(icon: String, title: String, body: String) -> UIView {
        let card = UIView()
        card.backgroundColor = UIColor.white.withAlphaComponent(0.07)
        card.layer.cornerRadius = 16
        card.layer.borderWidth  = 1
        card.layer.borderColor  = UIColor.white.withAlphaComponent(0.1).cgColor

        let iconView = UIImageView(image: UIImage(systemName: icon))
        iconView.tintColor = UIColor.white.withAlphaComponent(0.7)
        iconView.contentMode = .scaleAspectFit
        iconView.translatesAutoresizingMaskIntoConstraints = false

        let titleLabel = UILabel()
        titleLabel.text = title
        titleLabel.font = UIFont.systemFont(ofSize: 16, weight: .bold)
        titleLabel.textColor = .white
        titleLabel.translatesAutoresizingMaskIntoConstraints = false

        let bodyLabel = UILabel()
        bodyLabel.text = body
        bodyLabel.font = UIFont.systemFont(ofSize: 14)
        bodyLabel.textColor = UIColor.white.withAlphaComponent(0.75)
        bodyLabel.numberOfLines = 0
        bodyLabel.translatesAutoresizingMaskIntoConstraints = false

        card.addSubview(iconView)
        card.addSubview(titleLabel)
        card.addSubview(bodyLabel)

        NSLayoutConstraint.activate([
            iconView.topAnchor.constraint(equalTo: card.topAnchor, constant: 16),
            iconView.leftAnchor.constraint(equalTo: card.leftAnchor, constant: 16),
            iconView.widthAnchor.constraint(equalToConstant: 28),
            iconView.heightAnchor.constraint(equalToConstant: 28),

            titleLabel.centerYAnchor.constraint(equalTo: iconView.centerYAnchor),
            titleLabel.leftAnchor.constraint(equalTo: iconView.rightAnchor, constant: 10),
            titleLabel.rightAnchor.constraint(equalTo: card.rightAnchor, constant: -16),

            bodyLabel.topAnchor.constraint(equalTo: iconView.bottomAnchor, constant: 10),
            bodyLabel.leftAnchor.constraint(equalTo: card.leftAnchor, constant: 16),
            bodyLabel.rightAnchor.constraint(equalTo: card.rightAnchor, constant: -16),
            bodyLabel.bottomAnchor.constraint(equalTo: card.bottomAnchor, constant: -16)
        ])

        return card
    }
}
