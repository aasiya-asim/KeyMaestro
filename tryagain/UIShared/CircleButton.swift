//
//  CircleButton.swift
//  tryagain
//
//  Created by Aasiya Memon on 1/23/26.
//


import UIKit

final class CircleButton: UIButton {

    override func layoutSubviews() {
        super.layoutSubviews()

        let d = min(bounds.width, bounds.height)
        layer.cornerRadius = d / 2
        layer.masksToBounds = true

        if #available(iOS 13.0, *) {
            layer.cornerCurve = .continuous
        }
    }
}