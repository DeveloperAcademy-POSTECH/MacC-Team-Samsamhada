//
//  RoomEndPoint.swift
//  Samsam
//
//  Created by 김민택 on 2022/11/21.
//

import Foundation

enum RoomEndPoint: EndPointable {
    case startAppleLogin(body: LoginDTO)
    case createRoom(body: RoomDTO)
    case loadRoomByWorkerID(workerID: Int)
    case createStatus(body: StatusDTO)
    case loadPostByRoom(roomID: Int)
    case loadPhotoByRoom(postID: Int)

    var requestTimeOut: Float {
        return 10
    }

    var httpMethod: HTTPMethod {
        switch self {
        case .startAppleLogin, .createRoom, .createStatus:
            return .post
        case .loadRoomByWorkerID, .loadPostByRoom, .loadPhotoByRoom:
            return .get
        }
    }

    var requestBody: Data? {
        switch self {
        case .startAppleLogin(let body):
            return body.encode()
        case .createRoom(let body):
            return body.encode()
        case .createStatus(let body):
            return body.encode()
        default:
            return nil
        }
    }

    func getURL(baseURL: String) -> String {
        switch self {
        case .startAppleLogin:
            return "\(APIEnvironment.workersURL)"
        case .createRoom:
            return "\(APIEnvironment.roomsURL)"
        case .loadRoomByWorkerID(let workerID):
            return "\(APIEnvironment.roomsURL)/worker/\(workerID)"
        case .createStatus:
            return "\(APIEnvironment.statusesURL)"
        case .loadPostByRoom(let roomID):
            return "\(APIEnvironment.postsURL)/room/\(roomID)"
        case .loadPhotoByRoom(postID: let postID):
            return "\(APIEnvironment.photosURL)/post/\(postID)"
        }
    }

    func createRequest() -> NetworkRequest {
        var headers: [String: String] = [:]
        headers["Content-Type"] = "application/json"
        return NetworkRequest(url: getURL(baseURL: APIEnvironment.baseURL),
                              headers: headers,
                              reqBody: requestBody,
                              reqTimeout: requestTimeOut,
                              httpMethod: httpMethod
        )
    }
}
