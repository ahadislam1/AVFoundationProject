//
//  AhadCell.swift
//  AVFoundationProject
//
//  Created by Ahad Islam on 4/16/20.
//  Copyright © 2020 Ahad Islam. All rights reserved.
//

import UIKit

class AhadCell: UICollectionViewCell {
    
    private lazy var imageView: UIImageView = {
        let iv = UIImageView(image: UIImage(systemName: "pencil"))
        iv.contentMode = .scaleAspectFit
        return iv
        
    }()
    
    override func layoutSubviews() {
        super.layoutSubviews()
        backgroundColor = .systemPink
        setupImageView()
    }
    
    public func configureCell(_ object: AhadMedia) {
        imageView.image = object.image
    }
    
    private func setupImageView() {
        contentView.addSubview(imageView)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            imageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 8),
            imageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -8),
            imageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8)])
    }
    
}
