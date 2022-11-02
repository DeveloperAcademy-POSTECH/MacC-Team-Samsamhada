//
//  PostingImageViewController.swift
//  Samsam
//
//  Created by creohwan on 2022/10/18.
//

import UIKit
import PhotosUI

struct cellItem {
    var image: UIImage?
    var path: Data?
}

class PostingImageViewController: UIViewController {
    
    // MARK: - Property
    
    var roomID: Int?
    var categoryID: Int?
    var numberOfItem = 0
    var exampleNUM = 0
    
    private var photoImages: [cellItem] = [cellItem(image: UIImage(named: "CameraBTN"))]
    private var copyPhotoImages: [cellItem]? // 다음 뷰에 이미지들을 넘길 때 사용될 배열
    private var changeNUM: Int? // 이미지 변경 시, 사용될 index 번호
    private var plusBool: Bool = true // plus 버튼이 나타날 지, 없어질 지에 관하여 사용될 Bool
    
    // MARK: - View
    
    private var titleText: UILabel = {
        $0.text = "시공한 사진을 추가해주세요.\n(최대 4장까지 가능합니다)."
        $0.textAlignment = .center
        $0.font = UIFont.systemFont(ofSize: 18, weight: .semibold)
        $0.textColor = .lightGray
        $0.numberOfLines = 0
        return $0
    }(UILabel())
    
    private var exampleImage: UIImageView = {
        $0.image = UIImage(named: "Test04")
        $0.contentMode = .scaleAspectFit
        return $0
    }(UIImageView())
    
    private let imageCellView: UICollectionView = {
        return $0
    }(UICollectionView(
        frame: .zero, collectionViewLayout: UICollectionViewFlowLayout()))
    
    private let nextBTN: UIButton = {
        $0.backgroundColor = AppColor.campanulaBlue
        $0.setTitle("다음", for: .normal)
        $0.titleLabel?.font = UIFont.systemFont(ofSize: 18, weight: .semibold)
        $0.setTitleColor(.white, for: .normal)
        $0.layer.cornerRadius = 16
        $0.addTarget(self, action: #selector(tapNextBTN), for: .touchUpInside)
        return $0
    }(UIButton())
    
    // MARK: - LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        layout()
        attribute()
        PHPhotoLibrary.requestAuthorization { (state) in }
    }
    
    // MARK: - Method
    
    private func attribute() {
        self.view.backgroundColor = .white
        setNavigationTitle()
        
        imageCellView.delegate = self
        imageCellView.dataSource = self
        imageCellView.allowsMultipleSelection = true
        
        imageCellView.register(PostingImageCell.self, forCellWithReuseIdentifier: PostingImageCell.identifier)
        imageCellView.backgroundColor = .white
    }
    
    private func layout() {
        self.view.addSubview(titleText)
        self.view.addSubview(imageCellView)
        self.view.addSubview(nextBTN)
        
        titleText.anchor(
            top: view.safeAreaLayoutGuide.topAnchor,
            left: view.safeAreaLayoutGuide.leftAnchor,
            right: view.safeAreaLayoutGuide.rightAnchor,
            paddingTop: 12,
            paddingLeft: 50,
            paddingRight: 50,
            height: 50
        )
        
        imageCellView.anchor(
            top: titleText.bottomAnchor,
            left: view.safeAreaLayoutGuide.leftAnchor,
            bottom: nextBTN.topAnchor,
            right: view.safeAreaLayoutGuide.rightAnchor
        )
        
        nextBTN.anchor(
            left: view.safeAreaLayoutGuide.leftAnchor,
            bottom: view.safeAreaLayoutGuide.bottomAnchor,
            right: view.safeAreaLayoutGuide.rightAnchor,
            paddingLeft: 16,
            paddingRight: 16,
            height: 50
        )
    }
    
    private func setNavigationTitle() {
        navigationItem.title = "시공 상황 작성"
        navigationController?.navigationBar.tintColor = .black
        navigationController?.navigationBar.prefersLargeTitles = false
        navigationController?.setNavigationBarHidden(false, animated: true)
        navigationItem.backBarButtonItem = UIBarButtonItem(
            title: "",
            style: .plain,
            target: self,
            action: nil)
        navigationItem.backBarButtonItem?.tintColor = .black
    }
    
    @objc func tapNextBTN() {
        let postingWritingView = PostingWritingView()
        postingWritingView.roomID = roomID
        postingWritingView.categoryID = categoryID
        
        if numberOfItem == 0 {
            showToast()
        } else if numberOfItem > 3 {
            postingWritingView.photoImages = photoImages
            navigationController?.pushViewController(postingWritingView, animated: true)
        } else {
            copyPhotoImages = photoImages
            copyPhotoImages?.remove(at: 0)
            postingWritingView.photoImages = copyPhotoImages
            navigationController?.pushViewController(postingWritingView, animated: true)
        }
    }
    
