//
//  TileView.swift
//  DriftGame
//
//  Mahjong-style tile view: ivory background, colored suit stripe,
//  Chinese numeral, suit symbol, selection/highlight/animation support.
//

import UIKit

class TileView: UIView {

    // MARK: - Subviews
    private let stripeLayer   = CALayer()       // colored top stripe
    private let numeralLabel  = UILabel()       // 一～九  (large, center)
    private let suitLabel     = UILabel()       // 索/筒/萬 (small, below numeral)
    private let cornerLabel   = UILabel()       // Arabic digit, top-left corner
    private let specialIcon   = UIImageView()   // lock / snowflake / dice icon
    private let previewLabel  = UILabel()       // "→N", bottom-right, long-press
    private let highlightLayer = CALayer()      // green glow border layer

    // MARK: - State
    var tile: Tile? { didSet { update() } }
    var isSelected: Bool = false { didSet { updateSelectionState() } }
    var isHighlighted: Bool = false { didSet { updateHighlightState() } }
    var previewValue: Int? { didSet { updatePreview() } }

    // MARK: - Init

    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }

    private func setup() {
        // Tile body — ivory / bone colour like a real mahjong tile
        backgroundColor = UIColor(red: 0.96, green: 0.93, blue: 0.84, alpha: 1)
        layer.cornerRadius = 10
        layer.masksToBounds = false

        // Outer shadow (3-D feel)
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOpacity = 0.45
        layer.shadowOffset = CGSize(width: 0, height: 3)
        layer.shadowRadius = 5

        // Colored stripe across the top (clipped by cornerRadius via a sublayer)
        stripeLayer.frame = CGRect(x: 0, y: 0, width: bounds.width, height: 7)
        stripeLayer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        stripeLayer.cornerRadius = 10
        layer.addSublayer(stripeLayer)

        // Highlight border layer (hidden by default)
        highlightLayer.borderWidth = 0
        highlightLayer.cornerRadius = 10
        highlightLayer.frame = bounds
        layer.addSublayer(highlightLayer)

        // Numeral (一～九)
        numeralLabel.textAlignment = .center
        numeralLabel.adjustsFontSizeToFitWidth = true
        numeralLabel.minimumScaleFactor = 0.5
        numeralLabel.translatesAutoresizingMaskIntoConstraints = false
        addSubview(numeralLabel)

        // Suit symbol (索/筒/萬)
        suitLabel.textAlignment = .center
        suitLabel.font = UIFont.systemFont(ofSize: 11, weight: .semibold)
        suitLabel.adjustsFontSizeToFitWidth = true
        suitLabel.minimumScaleFactor = 0.6
        suitLabel.translatesAutoresizingMaskIntoConstraints = false
        addSubview(suitLabel)

        // Corner digit (tiny Arabic number, bottom-left)
        cornerLabel.font = UIFont.monospacedDigitSystemFont(ofSize: 10, weight: .bold)
        cornerLabel.textAlignment = .left
        cornerLabel.translatesAutoresizingMaskIntoConstraints = false
        addSubview(cornerLabel)

        // Special type icon (top-right)
        specialIcon.contentMode = .scaleAspectFit
        specialIcon.translatesAutoresizingMaskIntoConstraints = false
        addSubview(specialIcon)

        // Preview label (bottom-right)
        previewLabel.textAlignment = .right
        previewLabel.font = UIFont.systemFont(ofSize: 10, weight: .medium)
        previewLabel.alpha = 0
        previewLabel.translatesAutoresizingMaskIntoConstraints = false
        addSubview(previewLabel)

        NSLayoutConstraint.activate([
            numeralLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            numeralLabel.centerYAnchor.constraint(equalTo: centerYAnchor, constant: 2),
            numeralLabel.leftAnchor.constraint(equalTo: leftAnchor, constant: 4),
            numeralLabel.rightAnchor.constraint(equalTo: rightAnchor, constant: -4),

            suitLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            suitLabel.topAnchor.constraint(equalTo: numeralLabel.bottomAnchor, constant: 0),
            suitLabel.leftAnchor.constraint(equalTo: leftAnchor, constant: 4),
            suitLabel.rightAnchor.constraint(equalTo: rightAnchor, constant: -4),

            cornerLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -3),
            cornerLabel.leftAnchor.constraint(equalTo: leftAnchor, constant: 5),

            specialIcon.topAnchor.constraint(equalTo: topAnchor, constant: 6),
            specialIcon.rightAnchor.constraint(equalTo: rightAnchor, constant: -4),
            specialIcon.widthAnchor.constraint(equalToConstant: 14),
            specialIcon.heightAnchor.constraint(equalToConstant: 14),

            previewLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -3),
            previewLabel.rightAnchor.constraint(equalTo: rightAnchor, constant: -5)
        ])
    }

    // MARK: - Update UI

    private func update() {
        guard let tile = tile else {
            isHidden = true
            return
        }
        isHidden = false

        let v = tile.value
        let color = UIColor.tileColor(for: v)

        // Stripe colour
        stripeLayer.backgroundColor = color.cgColor

        // Numeral & suit
        numeralLabel.text  = TileView.chineseNumeral(for: v)
        numeralLabel.textColor = color.darker(by: 0.15)

        suitLabel.text  = TileView.suitSymbol(for: v)
        suitLabel.textColor = color.darker(by: 0.25).withAlphaComponent(0.85)

        cornerLabel.text = "\(v)"
        cornerLabel.textColor = color.darker(by: 0.3).withAlphaComponent(0.7)

        previewLabel.textColor = color.darker(by: 0.2)

        // Special icon
        switch tile.specialType {
        case .locked:  specialIcon.image = UIImage(systemName: "lock.fill"); specialIcon.tintColor = color
        case .frozen:  specialIcon.image = UIImage(systemName: "snowflake"); specialIcon.tintColor = UIColor(red: 0.3, green: 0.7, blue: 1.0, alpha: 1)
        case .random:  specialIcon.image = UIImage(systemName: "die.face.6.fill"); specialIcon.tintColor = color
        case .normal:  specialIcon.image = nil
        }

        // Dynamic font size from tile size
        let side = min(bounds.width, bounds.height)
        numeralLabel.font = UIFont.systemFont(ofSize: max(14, side * 0.40), weight: .black)

        updateSelectionState()
    }

    private func updateSelectionState() {
        if isSelected {
            layer.borderWidth  = 3
            layer.borderColor  = UIColor(red: 0.95, green: 0.75, blue: 0.15, alpha: 1).cgColor
            transform          = CGAffineTransform(scaleX: 1.08, y: 1.08)
            layer.shadowOpacity = 0.7
            layer.shadowRadius  = 10
        } else {
            layer.borderWidth  = isHighlighted ? 2.5 : 1
            layer.borderColor  = isHighlighted
                ? UIColor(red: 0.3, green: 1.0, blue: 0.5, alpha: 1).cgColor
                : UIColor(red: 0.55, green: 0.42, blue: 0.25, alpha: 0.55).cgColor
            transform          = .identity
            layer.shadowOpacity = 0.45
            layer.shadowRadius  = 5
        }
    }

    private func updateHighlightState() {
        if !isSelected { updateSelectionState() }
    }

    private func updatePreview() {
        if let v = previewValue {
            previewLabel.text = "→\(v)"
            UIView.animate(withDuration: 0.2) { self.previewLabel.alpha = 1 }
        } else {
            UIView.animate(withDuration: 0.2) { self.previewLabel.alpha = 0 }
        }
    }

    // MARK: - Layout

    override func layoutSubviews() {
        super.layoutSubviews()
        stripeLayer.frame = CGRect(x: 0, y: 0, width: bounds.width, height: 7)
        highlightLayer.frame = bounds
        update()
    }

    // MARK: - Drift Animation

    func animateDrift(to newValue: Int, completion: (() -> Void)? = nil) {
        let newColor = UIColor.tileColor(for: newValue)

        UIView.animateKeyframes(withDuration: 0.45, delay: 0, options: [], animations: {
            UIView.addKeyframe(withRelativeStartTime: 0, relativeDuration: 0.3) {
                self.numeralLabel.transform = CGAffineTransform(translationX: 0, y: -8).scaledBy(x: 1.2, y: 1.2)
                self.numeralLabel.alpha     = 0.3
                self.suitLabel.alpha        = 0.3
            }
            UIView.addKeyframe(withRelativeStartTime: 0.3, relativeDuration: 0.4) {
                self.numeralLabel.text       = TileView.chineseNumeral(for: newValue)
                self.numeralLabel.textColor  = newColor.darker(by: 0.15)
                self.suitLabel.text          = TileView.suitSymbol(for: newValue)
                self.suitLabel.textColor     = newColor.darker(by: 0.25).withAlphaComponent(0.85)
                self.cornerLabel.text        = "\(newValue)"
                self.cornerLabel.textColor   = newColor.darker(by: 0.3).withAlphaComponent(0.7)
                self.numeralLabel.transform  = .identity
                self.numeralLabel.alpha      = 1
                self.suitLabel.alpha         = 1
                self.stripeLayer.backgroundColor = newColor.cgColor
            }
        }, completion: { _ in completion?() })

        // Smooth stripe colour crossfade
        let ca = CABasicAnimation(keyPath: "backgroundColor")
        ca.toValue  = newColor.cgColor
        ca.duration = 0.45
        ca.fillMode = .forwards
        ca.isRemovedOnCompletion = false
        stripeLayer.add(ca, forKey: "stripeColor")
    }

    // MARK: - Selection Animation

    func animateSelect() {
        UIView.animate(withDuration: 0.15, delay: 0, options: .curveEaseOut) {
            self.transform = CGAffineTransform(scaleX: 1.12, y: 1.12)
        }
    }

    // MARK: - Combination Flash Animation

    func animateCombinationFlash() {
        UIView.animateKeyframes(withDuration: 0.6, delay: 0, options: [], animations: {
            UIView.addKeyframe(withRelativeStartTime: 0.0, relativeDuration: 0.2) {
                self.layer.borderWidth = 3
                self.layer.borderColor = UIColor(red: 0.2, green: 1.0, blue: 0.4, alpha: 1).cgColor
                self.layer.shadowColor = UIColor(red: 0.2, green: 1.0, blue: 0.4, alpha: 1).cgColor
                self.layer.shadowOpacity = 0.9
                self.layer.shadowRadius  = 12
            }
            UIView.addKeyframe(withRelativeStartTime: 0.5, relativeDuration: 0.5) {
                self.layer.shadowOpacity = 0.45
                self.layer.shadowRadius  = 5
                self.layer.shadowColor   = UIColor.black.cgColor
            }
        })
    }

    // MARK: - Shake Animation (locked tile attempt)

    func animateShake() {
        let shake = CAKeyframeAnimation(keyPath: "transform.translation.x")
        shake.timingFunction = CAMediaTimingFunction(name: .linear)
        shake.duration = 0.4
        shake.values   = [-8, 8, -6, 6, -4, 4, 0]
        layer.add(shake, forKey: "shake")
    }

    // MARK: - Helpers

    static func chineseNumeral(for value: Int) -> String {
        let chars = ["一", "二", "三", "四", "五", "六", "七", "八", "九"]
        let idx   = max(0, min(8, value - 1))
        return chars[idx]
    }

    /// Suit: 1-3 → 索 (bamboo), 4-6 → 筒 (circles), 7-9 → 萬 (characters)
    static func suitSymbol(for value: Int) -> String {
        if value <= 3 { return "索" }
        if value <= 6 { return "筒" }
        return "萬"
    }
}

// MARK: - UIColor darker helper

private extension UIColor {
    func darker(by factor: CGFloat) -> UIColor {
        var h: CGFloat = 0, s: CGFloat = 0, b: CGFloat = 0, a: CGFloat = 0
        if getHue(&h, saturation: &s, brightness: &b, alpha: &a) {
            return UIColor(hue: h, saturation: s, brightness: max(0, b - factor), alpha: a)
        }
        return self
    }
}
