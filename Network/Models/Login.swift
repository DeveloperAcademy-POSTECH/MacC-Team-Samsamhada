//
//  Login.swift
//  Samsam
//
//  Created by creohwan on 2022/11/10.
//

import Foundation

struct Login: Decodable {
    let workerID: Int?
    let userIdentifier: String?
    let name: String?
    let email: String?
    let number: String?
}