    // 이미지를 하나도 선택하지 않고 다음 뷰를 넘어갈 때, 이를 방지하기 위한 함수
    private func showToast() {
        let label = UILabel()
        label.backgroundColor = .lightGray
        label.textColor = .black
        label.font = UIFont.systemFont(ofSize: 15, weight: .semibold)
        label.textAlignment = .center
        label.text = "사진을 하나 이상 선택해주세요!"
        label.layer.cornerRadius = 8
        label.clipsToBounds = true
        label.alpha = 0
        self.view.addSubview(label)
        
        label.anchor(
            bottom: nextBTN.topAnchor,
            paddingBottom: 30,
            width: 240,
            height: 30
        )
        label.centerX(inView: self.view)
        
        UIView.animate(withDuration: 0.5, animations: {
            label.alpha = 0.8
        }, completion: { isCompleted in
            UIView.animate(withDuration: 2.0, animations: {
                label.alpha = 0
            }, completion: { isCompleted in
                label.removeFromSuperview()
            })
        })
    }
    
    // 이미지 업로드 전 카메라 권한 체크 후, 체크가 되면, 이미지 업로드합니다.
    func checkPermissionandGo(indexPath: Int){
           switch PHPhotoLibrary.authorizationStatus() {
           case .denied:
               didMoveToSetting()
           case .notDetermined:
               PHPhotoLibrary.requestAuthorization({ (state) in
                   if state == .authorized {
                       DispatchQueue.main.async {
                           if self.plusBool == true && indexPath == 0 {
                               self.uploadPhoto(indexPath: indexPath)
                           } else {
                               self.makeActionSheet(indexPath: indexPath)
                           }
                       }
                   }
               })
           case .authorized:
               if plusBool == true && indexPath == 0 {
                   uploadPhoto(indexPath: indexPath)
               } else {
                   makeActionSheet(indexPath: indexPath)
               }
               // 위에 if문은 이미지 추가 버튼 클릭일 때, 밑에 else는 기존 이미지 클릭일 떄 입니다.
               //if문에 조건을 설명하자면, plusBool은 이미지 추가 버튼이 있을 때, 그리고 클릭한 이미지 index가 0일 때만 돌아갑니다.
               //이미지가 4장이 이미 업로드된 상황이라면, plusBool이 fasle이기에 else로 갑니다.
           default:
               break
           }
       }

    
    // 사진이 불러와지지 않을 때, 알람을 주기 위한 함수
    private func makeAlert(title: String,
                           message: String? = nil,
                           okAction: ((UIAlertAction) -> Void)? = nil,
                           completion : (() -> Void)? = nil) {
        let alertViewController = UIAlertController(title: title,
                                                    message: message,
                                                    preferredStyle: .alert)
        let okAction = UIAlertAction(title: "확인", style: .default, handler: okAction)
        alertViewController.addAction(okAction)
        
        self.present(alertViewController, animated: true, completion: completion)
    }

    // 기존 사진을 클릭했을 때, 사진 변경 or 사진 삭제 알림 창을 띄우는 액션 시트
    private func makeActionSheet(indexPath: Int) {
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        let okAction = UIAlertAction(title: "사진 변경하기", style: .default, handler: { action in
            self.changePhoto(indexPath: indexPath)
        })
        let removeAction = UIAlertAction(title: "사진 삭제하기", style: .destructive, handler: { action in
            self.deletePhoto(indexPath: indexPath)
        })
        let cancelAction = UIAlertAction(title: "취소", style: .cancel, handler: nil)
        
        alert.addAction(okAction)
        alert.addAction(removeAction)
        alert.addAction(cancelAction)
        
        present(alert, animated: true, completion: nil)
    }
    
    // 새로운 사진 업로드 함수
    @objc func uploadPhoto(indexPath: Int) {
        changeNUM = indexPath
        var configure = PHPickerConfiguration()
        configure.selectionLimit = 4 - numberOfItem
        configure.selection = .ordered
        configure.filter = .images
        let picker = PHPickerViewController(configuration: configure)
        picker.delegate = self
        self.present(picker, animated: true, completion: nil)
    }
    
    // 기존 이미지 변경 함수, 여기서 changeNUM은 어떤 이미지를 바꾸는 지 알아야 하기에 필요합니다!
    @objc func changePhoto(indexPath: Int) {
        changeNUM = indexPath
        var configure = PHPickerConfiguration()
        configure.selectionLimit = 1
        configure.selection = .ordered
        configure.filter = .images
        let picker = PHPickerViewController(configuration: configure)
        picker.delegate = self
        self.present(picker, animated: true, completion: nil)
    }

