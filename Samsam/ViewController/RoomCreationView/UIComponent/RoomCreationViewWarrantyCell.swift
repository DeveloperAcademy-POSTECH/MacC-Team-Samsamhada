//
//  RoomCreationViewWarrantyCell.swift
//  Samsam
//
//  Created by 지준용 on 2022/11/08.
//

import UIKit

class RoomCreationViewWarrantyCell: UITableViewCell {
    
    // MARK: - Property
    
    static let identifier = "roomCreationViewWarrantyCell"
    var warrantyCount = 12
    
    // MARK: - View
    
    let warrantyView: UIView = {
        return $0
    }(UIView())
    
    private let warrantyLabel: UILabel = {
        $0.text = "AS기간"
        $0.textAlignment = .left
        $0.font = UIFont.systemFont(ofSize: 18, weight: .semibold)
        $0.textColor = .black
        return $0
    }(UILabel())

    var warrantyText: UILabel = {
        $0.text = "12개월"
        $0.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
        return $0
    }(UILabel())
    
    let warrantyStepper: UIStepper = {
        $0.value = 12
        $0.maximumValue = 24
        $0.minimumValue = 0
        $0.wraps = true
        $0.autorepeat = true
        $0.addTarget(self, action: #selector(tapStepper), for: .touchUpInside)
        return $0
    }(UIStepper())
    
    // MARK: - Init
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        layout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:)가 실행되지 않았습니다.")
    }
    
    // MARK: - Method
    
    private func layout() {
        self.addSubview(warrantyView)
        warrantyView.addSubview(warrantyLabel)
        warrantyView.addSubview(warrantyText)
        warrantyView.addSubview(warrantyStepper)
        
        warrantyView.anchor(
            top: topAnchor,
            left: leftAnchor,
            bottom: bottomAnchor,
            right: rightAnchor
        )
        
        warrantyLabel.anchor(
            top: warrantyView.topAnchor,
            left: warrantyView.leftAnchor,
            bottom: warrantyView.bottomAnchor
        )
        
        warrantyText.anchor(
            top: warrantyView.topAnchor,
            bottom: warrantyView.bottomAnchor,
            right: warrantyStepper.leftAnchor,
            paddingRight: 10
        )
        
        warrantyStepper.anchor(
            right: warrantyView.rightAnchor
        )
        warrantyStepper.centerY(inView: warrantyView)
    }
    
    @objc private func tapStepper() {
        warrantyCount = Int(warrantyStepper.value)
        warrantyText.text = "\(warrantyCount)개월"
    }
}
