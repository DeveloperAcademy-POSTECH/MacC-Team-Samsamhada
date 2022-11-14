//
//  PostingCategoryViewController.swift
//  Samsam
//
//  Created by creohwan on 2022/10/17.
//

import UIKit

class PostingCategoryViewController: UIViewController {
    
    // MARK: - Property
    
    var roomID: Int?
    private var categoryID: Int = 0
    var roomCategoryID: [Int] = []
    
    // MARK: - View
    
    let categoryView: UICollectionView = {
        return $0
    }(UICollectionView(
        frame: .zero, collectionViewLayout: UICollectionViewFlowLayout()))
    
    private let nextBtn: UIButton = {
        $0.backgroundColor = AppColor.campanulaBlue
        $0.setTitle("다음", for: .normal)
        $0.titleLabel?.font = UIFont.systemFont(ofSize: 18, weight: .semibold)
        $0.setTitleColor(.white, for: .normal)
        $0.layer.cornerRadius = 16
        $0.addTarget(self, action: #selector(tapNextBtn), for: .touchUpInside)
        return $0
    }(UIButton())
    
    // MARK: - LifeCycle

    override func viewDidLoad() {
        super.viewDidLoad()
        attribute()
        layout()
    }
    
    // MARK: - Method
    
    private func layout() {
        view.addSubview(categoryView)
        view.addSubview(nextBtn)
        
        categoryView.anchor(
            top: view.safeAreaLayoutGuide.topAnchor,
            left: view.safeAreaLayoutGuide.leftAnchor,
            bottom: nextBtn.topAnchor,
            right: view.safeAreaLayoutGuide.rightAnchor
        )
        
        nextBtn.anchor(
            left: view.safeAreaLayoutGuide.leftAnchor,
            bottom: view.safeAreaLayoutGuide.bottomAnchor,
            right: view.safeAreaLayoutGuide.rightAnchor,
            paddingLeft: 16,
            paddingRight: 16,
            height: 50
        )
    }

    private func attribute() {
        self.view.backgroundColor = .white
        
        setNavigationTitle()

        categoryView.delegate = self
        categoryView.dataSource = self
        categoryView.allowsMultipleSelection = false
        categoryView.register(CategoryCell.self, forCellWithReuseIdentifier: CategoryCell.identifier)
    }
    
    private func setNavigationTitle() {
        navigationItem.leftBarButtonItem = UIBarButtonItem(
            image: UIImage(systemName: "xmark"),
            style: .plain,
            target: self,
            action: #selector(closeBTN)
        )
        navigationItem.title = "시공 상황 작성"
        navigationItem.leftBarButtonItem?.tintColor = .black
        navigationController?.navigationBar.prefersLargeTitles = false
        navigationController?.setNavigationBarHidden(false, animated: true)
        navigationItem.backBarButtonItem = UIBarButtonItem(
            title: "",
            style: .plain,
            target: self,
            action: nil)
        navigationItem.backBarButtonItem?.tintColor = .black
    }
    
    @objc func tapNextBtn(_sender: UIButton) {
        let postingImageViewController = PostingImageViewController()
        postingImageViewController.roomID = roomID
        postingImageViewController.categoryID = roomCategoryID[categoryID]
        navigationController?.pushViewController(postingImageViewController, animated: true)
    }
}

// MARK: - UICollectionViewDelegate, DataSourse, DelegateFlowLayout

extension PostingCategoryViewController:  UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return roomCategoryID.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CategoryCell.identifier, for: indexPath) as! CategoryCell
        
        if indexPath.item == categoryID {
            cell.categoryImage.image = UIImage(named: CategoryCell.ImageLiteral.Check)
        } else {
            cell.categoryImage.image = UIImage(named: CategoryCell.ImageLiteral.noCheck)
        }
        
        let category: Category = Category(rawValue: roomCategoryID[indexPath.row])!
        cell.categoryTitle.text = "\(category.categoryName())"
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        categoryID = indexPath.item
        collectionView.reloadData()
        return true
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let cellWidth =  (view.frame.width - 48)/3
        let cellHeight = 120
        return CGSize(width: Int(cellWidth), height: Int(cellHeight))
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
         return UIEdgeInsets(top: 8, left: 8, bottom: 16, right: 8)
    }
        
    @objc private func closeBTN() {
        self.dismiss(animated: true)
    }
}
