//
//  Reel.swift
//  iOSAssignment
//
//  Created by Thukaram on 03/08/24.
//

import Foundation

struct Reel : Codable {
    let id : String?
    let video : String?
    let thumbnail : String?
    
    enum CodingKeys: String, CodingKey {
        
        case id = "_id"
        case video = "video"
        case thumbnail = "thumbnail"
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        id = try values.decodeIfPresent(String.self, forKey: .id)
        video = try values.decodeIfPresent(String.self, forKey: .video)
        thumbnail = try values.decodeIfPresent(String.self, forKey: .thumbnail)
    }
    
}
