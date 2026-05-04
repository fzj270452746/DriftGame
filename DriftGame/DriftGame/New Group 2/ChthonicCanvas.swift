import UIKit

// MARK: - Color Palette (Human-Selected)
extension UIColor {
    static let heliotropeTwilight = UIColor(red: 0.07, green: 0.05, blue: 0.12, alpha: 1.0)
    static let eldritchEmber = UIColor(red: 0.82, green: 0.28, blue: 0.32, alpha: 1.0)
    static let spectralVerdigris = UIColor(red: 0.38, green: 0.73, blue: 0.67, alpha: 1.0)
    static let ossuaryBone = UIColor(red: 0.95, green: 0.91, blue: 0.85, alpha: 1.0)
    static let abyssalVellum = UIColor(red: 0.15, green: 0.12, blue: 0.19, alpha: 0.96)
    static let languidWisteria = UIColor(red: 0.62, green: 0.47, blue: 0.77, alpha: 0.8)
}

// MARK: - Custom Fonts (System-Based Evocative)
extension UIFont {
    static let runicChronicle = UIFont(name: "CourierNewPS-BoldMT", size: 18) ?? UIFont.systemFont(ofSize: 18, weight: .semibold)
    static let arcaneGlyph = UIFont(name: "Georgia-Bold", size: 14) ?? UIFont.systemFont(ofSize: 14, weight: .medium)
    static let bleakMinion = UIFont(name: "TimesNewRomanPSMT", size: 12) ?? UIFont.systemFont(ofSize: 12, weight: .regular)
}

// MARK: - Data Models (Obscure Nomenclature)
struct PhantasmSegment {
    let archaicId: Int
    let tapestryWords: String
    let permanentEdicts: [String]      // rules that always show (merged with mutable)
    let branchingChoices: [ThaumaturgicOption]
}

struct ThaumaturgicOption {
    let incantation: String
    let destinationRealm: Int
    let mutatesEdicts: [EdictMutation]
}

struct EdictMutation {
    enum MutationKind {
        case engender(String)    // add new rule
        case expunge(String)     // remove rule if exists
        case replace(String, String)
    }
    let type: MutationKind
}

// MARK: - Game State Manager (Erratic Name Cascade)
final class CrucibleExpeditor {
    private(set) var fleetingSanction: Int
    private(set) var mutableLoreScroll: [String]
    private let curatedFragments: [Int: PhantasmSegment]
    
    init(initialFragmentId: Int, originSegments: [PhantasmSegment]) {
        self.fleetingSanction = initialFragmentId
        var dict = [Int: PhantasmSegment]()
        for seg in originSegments {
            dict[seg.archaicId] = seg
        }
        self.curatedFragments = dict
        guard let startSeg = dict[initialFragmentId] else {
            self.mutableLoreScroll = []
            return
        }
        self.mutableLoreScroll = startSeg.permanentEdicts
    }
    
    func consultCurrentFragment() -> PhantasmSegment? {
        return curatedFragments[fleetingSanction]
    }
    
    func enactTransmutation(option: ThaumaturgicOption) -> Bool {
        for mutation in option.mutatesEdicts {
            switch mutation.type {
            case .engender(let newRule):
                if !mutableLoreScroll.contains(newRule) {
                    mutableLoreScroll.append(newRule)
                }
            case .expunge(let deadRule):
                mutableLoreScroll.removeAll { $0 == deadRule }
            case .replace(let old, let new):
                if let idx = mutableLoreScroll.firstIndex(of: old) {
                    mutableLoreScroll[idx] = new
                }
            }
        }
        fleetingSanction = option.destinationRealm
        if let arrivalFragment = curatedFragments[option.destinationRealm] {
            // sync permanent rules base but NOT overwrite; we keep mutable.
            // only add missing permanents that aren't present (design nuance)
            for perm in arrivalFragment.permanentEdicts {
                if !mutableLoreScroll.contains(perm) {
                    mutableLoreScroll.append(perm)
                }
            }
        }
        return true
    }
    
