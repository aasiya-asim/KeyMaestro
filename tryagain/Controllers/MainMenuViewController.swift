//
//  MainMenuViewController.swift
//  tryagain
//
//  Created by Aasiya Memon on 3/31/23.
//


import UIKit

final class MainMenuViewController: UIViewController {
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet var crabImageView: UIImageView!
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        Sound.shared.startMusic("menu jingle.wav", volume: 1)
        Sound.shared.preloadSFX(named: "select.wav")
        titleLabel.textColor = Theme.accent.withAlphaComponent(1)
        startTitleSwim()
        startCrabBob()
        
    }
    
    @IBAction func menuButtonTapped(_ sender: UIButton) {
            Sound.shared.playSFX("select.wav", volume: 0.3)
            UIImpactFeedbackGenerator(style: .light).impactOccurred()
        }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        titleLabel.layer.removeAllAnimations()
        crabImageView.layer.removeAllAnimations()
        Sound.shared.stopMusic()
    }
    
    private func startCrabBob() {
        let bob = CABasicAnimation(keyPath: "transform.translation.y")
        bob.fromValue = 0
        bob.toValue = -4
        bob.duration = 2.6
        bob.autoreverses = true
        bob.repeatCount = .infinity
        bob.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)

        crabImageView.layer.add(bob, forKey: "bob")
    }
    
    private func startTitleSwim() {
        let gradient = CAGradientLayer()
        gradient.frame = titleLabel.bounds

        gradient.colors = [
            UIColor.white.withAlphaComponent(1.0).cgColor,
            UIColor.white.withAlphaComponent(0.8).cgColor,
            UIColor.white.withAlphaComponent(1.0).cgColor
        ]

        gradient.locations = [0, 0.5, 1]
        gradient.startPoint = CGPoint(x: 0, y: 0.5)
        gradient.endPoint = CGPoint(x: 1, y: 0.5)

        titleLabel.layer.mask = gradient

        let anim = CABasicAnimation(keyPath: "locations")
        anim.fromValue = [-1, -0.5, 0]
        anim.toValue = [1, 1.5, 2]
        anim.duration = 4.0
        anim.repeatCount = .infinity
        anim.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)

        gradient.add(anim, forKey: "shimmer")
    }
}
