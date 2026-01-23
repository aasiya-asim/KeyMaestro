//
//  DoneViewController.swift
//  tryagain
//
//  Created by Aasiya Memon on 5/18/23.
//

import UIKit

final class DoneViewController: UIViewController {
    @IBOutlet weak var titleLabel: UILabel?
    @IBOutlet weak var resultLabel: UILabel?
    @IBOutlet weak var statsLabel: UILabel?
    @IBOutlet weak var mainButton: UIButton?

    var score: Int = 0
    var attemptsUsed: Int = 0
    var target: Int = 0

    override func viewDidLoad() {
        super.viewDidLoad()
        Sound.shared.preloadSFX(named: "silly crowd cheer.wav")
        Sound.shared.preloadSFX(named: "confetti pop.wav")
        Sound.shared.preloadSFX(named: "select.wav")
        configureUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        Sound.shared.stopMusic()
    }

    private func configureUI() {
        view.backgroundColor = .systemBackground

        let accuracy = Double(score) / Double(max(attemptsUsed, 1))
        let percent = NumberFormatter.localizedString(from: NSNumber(value: accuracy), number: .percent)
        let isPerfect = (attemptsUsed == score)
        Sound.shared.playSFX("silly crowd cheer.wav", volume: 0.5)
        Sound.shared.playSFX("confetti pop.wav", volume: 0.3)

        if isPerfect { titleLabel?.text = "STELLAR!" }
        else if accuracy >= 0.80 { titleLabel?.text = "Great job!" }
        else if accuracy >= 0.60 { titleLabel?.text = "Nice work!" }
        else { titleLabel?.text = "You’re getting there!" }

        titleLabel?.font = .preferredFont(forTextStyle: .largeTitle)
        titleLabel?.adjustsFontForContentSizeCategory = true

        resultLabel?.text = "\(score) questions / \(attemptsUsed) attempts"
        resultLabel?.font = .preferredFont(forTextStyle: .title2)
        statsLabel?.text = "Accuracy: \(percent)"
        statsLabel?.textColor = .secondaryLabel

        styleButton(mainButton, title: "Main Menu", filled: true)
        
        celebrate()

        //if isPerfect { celebrateIfPerfect() }
    }

    private func styleButton(_ button: UIButton?, title: String, filled: Bool) {
        guard let b = button else { return }

        // wipe any storyboard text/config
        b.setTitle(nil, for: .normal)
        b.setAttributedTitle(nil, for: .normal)

        var config: UIButton.Configuration = filled ? .filled() : .plain()
        config.attributedTitle = AttributedString(title)
        config.baseBackgroundColor = filled ? Theme.accent : .clear
        config.baseForegroundColor = filled ? .white : Theme.accent
        config.cornerStyle = .large
        config.contentInsets = .init(top: 12, leading: 18, bottom: 12, trailing: 18)

        if !filled {
            var bg = UIBackgroundConfiguration.clear()
            bg.strokeColor = Theme.accent
            bg.strokeWidth = 1
            config.background = bg
        }

        b.configuration = config

        // lock it in across state changes
        b.configurationUpdateHandler = { btn in
            var c = btn.configuration ?? (filled ? .filled() : .plain())
            c.attributedTitle = AttributedString(title)
            c.baseBackgroundColor = filled ? Theme.accent : .clear
            c.baseForegroundColor = filled ? .white : Theme.accent
            if !filled {
                var bg = UIBackgroundConfiguration.clear()
                bg.strokeColor = Theme.accent
                bg.strokeWidth = 1
                c.background = bg
            }
            c.cornerStyle = .large
            c.contentInsets = .init(top: 12, leading: 18, bottom: 12, trailing: 18)
            btn.configuration = c
        }
    }

    private func celebrate() {
        // pretint for color
        let starYellow = UIColor(red: 217/255, green: 156/255, blue: 56/255, alpha: 1)
        let symbolCfg = UIImage.SymbolConfiguration(pointSize: 22, weight: .regular, scale: .medium)
        guard let baseSymbol = UIImage(systemName: "star.fill", withConfiguration: symbolCfg) else { return }
        let colored = baseSymbol.withTintColor(starYellow, renderingMode: .alwaysOriginal)

        let fmt = UIGraphicsImageRendererFormat()
        fmt.opaque = false
        fmt.scale  = UIScreen.main.scale
        let renderer = UIGraphicsImageRenderer(size: colored.size, format: fmt)
        let starImage = renderer.image { _ in
            colored.draw(in: CGRect(origin: .zero, size: colored.size))
        }
        guard let starCG = starImage.cgImage else { return }

        let emitter = CAEmitterLayer()
        emitter.emitterPosition = CGPoint(x: view.bounds.midX, y: -10)
        emitter.emitterShape = .line
        emitter.emitterSize = CGSize(width: view.bounds.width, height: 1)
        emitter.renderMode = .unordered
        emitter.zPosition = 10_000
        emitter.beginTime = CACurrentMediaTime()

        let cell = CAEmitterCell()
        cell.contents = starCG
        cell.contentsScale = UIScreen.main.scale

        // density / timing
        cell.birthRate = 20
        cell.lifetime = 2.6
        cell.lifetimeRange = 0.6

        // motion
        cell.velocity = 330
        cell.velocityRange = 80
        cell.yAcceleration = 320
        cell.emissionLongitude = .pi
        cell.emissionRange = .pi / 12

        // size / spin
        cell.scale = 0.9
        cell.scaleRange = 0.35
        cell.spin = 2
        cell.spinRange = 3

        emitter.emitterCells = [cell]
        view.layer.addSublayer(emitter)

        // stop spawning after 1.5s, then remove layer
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
            emitter.birthRate = 0
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) {
            emitter.removeFromSuperlayer()
        }

        UINotificationFeedbackGenerator().notificationOccurred(.success)
    }
  
    // MARK: - Actions
    @IBAction func goHomeTapped(_ sender: Any) {
        Sound.shared.playSFX("select.wav", volume: 0.3)
        // If embedded in a navigation controller, pop to the root menu.
        if let nav = navigationController {
            nav.popToRootViewController(animated: true)
            return
        }
        // If this VC (or its ancestors) were presented modally, dismiss the stack.
        view.window?.rootViewController?.dismiss(animated: true)
    }
}
