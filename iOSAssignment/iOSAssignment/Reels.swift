//
//  Reels.swift
//  iOSAssignment
//
//  Created by Thukaram on 03/08/24.
//

import Foundation

struct Reels: Codable {
    
    let reels: [Reel]?
    
    enum CodingKeys: String, CodingKey {
        case reels = "arr"
    }
    
    init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.reels = try container.decodeIfPresent([Reel].self, forKey: .reels)
    }
}
