//
//  CategoryCell.swift
//  Samsam
//
//  Created by creohwan on 2022/10/17.
//

import UIKit

class CategoryCell: UICollectionViewCell {
    
    // MARK: - Property
    
    static let identifier = "categoryCell"
    
    override var isSelected: Bool{
            didSet {
                    if isSelected {
                        self.categoryImage.image = UIImage(named:"category2")
                        
                    } else {
                        self.categoryImage.image = UIImage(named:"category1")
                    }
                }
        }
    
    // MARK: - View
    
    var categoryImage: UIImageView = {
        $0.image = UIImage(named: "")
        $0.contentMode = .scaleAspectFit
        return $0
    }(UIImageView())
    
    let categoryTitle: UILabel = {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.text = ""
        $0.textAlignment = .center
        $0.font = UIFont.systemFont(ofSize: 16, weight: .bold)
        $0.numberOfLines = 0
        return $0
    }(UILabel())
    
    let vStackView: UIStackView = {
        $0.axis = .vertical
        $0.backgroundColor = .white
        return $0
    }(UIStackView())
    
    // MARK: - Init
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        layout()
        setupCell()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Method
    
    private func layout() {
        addSubview(vStackView)
        vStackView.addArrangedSubview(categoryImage)
        vStackView.addArrangedSubview(categoryTitle)
    }
    
    private func setupCell() {
        vStackView.anchor(
            top: topAnchor,
            left: leftAnchor,
            bottom: bottomAnchor,
            right: rightAnchor
        )
        
        categoryImage.anchor(
            top: vStackView.topAnchor,
            left: vStackView.leftAnchor,
            bottom: categoryTitle.topAnchor,
            right: vStackView.leftAnchor
        )
        
        categoryTitle.anchor(
            left: vStackView.leftAnchor,
            bottom: vStackView.bottomAnchor,
            right: vStackView.rightAnchor
        )
    }
}
