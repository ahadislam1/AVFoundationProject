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
        iv.layer.cornerRadius = 5
        iv.clipsToBounds = true
        return iv
    }()
    
    private lazy var textField: UITextField = {
        let tf = UITextField()
        tf.backgroundColor = .secondarySystemBackground
        tf.borderStyle = .bezel
        return tf
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureView()
        let x = imageView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.9)
        print(x)
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
    
    fileprivate func configureView() {
        view.backgroundColor = .systemRed
        setupNavigation()
        setupImageView()
        setupTextField()
    }
    
    private func setupNavigation() {
        navigationItem.rightBarButtonItem = barButton
    }
    
    private func setupImageView() {
        view.addSubview(imageView)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            imageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            imageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 12),
            imageView.widthAnchor.constraint(equalToConstant: view.frame.width - 24),
            imageView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.33)])
    }
    
    private func setupTextField() {
        view.addSubview(textField)
        textField.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            textField.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 20),
            textField.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            textField.widthAnchor.constraint(equalToConstant: view.frame.width / 2)])
    }
    
    
}

extension ADetailViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
}
