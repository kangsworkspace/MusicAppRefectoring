//
//  Music.swift
//  MusicAppRefectoring
//
//  Created by Kang on 2023/10/07.
//

import UIKit

// API에서 받을 정보
struct MusicData: Codable {
    let resultCount: Int
    let results: [Music]
}

// Music 구조체
final class Music: Codable {
    let songName: String?
    let artistName: String?
    let albumName: String?
    let previewUrl: String?
    let imageUrl: String?
    private let releaseDate: String?
    var isSaved: Bool = false
    
    // 네트워크에서 주는 이름을 변환 (서버: trackName ===> songName)
    enum CodingKeys: String, CodingKey {
        case songName = "trackName"
        case artistName
        case albumName = "collectionName"
        case previewUrl
        case imageUrl = "artworkUrl100"
        case releaseDate
    }
    
    // 계산 속성으로 바꾸기
    var releaseDateString: String? {
        
        guard let isoDate = ISO8601DateFormatter().date(from: releaseDate ?? "") else {
            return ""
        }
        let myFormatter = DateFormatter()
        myFormatter.dateFormat = "yyyy-MM-dd"
        let dateString = myFormatter.string(from: isoDate)
        return dateString
    }
}
