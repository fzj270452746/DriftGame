//
//  SettingsViewController.swift
//  DriftGame
//
//  Settings screen — sound, haptics, reset progress
//

import UIKit

class SettingsViewController: UIViewController {

    // MARK: - Keys
    private enum Keys {
        static let soundEnabled   = "settings_sound"
        static let hapticsEnabled = "settings_haptics"
        static let showHints      = "settings_showHints"
    }

    // MARK: - Subviews
    private let scrollView  = UIScrollView()
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
        navigationItem.title = "Settings"
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

    // MARK: - Build Content

    private func buildContent() {
        var lastAnchor = contentView.topAnchor
        let margin: CGFloat = 16

        // Section: Audio & Feedback
        let audioHeader = makeSectionHeader("Audio & Feedback")
        contentView.addSubview(audioHeader)
        NSLayoutConstraint.activate([
            audioHeader.topAnchor.constraint(equalTo: lastAnchor, constant: 24),
            audioHeader.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: margin),
            audioHeader.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -margin)
        ])
        lastAnchor = audioHeader.bottomAnchor

        let soundRow = makeToggleRow(
            icon: "speaker.wave.3.fill",
            title: "Sound Effects",
            subtitle: "Play sounds on tile swaps and combos",
            key: Keys.soundEnabled,
            defaultOn: true
        )
        contentView.addSubview(soundRow)
        NSLayoutConstraint.activate([
            soundRow.topAnchor.constraint(equalTo: lastAnchor, constant: 8),
            soundRow.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: margin),
            soundRow.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -margin),
            soundRow.heightAnchor.constraint(equalToConstant: 64)
        ])
        lastAnchor = soundRow.bottomAnchor

        let hapticsRow = makeToggleRow(
            icon: "iphone.radiowaves.left.and.right",
            title: "Haptic Feedback",
            subtitle: "Vibrate on selections and combinations",
            key: Keys.hapticsEnabled,
            defaultOn: true
        )
        contentView.addSubview(hapticsRow)
        NSLayoutConstraint.activate([
            hapticsRow.topAnchor.constraint(equalTo: lastAnchor, constant: 8),
            hapticsRow.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: margin),
            hapticsRow.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -margin),
            hapticsRow.heightAnchor.constraint(equalToConstant: 64)
        ])
        lastAnchor = hapticsRow.bottomAnchor

        // Section: Gameplay
        let gameplayHeader = makeSectionHeader("Gameplay")
        contentView.addSubview(gameplayHeader)
        NSLayoutConstraint.activate([
            gameplayHeader.topAnchor.constraint(equalTo: lastAnchor, constant: 28),
            gameplayHeader.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: margin),
            gameplayHeader.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -margin)
        ])
        lastAnchor = gameplayHeader.bottomAnchor

        let hintsRow = makeToggleRow(
            icon: "lightbulb.fill",
            title: "Show Hints",
            subtitle: "Display level hints during gameplay",
            key: Keys.showHints,
            defaultOn: true
        )
        contentView.addSubview(hintsRow)
        NSLayoutConstraint.activate([
            hintsRow.topAnchor.constraint(equalTo: lastAnchor, constant: 8),
            hintsRow.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: margin),
            hintsRow.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -margin),
            hintsRow.heightAnchor.constraint(equalToConstant: 64)
        ])
        lastAnchor = hintsRow.bottomAnchor

        // Section: Progress
        let progressHeader = makeSectionHeader("Progress")
        contentView.addSubview(progressHeader)
        NSLayoutConstraint.activate([
            progressHeader.topAnchor.constraint(equalTo: lastAnchor, constant: 28),
            progressHeader.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: margin),
            progressHeader.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -margin)
        ])
        lastAnchor = progressHeader.bottomAnchor

        let resetRow = makeActionRow(
            icon: "trash.fill",
            title: "Reset All Progress",
            subtitle: "Clear completed levels and scores",
            tint: UIColor(red: 1.0, green: 0.35, blue: 0.35, alpha: 1),
            action: #selector(confirmReset)
        )
        contentView.addSubview(resetRow)
        NSLayoutConstraint.activate([
            resetRow.topAnchor.constraint(equalTo: lastAnchor, constant: 8),
            resetRow.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: margin),
            resetRow.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -margin),
            resetRow.heightAnchor.constraint(equalToConstant: 64)
        ])
        lastAnchor = resetRow.bottomAnchor

        // Section: About
        let aboutHeader = makeSectionHeader("About")
        contentView.addSubview(aboutHeader)
        NSLayoutConstraint.activate([
            aboutHeader.topAnchor.constraint(equalTo: lastAnchor, constant: 28),
            aboutHeader.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: margin),
            aboutHeader.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -margin)
        ])
        lastAnchor = aboutHeader.bottomAnchor

        let versionRow = makeInfoRow(icon: "shippingbox.fill", title: "Version", value: "1.0.0")
        contentView.addSubview(versionRow)
        NSLayoutConstraint.activate([
            versionRow.topAnchor.constraint(equalTo: lastAnchor, constant: 8),
            versionRow.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: margin),
            versionRow.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -margin),
            versionRow.heightAnchor.constraint(equalToConstant: 56)
        ])
        lastAnchor = versionRow.bottomAnchor

        let levelsRow = makeInfoRow(icon: "map.fill", title: "Total Levels", value: "60")
        contentView.addSubview(levelsRow)
        NSLayoutConstraint.activate([
            levelsRow.topAnchor.constraint(equalTo: lastAnchor, constant: 8),
            levelsRow.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: margin),
            levelsRow.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -margin),
            levelsRow.heightAnchor.constraint(equalToConstant: 56)
        ])
        lastAnchor = levelsRow.bottomAnchor

        // Bottom padding
        let spacer = UIView()
        spacer.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(spacer)
        NSLayoutConstraint.activate([
            spacer.topAnchor.constraint(equalTo: lastAnchor),
            spacer.heightAnchor.constraint(equalToConstant: 40),
            spacer.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
    }

    // MARK: - Row Builders

    private func makeSectionHeader(_ text: String) -> UILabel {
        let label = UILabel()
        label.text = text.uppercased()
        label.font = UIFont.systemFont(ofSize: 11, weight: .semibold)
        label.textColor = UIColor.white.withAlphaComponent(0.4)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }

    private func makeToggleRow(icon: String, title: String, subtitle: String, key: String, defaultOn: Bool) -> UIView {
        let row = makeCardView()

        let iconView = UIImageView(image: UIImage(systemName: icon))
        iconView.tintColor = UIColor.white.withAlphaComponent(0.7)
        iconView.contentMode = .scaleAspectFit
        iconView.translatesAutoresizingMaskIntoConstraints = false
        row.addSubview(iconView)

        let titleLabel = UILabel()
        titleLabel.text = title
        titleLabel.font = UIFont.systemFont(ofSize: 15, weight: .semibold)
        titleLabel.textColor = .white
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        row.addSubview(titleLabel)

        let subtitleLabel = UILabel()
        subtitleLabel.text = subtitle
        subtitleLabel.font = UIFont.systemFont(ofSize: 12)
        subtitleLabel.textColor = UIColor.white.withAlphaComponent(0.45)
        subtitleLabel.translatesAutoresizingMaskIntoConstraints = false
        row.addSubview(subtitleLabel)

        let toggle = UISwitch()
        toggle.isOn = UserDefaults.standard.object(forKey: key) == nil
            ? defaultOn
            : UserDefaults.standard.bool(forKey: key)
        toggle.onTintColor = UIColor(red: 0.45, green: 0.25, blue: 0.90, alpha: 1)
        toggle.translatesAutoresizingMaskIntoConstraints = false
        toggle.accessibilityIdentifier = key
        toggle.addTarget(self, action: #selector(toggleChanged(_:)), for: .valueChanged)
        row.addSubview(toggle)

        NSLayoutConstraint.activate([
            iconView.centerYAnchor.constraint(equalTo: row.centerYAnchor),
            iconView.leftAnchor.constraint(equalTo: row.leftAnchor, constant: 16),
            iconView.widthAnchor.constraint(equalToConstant: 26),
            iconView.heightAnchor.constraint(equalToConstant: 26),

            titleLabel.topAnchor.constraint(equalTo: row.topAnchor, constant: 12),
            titleLabel.leftAnchor.constraint(equalTo: iconView.rightAnchor, constant: 12),
            titleLabel.rightAnchor.constraint(equalTo: toggle.leftAnchor, constant: -8),

            subtitleLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 2),
            subtitleLabel.leftAnchor.constraint(equalTo: iconView.rightAnchor, constant: 12),
            subtitleLabel.rightAnchor.constraint(equalTo: toggle.leftAnchor, constant: -8),

            toggle.centerYAnchor.constraint(equalTo: row.centerYAnchor),
            toggle.rightAnchor.constraint(equalTo: row.rightAnchor, constant: -16)
        ])

        return row
    }

    private func makeActionRow(icon: String, title: String, subtitle: String, tint: UIColor, action: Selector) -> UIView {
        let row = makeCardView()
        let tap = UITapGestureRecognizer(target: self, action: action)
        row.addGestureRecognizer(tap)
        row.isUserInteractionEnabled = true

        let iconView = UIImageView(image: UIImage(systemName: icon))
        iconView.tintColor = tint
        iconView.contentMode = .scaleAspectFit
        iconView.translatesAutoresizingMaskIntoConstraints = false
        row.addSubview(iconView)

        let titleLabel = UILabel()
        titleLabel.text = title
        titleLabel.font = UIFont.systemFont(ofSize: 15, weight: .semibold)
        titleLabel.textColor = tint
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        row.addSubview(titleLabel)

        let subtitleLabel = UILabel()
        subtitleLabel.text = subtitle
        subtitleLabel.font = UIFont.systemFont(ofSize: 12)
        subtitleLabel.textColor = UIColor.white.withAlphaComponent(0.45)
        subtitleLabel.translatesAutoresizingMaskIntoConstraints = false
        row.addSubview(subtitleLabel)

        let chevron = UILabel()
        chevron.text = "›"
        chevron.font = UIFont.systemFont(ofSize: 22, weight: .light)
        chevron.textColor = UIColor.white.withAlphaComponent(0.3)
        chevron.translatesAutoresizingMaskIntoConstraints = false
        row.addSubview(chevron)

        NSLayoutConstraint.activate([
            iconView.centerYAnchor.constraint(equalTo: row.centerYAnchor),
            iconView.leftAnchor.constraint(equalTo: row.leftAnchor, constant: 16),
            iconView.widthAnchor.constraint(equalToConstant: 26),
            iconView.heightAnchor.constraint(equalToConstant: 26),

            titleLabel.topAnchor.constraint(equalTo: row.topAnchor, constant: 12),
            titleLabel.leftAnchor.constraint(equalTo: iconView.rightAnchor, constant: 12),
            titleLabel.rightAnchor.constraint(equalTo: chevron.leftAnchor, constant: -8),

            subtitleLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 2),
            subtitleLabel.leftAnchor.constraint(equalTo: iconView.rightAnchor, constant: 12),
            subtitleLabel.rightAnchor.constraint(equalTo: chevron.leftAnchor, constant: -8),

            chevron.centerYAnchor.constraint(equalTo: row.centerYAnchor),
            chevron.rightAnchor.constraint(equalTo: row.rightAnchor, constant: -16)
        ])

        return row
    }

    private func makeInfoRow(icon: String, title: String, value: String) -> UIView {
        let row = makeCardView()

        let iconView = UIImageView(image: UIImage(systemName: icon))
        iconView.tintColor = UIColor.white.withAlphaComponent(0.6)
        iconView.contentMode = .scaleAspectFit
        iconView.translatesAutoresizingMaskIntoConstraints = false
        row.addSubview(iconView)

        let titleLabel = UILabel()
        titleLabel.text = title
        titleLabel.font = UIFont.systemFont(ofSize: 15, weight: .medium)
        titleLabel.textColor = .white
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        row.addSubview(titleLabel)

        let valueLabel = UILabel()
        valueLabel.text = value
        valueLabel.font = UIFont.systemFont(ofSize: 14)
        valueLabel.textColor = UIColor.white.withAlphaComponent(0.5)
        valueLabel.translatesAutoresizingMaskIntoConstraints = false
        row.addSubview(valueLabel)

        NSLayoutConstraint.activate([
            iconView.centerYAnchor.constraint(equalTo: row.centerYAnchor),
            iconView.leftAnchor.constraint(equalTo: row.leftAnchor, constant: 16),
            iconView.widthAnchor.constraint(equalToConstant: 24),
            iconView.heightAnchor.constraint(equalToConstant: 24),

            titleLabel.centerYAnchor.constraint(equalTo: row.centerYAnchor),
            titleLabel.leftAnchor.constraint(equalTo: iconView.rightAnchor, constant: 12),

            valueLabel.centerYAnchor.constraint(equalTo: row.centerYAnchor),
            valueLabel.rightAnchor.constraint(equalTo: row.rightAnchor, constant: -16)
        ])

        return row
    }

    private func makeCardView() -> UIView {
        let v = UIView()
        v.backgroundColor = UIColor.white.withAlphaComponent(0.08)
        v.layer.cornerRadius = 14
        v.layer.borderWidth  = 1
        v.layer.borderColor  = UIColor.white.withAlphaComponent(0.1).cgColor
        v.translatesAutoresizingMaskIntoConstraints = false
        return v
    }

    // MARK: - Actions

    @objc private func toggleChanged(_ sender: UISwitch) {
        guard let key = sender.accessibilityIdentifier else { return }
        UserDefaults.standard.set(sender.isOn, forKey: key)
    }

    @objc private func confirmReset() {
        let alert = UIAlertController(
            title: "Reset Progress",
            message: "This will clear all completed levels and scores. This cannot be undone.",
            preferredStyle: .alert
        )
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        alert.addAction(UIAlertAction(title: "Reset", style: .destructive) { _ in
            UserDefaults.standard.removeObject(forKey: "completedLevels")
            UserDefaults.standard.removeObject(forKey: "lastLevel")
            let banner = self.makeBanner("Progress reset.")
            self.view.addSubview(banner)
            NSLayoutConstraint.activate([
                banner.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
                banner.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor, constant: -24),
                banner.widthAnchor.constraint(lessThanOrEqualTo: self.view.widthAnchor, constant: -48)
            ])
            UIView.animate(withDuration: 0.3, delay: 1.8, options: [], animations: {
                banner.alpha = 0
            }) { _ in banner.removeFromSuperview() }
        })
        present(alert, animated: true)
    }

    private func makeBanner(_ text: String) -> UIView {
        let v = UIView()
        v.backgroundColor = UIColor(red: 0.15, green: 0.15, blue: 0.28, alpha: 0.95)
        v.layer.cornerRadius = 12
        v.translatesAutoresizingMaskIntoConstraints = false

        let label = UILabel()
        label.text = text
        label.textColor = .white
        label.font = UIFont.systemFont(ofSize: 14, weight: .medium)
        label.translatesAutoresizingMaskIntoConstraints = false
        v.addSubview(label)
        NSLayoutConstraint.activate([
            label.topAnchor.constraint(equalTo: v.topAnchor, constant: 12),
            label.bottomAnchor.constraint(equalTo: v.bottomAnchor, constant: -12),
            label.leftAnchor.constraint(equalTo: v.leftAnchor, constant: 20),
            label.rightAnchor.constraint(equalTo: v.rightAnchor, constant: -20)
        ])
        return v
    }
}
