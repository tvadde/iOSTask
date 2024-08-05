//
//  ReelsBase.swift
//  iOSAssignment
//
//  Created by Thukaram on 03/08/24.
//

import Foundation

struct ReelsBase: Codable {
    
    let reels: [Reels]?
    
    enum CodingKeys: String, CodingKey {
        case reels = "reels"
    }
    
    init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.reels = try container.decodeIfPresent([Reels].self, forKey: .reels)
    }
}
