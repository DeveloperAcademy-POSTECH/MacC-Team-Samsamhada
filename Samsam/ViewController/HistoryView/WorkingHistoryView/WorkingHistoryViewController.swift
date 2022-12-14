//
//  WorkingHistoryViewController.swift
//  Samsam
//
//  Created by 지준용 on 2022/10/17.
//

import UIKit

class WorkingHistoryViewController: UIViewController {

    // MARK: - Property
    
    let roomAPI: RoomAPI = RoomAPI(apiService: APIService())
    var statuses: [Status]?
    var posts = [Post]() {
        didSet {
            pleaseWriteLabel.isHidden = !posts.isEmpty

            posts.forEach {
                postDate.insert(String($0.createDate.dropLast(14)))
            }
            dateArray = postDate.sorted(by: {$0 > $1})
            workingHistoryView.reloadData()
        }
    }

    var isChangedSegment: Bool = true
    var room: Room?
    private var everyDayPosts: [Post] = []
    private var dateArray: [String] = []
    private var postDate = Set<String>()

    // MARK: - View

    private let workingHistoryView: UICollectionView = {
        $0.backgroundColor = .clear
        return $0
    }(UICollectionView(
        frame: .zero, collectionViewLayout: UICollectionViewFlowLayout()))
    
    var pleaseWriteLabel: UILabel = {
        $0.text = """
                  작성된 작업내용이 없어요
                  시공 내용을 작성해주세요!
                  """
        $0.numberOfLines = 2
        $0.textColor = .gray
        $0.textAlignment = .center
        return $0
    }(UILabel())
    
    let writingButton: UIButton = {
        $0.backgroundColor = AppColor.giwazipBlue
        $0.setTitle("시공상황 작성하기", for: .normal)
        $0.contentEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 20, right: 0)
        $0.titleLabel?.font = UIFont.systemFont(ofSize: 18, weight: .bold)
        $0.setTitleColor(.white, for: .normal)
        $0.addTarget(self, action: #selector(tapWritingButton), for: .touchDown)
        return $0
    }(UIButton())
    
    // MARK: - LifeCycle

    override func viewDidLoad() {
        super.viewDidLoad()
        attribute()
        layout()
    }

    // MARK: - Method

    private func attribute() {
        view.backgroundColor = AppColor.backgroundGray
        workingHistoryView.delegate = self
        workingHistoryView.dataSource = self
        workingHistoryView.contentInset.bottom = 80

        workingHistoryView.register(WorkingHistoryViewTopHeader.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: WorkingHistoryViewTopHeader.identifier)
        workingHistoryView.register(WorkingHistoryViewContentHeader.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: WorkingHistoryViewContentHeader.identifier)
        workingHistoryView.register(WorkingHistoryViewTopCell.self, forCellWithReuseIdentifier: WorkingHistoryViewTopCell.identifier)
        workingHistoryView.register(WorkingHistoryViewContentCell.self, forCellWithReuseIdentifier: WorkingHistoryViewContentCell.identifier)
        
        writingButton.addTarget(self, action: #selector(tapWritingButton), for: .touchDown)
    }

    private func layout() {
        view.addSubview(workingHistoryView)
        workingHistoryView.addSubview(pleaseWriteLabel)
        view.addSubview(writingButton)

        workingHistoryView.anchor(
            top: view.topAnchor,
            left: view.leftAnchor,
            bottom: view.bottomAnchor,
            right: view.rightAnchor
        )

        pleaseWriteLabel.anchor(
            top: view.topAnchor,
            left: view.leftAnchor,
            bottom: view.bottomAnchor,
            right: view.rightAnchor
        )

        writingButton.anchor(
            left: view.leftAnchor,
            bottom: view.bottomAnchor,
            right: view.rightAnchor,
            height: 90
        )
    }
    
    @objc func tapWritingButton() {
        let postingCategoryViewController = PostingCategoryViewController()
        postingCategoryViewController.room = room
        
        let navigationController = UINavigationController(rootViewController: postingCategoryViewController)
        navigationController.modalPresentationStyle = .fullScreen
        present(navigationController, animated:  true)
    }
}

extension WorkingHistoryViewController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

