//
//  ActivityCell.swift
//  AVFoundationProject
//
//  Created by Ahad Islam on 4/16/20.
//  Copyright © 2020 Ahad Islam. All rights reserved.
//

import UIKit

class ActivityCell: UICollectionViewCell {
    
    private lazy var titleLabel: UILabel = {
        let l = UILabel()
        l.textColor = UIColor.label
        l.font = UIFont.preferredFont(forTextStyle: .headline)
        l.font = l.font.withSize(24)
        return l
    }()
    
    private lazy var detailLabel: UILabel = {
        let l = UILabel()
        l.textColor = UIColor.label
        l.font = UIFont.preferredFont(forTextStyle: .subheadline)
        return l
    }()
    
    override func layoutSubviews() {
        super.layoutSubviews()
        setupView()
    }
    
    public func configureLabels(_ activity: (String, String)) {
        titleLabel.text = activity.0
        detailLabel.text = activity.1
    }
    
    private func setupView() {
        setupGradient()
        configureTitleLabel()
        configureDetailLabel()
    }
    
    private func setupGradient() {
        layer.masksToBounds = true
        layer.cornerRadius = 12
        let gradientLayer = CAGradientLayer()
        gradientLayer.type = .radial
        let colors = [UIColor.white.cgColor, UIColor.systemGray.cgColor]
        gradientLayer.startPoint = CGPoint(x: 0.5, y: 0.5)
        gradientLayer.endPoint = CGPoint(x: 1.5, y: 1.5)
        gradientLayer.frame = bounds
        gradientLayer.opacity = 0.3
        gradientLayer.shouldRasterize = true
        gradientLayer.colors = colors
        layer.addSublayer(gradientLayer)
    }
    
    private func configureTitleLabel() {
        contentView.addSubview(titleLabel)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            titleLabel.bottomAnchor.constraint(equalTo: contentView.centerYAnchor, constant: -12),
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 8),
            titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -8)
        ])
    }
    
    private func configureDetailLabel() {
        contentView.addSubview(detailLabel)
        detailLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            detailLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant:  6),
            detailLabel.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            detailLabel.trailingAnchor.constraint(equalTo: titleLabel.trailingAnchor)])
    }
    
    
    
}
