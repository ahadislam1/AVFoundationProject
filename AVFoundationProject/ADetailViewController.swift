//
//  ADetailViewController.swift
//  AVFoundationProject
//
//  Created by Ahad Islam on 4/16/20.
//  Copyright © 2020 Ahad Islam. All rights reserved.
//

import UIKit

class ADetailViewController: UIViewController {
    
    private lazy var imagePickerController: UIImagePickerController = {
        let mediaTypes = UIImagePickerController.availableMediaTypes(for: .photoLibrary)
        let pc = UIImagePickerController()
        pc.mediaTypes = mediaTypes ?? ["kUTTypeImage"]
        pc.delegate = self
        return pc
    }()
    
    private lazy var barButton: UIBarButtonItem = {
        let button = UIBarButtonItem(title: "Select", style: .plain, target: self, action: #selector(barButtonPressed))
        return button
    }()
    
    private lazy var imageView: UIImageView = {
        let iv = UIImageView(image: UIImage(systemName: "video"))
        iv.backgroundColor = .systemYellow
        iv.contentMode = .scaleAspectFit
        return iv
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .systemRed
        setupNavigation()
        setupImageView()
    }
    
    @objc
    private func barButtonPressed() {
        let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        let cameraAction = UIAlertAction(title: "Camera", style: .default) { [weak self] alert in
            self?.showPicker(sourceType: .camera)
        }
        let libraryAction = UIAlertAction(title: "Photo Library", style: .default) { [weak self] alert in
            self?.showPicker(sourceType: .photoLibrary)
        }
        
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            alertController.addAction(cameraAction)
        }
        
        alertController.addAction(libraryAction)
        alertController.addAction(cancelAction)
        present(alertController, animated: true)
    }
    
    private func showPicker(sourceType: UIImagePickerController.SourceType) {
        imagePickerController.sourceType = sourceType
        present(imagePickerController, animated: true)
    }
    
    private func setupNavigation() {
        navigationItem.rightBarButtonItem = barButton
    }
    
    private func setupImageView() {
        view.addSubview(imageView)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            imageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            imageView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            imageView.widthAnchor.constraint(equalTo: view.widthAnchor),
            imageView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.5)])
    }
    
    
}

extension ADetailViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
}