    // MARK: - Header

    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return postDate.count + 1
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        if section == 0 {
            return CGSize(width: UIScreen.main.bounds.width, height: 100)
        }
        return CGSize(width: UIScreen.main.bounds.width, height: 60)
    }

    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {

        if indexPath.section == 0 {
            let topHeader = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: WorkingHistoryViewTopHeader.identifier, for: indexPath) as! WorkingHistoryViewTopHeader
            
            topHeader.progressDuration.text = "진행상황(\(String((room?.startDate.dropText(first: 2, last: 14).replacingOccurrences(of: "-", with: "."))!)) ~ \(String((room?.endDate.dropText(first: 2, last: 14).replacingOccurrences(of: "-", with: "."))!)))"

            return topHeader
        } else {
            let contentHeader = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: WorkingHistoryViewContentHeader.identifier, for: indexPath) as! WorkingHistoryViewContentHeader

            var createDates = dateArray[indexPath.section - 1]
            createDates.insert("년", at: createDates.index(createDates.startIndex, offsetBy: 4))
            createDates.insert("월", at: createDates.index(createDates.startIndex, offsetBy: 8))
            createDates.insert("일", at: createDates.index(createDates.startIndex, offsetBy: 12))
            createDates = createDates.dropFirst(2).replacingOccurrences(of: "-", with: " ")

            contentHeader.uploadDate.text = createDates
            
            return contentHeader
        }
    }

    // MARK: - Cell

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if section == 0 {
            return 1
        }

        var everyDayPosts: [Post] = []

        posts.forEach {
            if dateArray[section - 1] == $0.createDate.dropLast(14) {
                everyDayPosts.append($0)
            }
        }
        return everyDayPosts.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if indexPath.section == 0 {
            let topCell = collectionView.dequeueReusableCell(withReuseIdentifier: WorkingHistoryViewTopCell.identifier, for: indexPath) as! WorkingHistoryViewTopCell

            if isChangedSegment {
                topCell.viewAll.addTarget(self, action: #selector(tapAllView), for: .touchUpInside)
            } else {
                topCell.isHidden = true
            }

            return topCell
        } else {
            
            let contentCell = collectionView.dequeueReusableCell(withReuseIdentifier: WorkingHistoryViewContentCell.identifier, for: indexPath) as! WorkingHistoryViewContentCell

            var everyDayPosts: [Post] = []

            posts.forEach {
                if dateArray[indexPath.section - 1] == $0.createDate.dropLast(14) {
                    everyDayPosts.append($0)
                }
            }
            contentCell.imageDescription.text = everyDayPosts[indexPath.item].description

            if isChangedSegment {
                contentCell.workType.text = Category.categoryName(Category(rawValue: everyDayPosts[indexPath.item].category)!)()
            } else {
                contentCell.workType.text = ""
                contentCell.workTypeView.isHidden = true
            }
            
            DispatchQueue.global().async {
                let data = try? Data(contentsOf: URL(string: everyDayPosts[indexPath.item].photos![0].photoPath)!)
                DispatchQueue.main.async {
                    contentCell.uiImageView.image = UIImage(data: data!)
                }
            }
            return contentCell
        }
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {

        if indexPath.section == 0 {
            let width = UIScreen.main.bounds.width
            var cellHeight = 30
            
            if !isChangedSegment {
                
                // FIXME: - cellHeight값이 0이면, 게시물이 보이지 않는 문제 식별
                
                cellHeight = 1
            }
            
            return CGSize(width: Int(width), height: cellHeight)
        } else {
            let width = UIScreen.main.bounds.width - 32
            let cellHeight = width / 4 * 3

            return CGSize(width: Int(width), height: Int(cellHeight))
        }
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if indexPath.section > 0 {
            let detailViewController = DetailViewController()
            
            var everyDayPosts: [Post] = []
            posts.forEach {
                if dateArray[indexPath.section - 1] == $0.createDate.dropLast(14) {
                    everyDayPosts.append($0)
                }
            }
            
            detailViewController.descriptionLBL.text = everyDayPosts[indexPath.item].description
            detailViewController.postID = everyDayPosts[indexPath.item].postID
            everyDayPosts[indexPath.item].photos!.forEach {
                detailViewController.images.append($0)
            }
            navigationController?.pushViewController(detailViewController, animated: true)
        }
    }

    @objc func tapAllView() {
        let chipViewController = ChipViewController()
        chipViewController.room = room
        chipViewController.posts = posts
        chipViewController.statuses = statuses
        navigationController?.pushViewController(chipViewController , animated: true)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 20
    }
}
