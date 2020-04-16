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
        return pc
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .systemRed
    }
    
    
}
