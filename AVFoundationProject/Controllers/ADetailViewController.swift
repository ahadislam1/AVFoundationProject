//
//  ADetailViewController.swift
//  AVFoundationProject
//
//  Created by Ahad Islam on 4/16/20.
//  Copyright © 2020 Ahad Islam. All rights reserved.
//

import UIKit

protocol ADetailViewControllerDelegate: AnyObject {
    func didPressDone(_ object: CDMediaObject)
}

class ADetailViewController: UIViewController {
    
    private lazy var imagePickerController: UIImagePickerController = {
        let mediaTypes = UIImagePickerController.availableMediaTypes(for: .photoLibrary)
        let pc = UIImagePickerController()
        pc.mediaTypes = mediaTypes ?? ["kUTTypeImage"]
        pc.delegate = self
        return pc
    }()
    
    private lazy var selectBarButton: UIBarButtonItem = {
        let button = UIBarButtonItem(title: "Select", style: .plain, target: self, action: #selector(selectBarButtonPressed))
        return button
    }()
    
    private lazy var doneButton: UIBarButtonItem = {
        let button = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(doneButtonPressed))
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
    
    weak var delegate: ADetailViewControllerDelegate?
    
    var object: AhadMedia?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureView()
        let x = imageView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.9)
        print(x)
    }
    
    @objc
    private func selectBarButtonPressed() {
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
    
    @objc
    private func doneButtonPressed() {
        if let object = object, let image = object.image {
            // TODO: Rewrite.
            let newImage = textToImage(drawText: textField.text ?? "text", inImage: image, atPoint: CGPoint(x: image.size.width * 0.5, y: image.size.height * 0.2))
            let newObject = CoreDataManager.shared.createMediaObject((newImage?.jpegData(compressionQuality: 1.0))!, videoURL: object.videoURL)
            delegate?.didPressDone(newObject)
        }
        navigationController?.popViewController(animated: true)
    }
    
    private func showPicker(sourceType: UIImagePickerController.SourceType) {
        imagePickerController.sourceType = sourceType
        present(imagePickerController, animated: true)
    }
    
    private func textToImage(drawText text: String, inImage image: UIImage, atPoint point: CGPoint) -> UIImage? {
        let textColor = UIColor.white
        let textFont = UIFont.systemFont(ofSize: image.size.width / 24)
        
        let scale = UIScreen.main.scale
        print("Image size is: \(image.size)")
        UIGraphicsBeginImageContextWithOptions(image.size, false, scale)
        
        let textFontAttributes = [
            NSAttributedString.Key.font: textFont,
        NSAttributedString.Key.foregroundColor: textColor,
        NSAttributedString.Key.strokeColor: UIColor.systemFill]
            as [NSAttributedString.Key: Any]
        image.draw(in: CGRect(origin: CGPoint.zero, size: image.size))
        let rect = CGRect(origin: point, size: image.size)
        text.draw(in: rect, withAttributes: textFontAttributes)
        
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return newImage
    }
    
    fileprivate func configureView() {
        view.backgroundColor = .systemRed
        setupNavigation()
        setupImageView()
        setupTextField()
    }
    
    private func setupNavigation() {
        navigationItem.rightBarButtonItems = [doneButton, selectBarButton]
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
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let mediaType = info[UIImagePickerController.InfoKey.mediaType] as? String else {
            return
        }
        
        switch mediaType {
        case "public.image":
            if let originalImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
                imageView.image = originalImage
                object = AhadMedia(image: originalImage, videoURL: nil)

                dismiss(animated: true, completion: nil)
            }
        case "public.movie":
            if let mediaURL = info[UIImagePickerController.InfoKey.mediaURL] as? URL, let image = mediaURL.videoPreviewThumbnail() {
                imageView.image = image
                object = AhadMedia(image: image, videoURL: mediaURL)
                dismiss(animated: true, completion: nil)
            }
        default:
            break
        }
    }
}