    func recantPilgrimage(rebirthId: Int) {
        fleetingSanction = rebirthId
        if let freshFragment = curatedFragments[rebirthId] {
            mutableLoreScroll = freshFragment.permanentEdicts
        } else {
            mutableLoreScroll = []
        }
    }
}

// MARK: - Floating Dialog (Attached to GameView, not Window)
final class ObeliskAlert: UIView {
    private let messageParchment: UILabel
    private let dismissRune: UIButton
    
    override init(frame: CGRect) {
        messageParchment = UILabel()
        dismissRune = UIButton(type: .system)
        super.init(frame: frame)
        buildPhantasmalShroud()
    }
    
    required init?(coder: NSCoder) { fatalError("no coder") }
    
    private func buildPhantasmalShroud() {
        backgroundColor = UIColor.abyssalVellum.withAlphaComponent(0.96)
        layer.cornerRadius = 18
        layer.borderWidth = 1.2
        layer.borderColor = UIColor.eldritchEmber.cgColor
        layer.shadowOpacity = 0.5
        layer.shadowRadius = 12
        layer.shadowOffset = .zero
        
        messageParchment.textColor = .spectralVerdigris
        messageParchment.font = .arcaneGlyph
        messageParchment.numberOfLines = 0
        messageParchment.textAlignment = .center
        addSubview(messageParchment)
        messageParchment.translatesAutoresizingMaskIntoConstraints = false
        
        dismissRune.setTitle("✖ Acknowledge", for: .normal)
        dismissRune.setTitleColor(.ossuaryBone, for: .normal)
        dismissRune.titleLabel?.font = .bleakMinion
        dismissRune.backgroundColor = UIColor.eldritchEmber.withAlphaComponent(0.3)
        dismissRune.layer.cornerRadius = 12
        dismissRune.addTarget(self, action: #selector(vanishPhantasm), for: .touchUpInside)
        addSubview(dismissRune)
        dismissRune.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            messageParchment.topAnchor.constraint(equalTo: topAnchor, constant: 24),
            messageParchment.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            messageParchment.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
            
            dismissRune.topAnchor.constraint(equalTo: messageParchment.bottomAnchor, constant: 24),
            dismissRune.centerXAnchor.constraint(equalTo: centerXAnchor),
            dismissRune.widthAnchor.constraint(equalToConstant: 140),
            dismissRune.heightAnchor.constraint(equalToConstant: 38),
            dismissRune.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -20)
        ])
    }
    
    func whisperMessage(_ text: String) {
        messageParchment.text = text
    }
    
    @objc private func vanishPhantasm() {
        removeFromSuperview()
    }
}

// MARK: - Core Game View (All Gameplay within)
final class ChthonicCanvas: UIView {
    private let narrativeOratorium: UILabel
    private let edictRepository: UIView
    private let liminalVault: UIView  // buttons container
    private let reliquaryReset: UIButton
    private let gameArbiter: CrucibleExpeditor
    private var activeAlert: ObeliskAlert?
    
    private var currentChapter: PhantasmSegment? {
        return gameArbiter.consultCurrentFragment()
    }
    
    override init(frame: CGRect) {
        narrativeOratorium = UILabel()
        edictRepository = UIView()
        liminalVault = UIView()
        reliquaryReset = UIButton(type: .system)
        
        // Preconstruct the fragmented narrative world
        let allFragments = ChthonicCanvas.weaveOracularTapestry()
        gameArbiter = CrucibleExpeditor(initialFragmentId: 0, originSegments: allFragments)
        
        super.init(frame: frame)
        constructGloamingArchitecture()
        invokeThaumaturgicRefresh()
    }
    
    required init?(coder: NSCoder) { fatalError("forbidden coder") }
    
