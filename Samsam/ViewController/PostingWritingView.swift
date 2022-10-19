//
//  PostingWritingView.swift
//  Samsam
//
//  Created by creohwan on 2022/10/19.
//

import UIKit

class PostingWritingView: UIViewController {

    // MARK: - View
    
    private var textTitle: UILabel = {
        $0.text = "시공 사진에 관하여 부가 설명을 써주세요"
        $0.textAlignment = .center
        $0.font = UIFont.systemFont(ofSize: 20, weight: .semibold)
        $0.textColor = .black
        return $0
    }(UILabel())

    lazy var textContent: UITextView = {
        let linestyle = NSMutableParagraphStyle()
        
        linestyle.lineSpacing = 6.0
        
        $0.backgroundColor = .white
        $0.text = "시공 사진에 관하여 설명을 써봐주세요 시공 사진에 관하여 설명을 써봐주세요 시공 사진에 관하여 설명을 써봐주세요"
        
        $0.textColor = .black
        $0.font = UIFont.systemFont(ofSize: 18, weight: .regular)
        $0.textAlignment = .natural
        $0.typingAttributes = [.paragraphStyle: linestyle]
        $0.textContainerInset = UIEdgeInsets(top: 17, left: 12, bottom: 17, right: 12)
        $0.layer.masksToBounds = false
        $0.layer.cornerRadius = 10
        
        $0.autocorrectionType = .no
        $0.autocapitalizationType = .none
        
        $0.layer.shadowColor = UIColor.black.cgColor
        $0.layer.shadowOpacity = 0.2
        $0.layer.shadowOffset = CGSize(width: 1, height: 1)
        $0.layer.shadowRadius = 10
  
        return $0
    }(UITextView())
    
    override func viewDidLoad() {
        super.viewDidLoad()
        attribute()
        layout()
        hidekeyboardWhenTappedAround()
    }
    
    // MARK: - Method
    
    private func attribute() {
        view.backgroundColor = .white
        
    }
    
    private func layout() {
        self.view.addSubview(textTitle)
        self.view.addSubview(textContent)
        
        textTitle.anchor(
            top: view.safeAreaLayoutGuide.topAnchor,
            left: view.safeAreaLayoutGuide.leftAnchor,
            right: view.safeAreaLayoutGuide.rightAnchor,
            height: 20
        )
    
        textContent.anchor(
            top: textTitle.bottomAnchor,
            left: textTitle.leftAnchor,
            right: textTitle.rightAnchor,
            paddingTop: 20,
            paddingLeft: 16,
            paddingBottom: 15,
            paddingRight: 16,
            height: 310
        )
    }
    
    func hidekeyboardWhenTappedAround() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(endEditingView))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @objc func endEditingView() {
        view.endEditing(true)
    }
}