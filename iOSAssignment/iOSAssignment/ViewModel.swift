//
//  ViewModel.swift
//  iOSAssignment
//
//  Created by Thukaram on 03/08/24.
//

import Foundation

class ViewModel {
    
    private(set) var reels: [Reels]?
    
    func getReelsData(_ compltionHandler:() -> Void)  {
        
        guard let fileurl = Bundle.main.url(forResource: "reels", withExtension: "json") else {
            print("Failed to locate the reels.json in bundle.")
            return
        }
        
        do {
            let data = try Data(contentsOf: fileurl)
            
            let decoder = JSONDecoder()
            let reels = try decoder.decode(ReelsBase.self, from: data)
            self.reels = reels.reels
            compltionHandler()
        } catch {
            print("Failed to extract data from reels.json")
        }
        
    }
}
