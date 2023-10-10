//
//  MusicSaved+CoreDataProperties.swift
//  MusicAppRefectoring
//
//  Created by Kang on 2023/10/09.
//
//

import Foundation
import CoreData


extension MusicSaved {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<MusicSaved> {
        return NSFetchRequest<MusicSaved>(entityName: "MusicSaved")
    }

    @NSManaged public var albumName: String?
    @NSManaged public var artistName: String?
    @NSManaged public var imageUrl: String?
    @NSManaged public var myMessage: String?
    @NSManaged public var previewUrl: String?
    @NSManaged public var releaseDate: String?
    @NSManaged public var savedDate: Date?
    @NSManaged public var songName: String?

    var savedDateString: String? {
        let myFormatter = DateFormatter()
        myFormatter.dateFormat = "yyyy-MM-dd"
        guard let date = savedDate else { return "" }
        let savedDateString = myFormatter.string(from: date)
        return savedDateString
    }
}

extension MusicSaved : Identifiable {

}
