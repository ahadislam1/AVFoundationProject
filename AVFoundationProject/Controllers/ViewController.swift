//
//  ViewController.swift
//  AVFoundationProject
//
//  Created by Ahad Islam on 4/15/20.
//  Copyright © 2020 Ahad Islam. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.backgroundColor = .systemGroupedBackground
        cv.register(ActivityCell.self, forCellWithReuseIdentifier: "activityCell")
        cv.delegate = self
        cv.dataSource = self
        return cv
    }()
    
    private var activities = [(String, String)]() {
        didSet {
            DispatchQueue.main.async {
                self.collectionView.reloadData()
            }
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        loadActivities()
        setupCollectionView()
        
        view.backgroundColor = .systemBackground
        
    }
    
    private func loadActivities() {
        FirestoreService.session.getDocuments { [weak self] result in
            switch result {
            case .failure(let error):
                self?.showAlert(title: "Error", message: error.localizedDescription)
            case .success(let activities):
                self?.activities = activities
            }
        }
    }
    
    private func setupCollectionView() {
           view.addSubview(collectionView)
           collectionView.translatesAutoresizingMaskIntoConstraints = false
           NSLayoutConstraint.activate([
               collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
               collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
               collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
               collectionView.safeAreaLayoutGuide.bottomAnchor.constraint(equalTo: view.bottomAnchor)])
       }
    

}

extension ViewController: UICollectionViewDelegateFlowLayout, UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        switch indexPath.row {
        case 0:
            let vc = UIStoryboard(name: "Pencil", bundle: nil).instantiateInitialViewController() ?? OscarViewController()
            navigationController?.pushViewController(vc, animated: true)
        case 1:
            navigationController?.pushViewController(AhadViewController(), animated: true)
        default:
            break
        }
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return activities.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "activityCell", for: indexPath) as? ActivityCell else {
            fatalError("Bad cell.")
        }
        cell.configureLabels(activities[indexPath.row])
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        CGSize(width: view.frame.width * 0.92, height: view.frame.height * 0.2)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        UIEdgeInsets(top: view.frame.height * 0.1, left: 0, bottom: view.frame.height * 0.1, right: 0)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        view.frame.height * 0.1
    }
}

