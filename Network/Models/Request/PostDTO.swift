//
//  PostDTO.swift
//  Samsam
//
//  Created by 지준용 on 2022/11/27.
//

import Foundation

struct PostDTO: Encodable {
    
    let roomID: Int
    let category: Int
    let type: Int
    let description: String

    init(roomID: Int, category: Int, type: Int, description: String) {
        self.roomID = roomID
        self.category = category
        self.type = type
        self.description = description
    }
}