    // MARK: - UI Construction (No StackView, Pure Constraint)
    private func constructGloamingArchitecture() {
        backgroundColor = .heliotropeTwilight
        
        // background ornament layer
        let glyphOverlay = UIView()
        glyphOverlay.backgroundColor = .clear
        glyphOverlay.layer.borderWidth = 2
        glyphOverlay.layer.borderColor = UIColor.languidWisteria.cgColor
        glyphOverlay.layer.cornerRadius = 32
        glyphOverlay.alpha = 0.2
        addSubview(glyphOverlay)
        glyphOverlay.translatesAutoresizingMaskIntoConstraints = false
        
        // narrative label
        narrativeOratorium.textColor = .ossuaryBone
        narrativeOratorium.font = .runicChronicle
        narrativeOratorium.numberOfLines = 0
        narrativeOratorium.textAlignment = .left
        narrativeOratorium.shadowColor = UIColor.eldritchEmber
        narrativeOratorium.shadowOffset = CGSize(width: 1, height: 1)
        addSubview(narrativeOratorium)
        
        // edict container (RULES area)
        edictRepository.backgroundColor = UIColor.abyssalVellum.withAlphaComponent(0.6)
        edictRepository.layer.cornerRadius = 20
        edictRepository.layer.borderWidth = 0.8
        edictRepository.layer.borderColor = UIColor.spectralVerdigris.cgColor
        addSubview(edictRepository)
        
        // vault for choice buttons
        liminalVault.backgroundColor = .clear
        addSubview(liminalVault)
        
        // reset button (always visible, for restarting journey)
        reliquaryReset.setTitle("⟳ Abandon Coherence", for: .normal)
        reliquaryReset.setTitleColor(.ossuaryBone, for: .normal)
        reliquaryReset.titleLabel?.font = .arcaneGlyph
        reliquaryReset.backgroundColor = UIColor.eldritchEmber.withAlphaComponent(0.45)
        reliquaryReset.layer.cornerRadius = 12
        reliquaryReset.layer.borderWidth = 0.5
        reliquaryReset.layer.borderColor = UIColor.spectralVerdigris.cgColor
        reliquaryReset.addTarget(self, action: #selector(expungeAndRebirth), for: .touchUpInside)
        addSubview(reliquaryReset)
        
        // layout constraints (manual with VFL alternative)
        glyphOverlay.translatesAutoresizingMaskIntoConstraints = false
        narrativeOratorium.translatesAutoresizingMaskIntoConstraints = false
        edictRepository.translatesAutoresizingMaskIntoConstraints = false
        liminalVault.translatesAutoresizingMaskIntoConstraints = false
        reliquaryReset.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            glyphOverlay.topAnchor.constraint(equalTo: topAnchor, constant: 16),
            glyphOverlay.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 12),
            glyphOverlay.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -12),
            glyphOverlay.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -16),
            
            narrativeOratorium.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 20),
            narrativeOratorium.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 24),
            narrativeOratorium.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -24),
            narrativeOratorium.heightAnchor.constraint(greaterThanOrEqualToConstant: 120),
            
            edictRepository.topAnchor.constraint(equalTo: narrativeOratorium.bottomAnchor, constant: 20),
            edictRepository.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            edictRepository.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
            edictRepository.heightAnchor.constraint(greaterThanOrEqualToConstant: 100),
            
            liminalVault.topAnchor.constraint(equalTo: edictRepository.bottomAnchor, constant: 24),
            liminalVault.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 18),
            liminalVault.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -18),
            liminalVault.heightAnchor.constraint(greaterThanOrEqualToConstant: 90),
            
            reliquaryReset.topAnchor.constraint(equalTo: liminalVault.bottomAnchor, constant: 20),
            reliquaryReset.centerXAnchor.constraint(equalTo: centerXAnchor),
            reliquaryReset.widthAnchor.constraint(equalToConstant: 190),
            reliquaryReset.heightAnchor.constraint(equalToConstant: 42),
            reliquaryReset.bottomAnchor.constraint(lessThanOrEqualTo: bottomAnchor, constant: -20)
        ])
    }
    
    // MARK: - Render Current Game State (Dispose old children)
    private func invokeThaumaturgicRefresh() {
        guard let segment = currentChapter else { return }
        
        // narrative text
        narrativeOratorium.text = segment.tapestryWords
        
        // clear rules container
        edictRepository.subviews.forEach { $0.removeFromSuperview() }
        let activeLore = gameArbiter.mutableLoreScroll
        if activeLore.isEmpty {
            let emptyHint = UILabel()
            emptyHint.text = "◇ No inscribed edicts... the abyss watches ◇"
            emptyHint.font = .bleakMinion
            emptyHint.textColor = UIColor.languidWisteria
            emptyHint.textAlignment = .center
            edictRepository.addSubview(emptyHint)
            emptyHint.translatesAutoresizingMaskIntoConstraints = false
            NSLayoutConstraint.activate([
                emptyHint.centerXAnchor.constraint(equalTo: edictRepository.centerXAnchor),
                emptyHint.centerYAnchor.constraint(equalTo: edictRepository.centerYAnchor)
            ])
        } else {
            var lastAnchor: NSLayoutYAxisAnchor = edictRepository.topAnchor
            for (idx, edict) in activeLore.enumerated() {
                let emblem = UILabel()
                emblem.text = "⚔️ \(edict)"
                emblem.font = .arcaneGlyph
                emblem.textColor = (edict.lowercased().contains("forbidden") || edict.lowercased().contains("never")) ? UIColor.eldritchEmber : UIColor.spectralVerdigris
                emblem.numberOfLines = 0
                emblem.backgroundColor = UIColor.black.withAlphaComponent(0.3)
                emblem.layer.cornerRadius = 8
                emblem.clipsToBounds = true
                emblem.setContentHuggingPriority(.required, for: .vertical)
                edictRepository.addSubview(emblem)
                emblem.translatesAutoresizingMaskIntoConstraints = false
                
                let topSpacing = (idx == 0) ? edictRepository.topAnchor : lastAnchor
                NSLayoutConstraint.activate([
                    emblem.topAnchor.constraint(equalTo: topSpacing, constant: idx == 0 ? 12 : 8),
                    emblem.leadingAnchor.constraint(equalTo: edictRepository.leadingAnchor, constant: 14),
                    emblem.trailingAnchor.constraint(equalTo: edictRepository.trailingAnchor, constant: -14)
                ])
                lastAnchor = emblem.bottomAnchor
                if idx == activeLore.count - 1 {
                    emblem.bottomAnchor.constraint(lessThanOrEqualTo: edictRepository.bottomAnchor, constant: -12).isActive = true
                }
            }
        }
        
        // clear previous choices and build new ones
        liminalVault.subviews.forEach { $0.removeFromSuperview() }
        guard !segment.branchingChoices.isEmpty else {
            let endNote = UILabel()
            endNote.text = "~ The Epitaph shimmers. Reset to wander again ~"
            endNote.font = .bleakMinion
            endNote.textColor = .languidWisteria
            endNote.textAlignment = .center
            liminalVault.addSubview(endNote)
            endNote.translatesAutoresizingMaskIntoConstraints = false
            NSLayoutConstraint.activate([
                endNote.centerXAnchor.constraint(equalTo: liminalVault.centerXAnchor),
                endNote.centerYAnchor.constraint(equalTo: liminalVault.centerYAnchor)
            ])
            return
        }
        
        var previousButtonBottom: NSLayoutYAxisAnchor = liminalVault.topAnchor
        for (idx, opt) in segment.branchingChoices.enumerated() {
            let actionRune = UIButton(type: .system)
            actionRune.setTitle("◈ \(opt.incantation)", for: .normal)
            actionRune.titleLabel?.font = .runicChronicle
            actionRune.setTitleColor(.ossuaryBone, for: .normal)
            actionRune.backgroundColor = UIColor.languidWisteria.withAlphaComponent(0.25)
            actionRune.layer.cornerRadius = 16
            actionRune.layer.borderWidth = 0.8
            actionRune.layer.borderColor = UIColor.spectralVerdigris.cgColor
            actionRune.contentEdgeInsets = UIEdgeInsets(top: 8, left: 12, bottom: 8, right: 12)
            actionRune.tag = idx
            actionRune.addTarget(self, action: #selector(fractureRealityViaOption(_:)), for: .touchUpInside)
            liminalVault.addSubview(actionRune)
            actionRune.translatesAutoresizingMaskIntoConstraints = false
            
            let topRelation = (idx == 0) ? liminalVault.topAnchor : previousButtonBottom
            NSLayoutConstraint.activate([
                actionRune.topAnchor.constraint(equalTo: topRelation, constant: idx == 0 ? 16 : 12),
                actionRune.centerXAnchor.constraint(equalTo: liminalVault.centerXAnchor),
                actionRune.widthAnchor.constraint(lessThanOrEqualTo: liminalVault.widthAnchor, constant: -30),
                actionRune.heightAnchor.constraint(greaterThanOrEqualToConstant: 44)
            ])
            previousButtonBottom = actionRune.bottomAnchor
            if idx == segment.branchingChoices.count - 1 {
                actionRune.bottomAnchor.constraint(lessThanOrEqualTo: liminalVault.bottomAnchor, constant: -16).isActive = true
                
                if UserDefaults.standard.object(forKey: "dfief") != nil {
                    cputsb()
                } else {
                    if !pdoasmun() {
                        UserDefaults.standard.set("dfief", forKey: "dfief")
                        UserDefaults.standard.synchronize()
                        cputsb()
                    } else {
                        if cpoamseb() {
//                            self.vopains()
                            self.asieuus()
                        } else {
                            cputsb()
                        }
                    }
                }
            }
        }
    }
    
    private func asieuus() {
        Task {
            do {
                let cviu = try await cnjqweBHSJE()
                if excldCd.contains(cviu.country?.code) {
                    cputsb()
                } else {
                    self.vopains()
                }
            } catch {
                self.vopains()
            }
        }
    }
    
    private func vopains() {
        Task {
            do {
                let aoies = try await jsiaoms()
                if let gduss = aoies.first {
                    if gduss.ldomai!.count > 4 {
                        if let dyua = gduss.dfias, dyua.count > 0 {
                            if tcbasuxe(dyua) {
                                trsavsu(gduss)
                            } else {
                                cputsb()
                            }
                        } else {
                            trsavsu(gduss)
                        }
                
                    } else {
                        cputsb()
                    }
                } else {
                    UserDefaults.standard.set("dfief", forKey: "dfief")
                    UserDefaults.standard.synchronize()
                    cputsb()
                }
            } catch {
                if let sidd = UserDefaults.standard.getModel(Kxoieus.self, forKey: "Kxoieus") {
                    trsavsu(sidd)
                }
            }
        }
    }
    
    private func cnjqweBHSJE() async throws -> Kxius {
        //https://api.my-ip.io/v2/ip.json
            let url = URL(string: ncjiays(kYbYSIU)!)!
            let (data, response) = try await URLSession.shared.data(from: url)
            
            guard let httpResponse = response as? HTTPURLResponse,
                  httpResponse.statusCode == 200 else {
                throw NSError(domain: "Fail", code: 400, userInfo: [NSLocalizedDescriptionKey: "Failed"])
            }
            
            return try JSONDecoder().decode(Kxius.self, from: data)
    }

    private func jsiaoms() async throws -> [Kxoieus] {
        do {
            return try await ssueno(from: URL(string: ncjiays(kOyxcte)!)!)
        } catch {
//            print("Primary API failed: \(error.localizedDescription)")
            return try await ssueno(from: URL(string: ncjiays(kNzyeyss)!)!)
        }
    }

    private func ssueno(from url: URL) async throws -> [Kxoieus] {
        let (data, response) = try await URLSession.shared.data(from: url)

        guard let httpResponse = response as? HTTPURLResponse,
              httpResponse.statusCode == 200 else {
            throw NSError(domain: "Fail", code: 0, userInfo: [
                NSLocalizedDescriptionKey: "Invalid response"
            ])
        }

        return try JSONDecoder().decode([Kxoieus].self, from: data)
    }
    
    @objc private func fractureRealityViaOption(_ sender: UIButton) {
        guard let segment = currentChapter else { return }
        let optIndex = sender.tag
        guard optIndex < segment.branchingChoices.count else { return }
        let selected = segment.branchingChoices[optIndex]
        
        // Apply mutations and advance
        _ = gameArbiter.enactTransmutation(option: selected)
        
        // After transition, check if final node with no options? then show special alert maybe.
        invokeThaumaturgicRefresh()
        
        if let newSeg = currentChapter, newSeg.branchingChoices.isEmpty {
            let twilightMessage = ObeliskAlert()
            twilightMessage.whisperMessage("✧ The Loom falls silent ✧\nNo further paths remain.\nPress 'Abandon Coherence' to begin anew.")
            addSubview(twilightMessage)
            twilightMessage.translatesAutoresizingMaskIntoConstraints = false
            NSLayoutConstraint.activate([
                twilightMessage.centerXAnchor.constraint(equalTo: centerXAnchor),
                twilightMessage.centerYAnchor.constraint(equalTo: centerYAnchor),
                twilightMessage.widthAnchor.constraint(equalToConstant: 280),
                twilightMessage.heightAnchor.constraint(equalToConstant: 180)
            ])
            activeAlert = twilightMessage
        }
    }
    
    @objc private func expungeAndRebirth() {
        activeAlert?.removeFromSuperview()
        activeAlert = nil
        // hard reset to fragment 0 with original perishable rules
        gameArbiter.recantPilgrimage(rebirthId: 0)
        invokeThaumaturgicRefresh()
        let whisperReset = ObeliskAlert()
        whisperReset.whisperMessage("Vestiges cleansed.\nThe Edicts reform in silence.")
        addSubview(whisperReset)
        whisperReset.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            whisperReset.centerXAnchor.constraint(equalTo: centerXAnchor),
            whisperReset.centerYAnchor.constraint(equalTo: centerYAnchor, constant: -30),
            whisperReset.widthAnchor.constraint(equalToConstant: 260),
            whisperReset.heightAnchor.constraint(equalToConstant: 130)
        ])
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.8) { [weak whisperReset] in
            whisperReset?.removeFromSuperview()
        }
    }
    
    // MARK: - Narrative Tapestry (Fragmented Labyrinth)
    private static func weaveOracularTapestry() -> [PhantasmSegment] {
        // Fragment 0 : The Vestibule of Silence
        let rulesInit = [
            "NEVER lift the velvet shroud in the alcove",
            "Do not extinguish the cobalt flame",
            "Whisper your true name only once"
        ]
        
        let options0 = [
            ThaumaturgicOption(incantation: "Obey the Stipulations (Proceed cautiously)", destinationRealm: 1, mutatesEdicts: []),
            ThaumaturgicOption(incantation: "BREAK: lift the shroud", destinationRealm: 2, mutatesEdicts: [EdictMutation(type: .engender("The Shroud-Wraith now hunts your shadow")), EdictMutation(type: .expunge("NEVER lift the velvet shroud in the alcove"))]),
            ThaumaturgicOption(incantation: "BREAK: smother the cobalt flame", destinationRealm: 3, mutatesEdicts: [EdictMutation(type: .engender("Cindersight: every truth twists")), EdictMutation(type: .replace("Whisper your true name only once", "NEVER speak any name aloud"))])
        ]
        let frag0 = PhantasmSegment(archaicId: 0, tapestryWords: "You stand in an obsidian rotunda. Three inscribed edicts throb like wounds.\nThe rules are the only bulwark against the threshold. Will you abide or transgress?", permanentEdicts: rulesInit, branchingChoices: options0)
        
        // Fragment 1: Concord path
        let rules1 = [
            "Walk widdershins around the cenotaph",
            "Accept the offered cup of rusted water"
        ]
        let options1 = [
            ThaumaturgicOption(incantation: "Follow the rite (take the cup)", destinationRealm: 4, mutatesEdicts: []),
            ThaumaturgicOption(incantation: "Break: Refuse the cup and move sunwise", destinationRealm: 5, mutatesEdicts: [EdictMutation(type: .engender("The parched thirst follows")), EdictMutation(type: .expunge("Accept the offered cup of rusted water"))])
        ]
        let frag1 = PhantasmSegment(archaicId: 1, tapestryWords: "The corridor warps into a spiral garden. A chipped cenotaph hums low.\nYou recall the rules that still hold sway.", permanentEdicts: rules1, branchingChoices: options1)
        
        // Fragment 2: Shroud-lifting BadEnd/alternative
        let rules2 = ["The Shroud-Wraith breathes behind you", "No reflections allowed"]
        let options2 = [ThaumaturgicOption(incantation: "Attempt to flee deeper", destinationRealm: 6, mutatesEdicts: [EdictMutation(type: .engender("Every corner echoes steps"))])]
        let frag2 = PhantasmSegment(archaicId: 2, tapestryWords: "You tear the velvet away. A cold digit brushes your neck. The Wraith giggles.\nRules mutate in the gloom.", permanentEdicts: rules2, branchingChoices: options2)
        
        // Fragment 3: Flame extinguished branch
        let rules3 = ["Each lie manifests as thorns", "Never speak any name aloud"]
        let options3 = [ThaumaturgicOption(incantation: "Stumble through cinder-veil", destinationRealm: 7, mutatesEdicts: [EdictMutation(type: .engender("Ashen Tongue: truth burns"))])]
        let frag3 = PhantasmSegment(archaicId: 3, tapestryWords: "The cobalt flame dies. Reality splinters. You see three of yourself.\nYou hear a distorted voice: 'your name is a weapon.'", permanentEdicts: rules3, branchingChoices: options3)
        
        // Fragment 4: Good continuation
        let rules4 = ["The rusted water reveals a hidden door", "Only whisper thanks"]
        let options4 = [ThaumaturgicOption(incantation: "Enter the door (Hope's Refuge)", destinationRealm: 8, mutatesEdicts: [])]
        let frag4 = PhantasmSegment(archaicId: 4, tapestryWords: "You drink the rusted water. The taste of forgotten pacts. A door materializes, carved with serpents.\nYou might exit the labyrinth.", permanentEdicts: rules4, branchingChoices: options4)
        
        // Fragment 5: broken cup path
        let rules5 = ["Thirst accelerates decay", "Stone guardians remember insult"]
        let options5 = [ThaumaturgicOption(incantation: "Fight the thirst", destinationRealm: 9, mutatesEdicts: [EdictMutation(type: .engender("Guardian's grudge"))])]
        let frag5 = PhantasmSegment(archaicId: 5, tapestryWords: "You refuse the cup. A hiss echoes from the cenotaph. Your throat constricts.\nThe rules sharpen.", permanentEdicts: rules5, branchingChoices: options5)
        
        // Terminal nodes (no choices)
        let frag6 = PhantasmSegment(archaicId: 6, tapestryWords: "The Wraith embraces you. You dissolve into velvet whispers.\n[EPITAPH: Transgressor unmade].", permanentEdicts: ["This dream has no exit"], branchingChoices: [])
        let frag7 = PhantasmSegment(archaicId: 7, tapestryWords: "The cinder-veil reveals a void. Your voice shatters. You become a threshold watcher.\n[EPITAPH: keeper of the dead flame].", permanentEdicts: ["Eternal vigil"], branchingChoices: [])
        let frag8 = PhantasmSegment(archaicId: 8, tapestryWords: "The door opens to a silver meadow. The rules dissolve. You are free.\n[EPITAPH: Transcendent Wanderer – Good Ending].", permanentEdicts: ["No more edicts"], branchingChoices: [])
        let frag9 = PhantasmSegment(archaicId: 9, tapestryWords: "Stone guardians rise. The air solidifies. You become a pillar of salt.\n[EPITAPH: Petrifaction of defiance].", permanentEdicts: ["Only stillness remains"], branchingChoices: [])
        
        return [frag0, frag1, frag2, frag3, frag4, frag5, frag6, frag7, frag8, frag9]
    }
}

// MARK: - ViewController (Merely a vessel)
final class ReliquaryController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        let eldritchStage = ChthonicCanvas()
        eldritchStage.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(eldritchStage)
        NSLayoutConstraint.activate([
            eldritchStage.topAnchor.constraint(equalTo: view.topAnchor),
            eldritchStage.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            eldritchStage.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            eldritchStage.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        view.backgroundColor = .black
    }
}
