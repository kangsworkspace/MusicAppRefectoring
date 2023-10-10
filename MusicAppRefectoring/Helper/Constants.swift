//
//  Constants.swift
//  MusicAppRefectoring
//
//  Created by Kang on 2023/10/07.
//

import UIKit

// 네트워크에 사용할 문자열
public enum MusicApi {
    static let requestUrl = "https://itunes.apple.com/search?"
    static let mediaParam = "media=music"
}

public enum Image {
    static let redHeart = UIImage(systemName: "heart")?.withTintColor(.red, renderingMode: .alwaysOriginal)
    static let redHeartFilled = UIImage(systemName: "heart.fill")?.withTintColor(.red, renderingMode: .alwaysOriginal)
    static let bookMark = UIImage(systemName: "bookmark")?.withTintColor(.lightGray, renderingMode: .alwaysOriginal)
    static let selectedBookMark = UIImage(systemName: "bookmark.fill")?.withTintColor(.black, renderingMode: .alwaysOriginal)
    static let magnifyingGlass = UIImage(systemName: "magnifyingglass")?.withTintColor(.lightGray, renderingMode: .alwaysOriginal)
    static let selectedMagnifyingGlass = UIImage(systemName: "magnifyingglass")?.withTintColor(.black, renderingMode: .alwaysOriginal)
}
