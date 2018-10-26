//
//  SpotifyClient.swift
//  Newsic
//
//  Created by Bryan's Air on 10/26/18.
//  Copyright © 2018 Bryborg Inc. All rights reserved.
//

import Foundation
import UIKit
import CoreData

class SpotifyClient {
    
    
    
    
    // MARK: Helper for Creating a URL from Parameters
    
    func spotifyURLFromParameters(_ parameters: [String:AnyObject]) -> URL {
        
        var components = URLComponents()
        components.scheme = Constants.Spotify.ApiScheme
        components.host = Constants.Spotify.ApiHost
        components.path = Constants.Spotify.ApiPath
        components.queryItems = [URLQueryItem]()
        
        for (key, value) in parameters {
            let queryItem = URLQueryItem(name: key, value: "\(value)")
            components.queryItems!.append(queryItem)
        }
        
        return components.url!
    }
    
}
