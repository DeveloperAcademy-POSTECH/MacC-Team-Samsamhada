//
//  CoreDataManager.swift
//  Samsam
//
//  Created by 김민택 on 2022/10/23.
//

import CoreData
import Foundation
import UIKit

enum Category: Int {
    case zero = 0
    case one = 1
    case two = 2
    case three = 3
    case four = 4
    case five = 5
    case six = 6
    case seven = 7
    case eight = 8
    case nine = 9
    case ten = 10
    case eleven = 11
    case twelve = 12
    case thirteen = 13
    case fourteen = 14
    case fifteen = 15
    
    func categoryName() -> String {
        switch self {
        case .zero:
            return "실측"
        case .one:
            return "철거"
        case .two:
            return "설비"
        case .three:
            return "새시"
        case .four:
            return "목공"
        case .five:
            return "전기"
        case .six:
            return "페인트"
        case .seven:
            return "필름"
        case .eight:
            return "타일"
        case .nine:
            return "욕실"
        case .ten:
            return "마루"
        case .eleven:
            return "도배"
        case .twelve:
            return "주방"
        case .thirteen:
            return "폴딩도어"
        case .fourteen:
            return "조명"
        case .fifteen:
            return "기타"
        }
    }
}

class CoreDataManager {
    
    // MARK: - Property
    
    @Published var rooms = [RoomEntity]()
    @Published var workingStatuses = [WorkingStatusEntity]()
    @Published var postings = [PostingEntity]()
    @Published var photos = [PhotoEntity]()
    
    @Published var oneRoom: RoomEntity?
    
    // MARK: - Save Method
    
    
    // MARK: - Update Method
    
    
    // MARK: - Load Method
    
    
    // MARK: - Count Method
    
}
