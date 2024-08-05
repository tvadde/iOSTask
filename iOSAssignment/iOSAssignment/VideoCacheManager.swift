//
//  VideoCacheManager.swift
//  iOSAssignment
//
//  Created by Thukaram on 03/08/24.
//

import Foundation
import UIKit
import AVFoundation

class VideoCacheManager {
    
    static let shared = VideoCacheManager()
    private var cache: NSCache<NSString, NSURL> = NSCache<NSString, NSURL>()
    private let session = URLSession.shared
    
    func getVideoData(from urlString: String, completion: @escaping (URL?, Error?) -> Void) {
        let url = URL(string: urlString)!
        
        let cacheKey = url.lastPathComponent as NSString
        
        // Check cache first
        if let cachedData = cache.object(forKey: cacheKey) {
            completion(cachedData as URL, nil)
            return
        }
        
        // Download video if not cached
        let task = session.dataTask(with: url) { data, response, error in
            if let error = error {
                completion(nil, error)
                return
            }
            
            guard let data = data,
                    let httpResponse = response as? HTTPURLResponse,
                  httpResponse.statusCode == 200 else {
                completion(nil,
                           URLError(.cannotLoadFromNetwork))
                return
            }
            DispatchQueue.global().async {
                //            self.cache.setObject(data as NSData, forKey: cacheKey)
                let temporaryFileURL = URL(fileURLWithPath: NSTemporaryDirectory()).appendingPathComponent((cacheKey as String))
                do {
                    print("file written to :\(temporaryFileURL)")
                    try data.write(to: temporaryFileURL)
                    
                    
                } catch {
                    print("store eror" + error.localizedDescription)
                }
                self.cache.setObject(temporaryFileURL as NSURL, forKey: cacheKey)
                completion(temporaryFileURL, nil)
            }
        }
        task.resume()
    }
}