    // 기존 이미지 삭제 함수, changeNUM은 어떤 이미지를 삭제하는 지 알기 위해, plusBool은 4개에서 삭제하면 3개가 되고, 그럴 땐 다시 이미지 추가 버튼이 생겨야 하기에 if문을 돌립니다.
    @objc func deletePhoto(indexPath: Int) {
        photoImages.remove(at: indexPath)
        if numberOfItem == 4 {
            plusBool = true
            photoImages.insert(cellItem(image: UIImage(named: "CameraBTN")), at: 0)
        }
        numberOfItem = numberOfItem - 1
        imageCellView.reloadData()
    }
}

extension PostingImageViewController: PHPickerViewControllerDelegate {
    
    // TODO: - 효율적인 로직 고민 필요: 밑에 if 와 else를 보면 중복되는 부분이 조금 있습니다. 그 부분을 하나로 합칠 수 있을 것 같긴 한데...
    
    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        picker.dismiss(animated: true, completion: nil)

        // 밑에 plusIndex는 이미지를 업로드 했을 때, 최근에 누른 것이 위쪽에 보이도록 하기 위해서(이미지 추가 버튼 뒤쪽으로 배열에 넣어야 합니다), 그때 사용됩니다. 그러면 굳이 이렇게 변수로 뺀 이유는? 그건 바로 업로드 된 기존 이미지가 4개일 때, 하나를 삭제하면, 이미지 추가 버튼이 다시 나와야 합니다. 그때는 배열 0에 insert를 해야하기 위해서, 그때는 plusIndex가 0이 됩니다.
        var plusIndex = 1
        if plusBool == true && changeNUM == 0 { // 이것은 이미지 업로드 되었을 때 돌리는 if문 입니다.
            if results.count + photoImages.count == 5 { // 이것은 이미지 업로드 4장이 되었을 떄, 이미지 추가 버튼을 삭제하기 위함입니다.
                photoImages.remove(at: 0)
                plusIndex = 0
                plusBool = false
            }
            for result in results.reversed() { //reversed인 이유는 처음에 누른 것이, 맨 위에 올라오도록 하기 위함입니다
                let itemProvider = result.itemProvider
                if itemProvider.canLoadObject(ofClass: UIImage.self) {
                    itemProvider.loadObject(ofClass: UIImage.self) { [weak self](image, error) in
                        DispatchQueue.main.async {
                            guard let image = image as? UIImage else { return }
                            self?.photoImages.insert(cellItem(image: image), at: plusIndex)
                            self?.numberOfItem = self!.numberOfItem + 1
                            self?.imageCellView.reloadData()
                        }
                        if let error = error {
                            DispatchQueue.main.async {
                                self?.makeAlert(title: "",message: "사진을 불러올 수 없습니다")
                            }
                        }
                    }
                }
            }
        } else { // else 이것은 이미지를 변경할 때 사용됩니다.
            for result in results {
                let itemProvider = result.itemProvider
                if itemProvider.canLoadObject(ofClass: UIImage.self) {
                    itemProvider.loadObject(ofClass: UIImage.self) { [weak self](image, error) in
                        DispatchQueue.main.async {
                            guard let image = image as? UIImage else { return }
                            self?.photoImages[self!.changeNUM!].image = image as! UIImage
                            self?.imageCellView.reloadData()
                        }
                        if let error = error {
                            DispatchQueue.main.async {
                                self?.makeAlert(title: "",message: "사진을 불러올 수 없습니다")
                            }
                        }
                    }
                }
            }
        }
    }
}

// MARK: - UICollectionViewDelegate, DataSourse, DelegateFlowLayout

extension PostingImageViewController:  UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return photoImages.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PostingImageCell.identifier, for: indexPath) as! PostingImageCell
        
        cell.preview.image = photoImages[indexPath.row].image
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        // 위에 if문은 이미지 추가 버튼 클릭일 때, 밑에 else는 기존 이미지 클릭일 떄 입니다. if문에 조건을 설명하자면, plusBool은 이미지 추가 버튼이 있을 때, 그리고 클릭한 이미지 index가 0일 때만 돌아갑니다. 이미지가 4장이 이미 업로드된 상황이라면, plusBool이 fasle이기에 else로 갑니다.
        if plusBool == true && indexPath.row == 0 {
            uploadPhoto(indexPath: indexPath.row)
        } else {
            makeActionSheet(indexPath: indexPath.row)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let cellWidth =  310
        let cellHeight = 235
        return CGSize(width: cellWidth, height: cellHeight)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 8, left: 8, bottom: 16, right: 8)
    }
}

