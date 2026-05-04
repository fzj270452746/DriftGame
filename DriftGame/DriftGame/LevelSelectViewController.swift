//
//  LevelSelectViewController.swift
//  DriftGame
//
//  关卡选择界面，网格展示10个关卡
//

import UIKit

class LevelSelectViewController: UIViewController {

    private let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumInteritemSpacing = 12
        layout.minimumLineSpacing = 12
        layout.sectionInset = UIEdgeInsets(top: 16, left: 16, bottom: 32, right: 16)
        return UICollectionView(frame: .zero, collectionViewLayout: layout)
    }()

    private let headerLabel = UILabel()

    private static let cellID = "LevelCell"
    private var completedLevels: Set<Int> {
        let arr = UserDefaults.standard.array(forKey: "completedLevels") as? [Int] ?? []
        return Set(arr)
    }

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        setupBackground()
        setupHeader()
        setupCollectionView()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(false, animated: animated)
        collectionView.reloadData()
    }

    // MARK: - Setup

    private func setupBackground() {
        let gradient = CAGradientLayer()
        gradient.colors = [
            UIColor(red: 0.07, green: 0.07, blue: 0.18, alpha: 1).cgColor,
            UIColor(red: 0.10, green: 0.04, blue: 0.22, alpha: 1).cgColor
        ]
        gradient.startPoint = CGPoint(x: 0, y: 0)
        gradient.endPoint = CGPoint(x: 1, y: 1)
        gradient.frame = view.bounds
        view.layer.insertSublayer(gradient, at: 0)
        view.backgroundColor = UIColor(red: 0.07, green: 0.07, blue: 0.18, alpha: 1)
    }

    private func setupHeader() {
        navigationItem.title = "Select Level"
        let attrs: [NSAttributedString.Key: Any] = [
            .foregroundColor: UIColor.white,
            .font: UIFont.systemFont(ofSize: 18, weight: .bold)
        ]
        navigationController?.navigationBar.titleTextAttributes = attrs
        navigationController?.navigationBar.tintColor = .white
        navigationController?.navigationBar.barStyle = .black
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationController?.navigationBar.shadowImage = UIImage()
        navigationController?.navigationBar.isTranslucent = true
    }

    private func setupCollectionView() {
        collectionView.backgroundColor = .clear
        collectionView.register(LevelCell.self, forCellWithReuseIdentifier: LevelSelectViewController.cellID)
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(collectionView)

        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            collectionView.leftAnchor.constraint(equalTo: view.leftAnchor),
            collectionView.rightAnchor.constraint(equalTo: view.rightAnchor)
        ])
    }
}

// MARK: - CollectionView DataSource & Delegate

extension LevelSelectViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return LevelData.all.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: LevelSelectViewController.cellID, for: indexPath) as! LevelCell
        let level = LevelData.all[indexPath.item]
        let isCompleted = completedLevels.contains(level.id)
        cell.configure(with: level, isCompleted: isCompleted)
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let padding: CGFloat = 16 * 2 + 12
        let w = (collectionView.bounds.width - padding) / 2
        return CGSize(width: w, height: w * 0.85)
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let level = LevelData.all[indexPath.item]
        let vc = GameViewController(level: level)
        navigationController?.pushViewController(vc, animated: true)
    }
}

// MARK: - Level Cell

class LevelCell: UICollectionViewCell {

    private let bgView       = UIView()
    private let numberLabel  = UILabel()
    private let nameLabel    = UILabel()
    private let subtitleLabel = UILabel()
    private let starsView    = UIStackView()
    private let completedBadge = UILabel()
    private let tileSample   = UIView()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    required init?(coder: NSCoder) { fatalError() }

    private func setup() {
        bgView.layer.cornerRadius = 16
        bgView.layer.borderWidth = 1
        bgView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(bgView)

        numberLabel.font = UIFont.systemFont(ofSize: 12, weight: .medium)
        numberLabel.textColor = UIColor.white.withAlphaComponent(0.5)
        numberLabel.translatesAutoresizingMaskIntoConstraints = false
        bgView.addSubview(numberLabel)

        nameLabel.font = UIFont.systemFont(ofSize: 16, weight: .bold)
        nameLabel.textColor = .white
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        bgView.addSubview(nameLabel)

        subtitleLabel.font = UIFont.systemFont(ofSize: 11)
        subtitleLabel.textColor = UIColor.white.withAlphaComponent(0.6)
        subtitleLabel.numberOfLines = 2
        subtitleLabel.translatesAutoresizingMaskIntoConstraints = false
        bgView.addSubview(subtitleLabel)

        starsView.axis = .horizontal
        starsView.spacing = 2
        starsView.translatesAutoresizingMaskIntoConstraints = false
        bgView.addSubview(starsView)

        completedBadge.text = "✓"
        completedBadge.font = UIFont.systemFont(ofSize: 14, weight: .bold)
        completedBadge.textColor = UIColor(red: 0.2, green: 1.0, blue: 0.5, alpha: 1)
        completedBadge.translatesAutoresizingMaskIntoConstraints = false
        completedBadge.isHidden = true
        bgView.addSubview(completedBadge)

        tileSample.layer.cornerRadius = 6
        tileSample.alpha = 0.6
        tileSample.translatesAutoresizingMaskIntoConstraints = false
        bgView.addSubview(tileSample)

        NSLayoutConstraint.activate([
            bgView.topAnchor.constraint(equalTo: contentView.topAnchor),
            bgView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            bgView.leftAnchor.constraint(equalTo: contentView.leftAnchor),
            bgView.rightAnchor.constraint(equalTo: contentView.rightAnchor),

            numberLabel.topAnchor.constraint(equalTo: bgView.topAnchor, constant: 12),
            numberLabel.leftAnchor.constraint(equalTo: bgView.leftAnchor, constant: 14),

            nameLabel.topAnchor.constraint(equalTo: numberLabel.bottomAnchor, constant: 4),
            nameLabel.leftAnchor.constraint(equalTo: bgView.leftAnchor, constant: 14),
            nameLabel.rightAnchor.constraint(equalTo: bgView.rightAnchor, constant: -14),

            subtitleLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 4),
            subtitleLabel.leftAnchor.constraint(equalTo: bgView.leftAnchor, constant: 14),
            subtitleLabel.rightAnchor.constraint(equalTo: bgView.rightAnchor, constant: -14),

            starsView.bottomAnchor.constraint(equalTo: bgView.bottomAnchor, constant: -12),
            starsView.leftAnchor.constraint(equalTo: bgView.leftAnchor, constant: 14),

            completedBadge.topAnchor.constraint(equalTo: bgView.topAnchor, constant: 10),
            completedBadge.rightAnchor.constraint(equalTo: bgView.rightAnchor, constant: -12),

            tileSample.bottomAnchor.constraint(equalTo: bgView.bottomAnchor, constant: -10),
            tileSample.rightAnchor.constraint(equalTo: bgView.rightAnchor, constant: -12),
            tileSample.widthAnchor.constraint(equalToConstant: 28),
            tileSample.heightAnchor.constraint(equalToConstant: 28)
        ])
    }

    func configure(with level: GameLevel, isCompleted: Bool) {
        numberLabel.text = "LEVEL \(level.id)"
        nameLabel.text = level.name
        subtitleLabel.text = level.subtitle

        // Stars
        starsView.arrangedSubviews.forEach { $0.removeFromSuperview() }
        for i in 1...5 {
            let star = UILabel()
            star.text = i <= level.difficulty ? "★" : "☆"
            star.font = UIFont.systemFont(ofSize: 12)
            star.textColor = i <= level.difficulty
                ? UIColor(red: 1.0, green: 0.82, blue: 0.2, alpha: 1)
                : UIColor.white.withAlphaComponent(0.2)
            starsView.addArrangedSubview(star)
        }

        // Tile color sample from level id
        let sampleValue = ((level.id * 3) % 9) + 1
        tileSample.backgroundColor = UIColor.tileColor(for: sampleValue)

        completedBadge.isHidden = !isCompleted

        // Card styling
        let bgAlpha: CGFloat = isCompleted ? 0.18 : 0.12
        bgView.backgroundColor = UIColor.white.withAlphaComponent(bgAlpha)
        bgView.layer.borderColor = isCompleted
            ? UIColor(red: 0.2, green: 1.0, blue: 0.5, alpha: 0.4).cgColor
            : UIColor.white.withAlphaComponent(0.1).cgColor

        // Shadow
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOpacity = 0.25
        layer.shadowRadius = 8
        layer.shadowOffset = CGSize(width: 0, height: 3)
        layer.masksToBounds = false
        bgView.layer.masksToBounds = true
    }
}
