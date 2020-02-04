//
//  SourcesResponse.swift
//  SamNewsTask
//
//  Created by tzahi moyal on 02/02/2020.
//  Copyright © 2020 TZAHIMOYAL. All rights reserved.
//

import Foundation

struct SourcesResponse: Codable {
    let sources:[SourceItem]
    
    struct SourceItem: Codable {
        let id, name, description, url, category, language, country: String
      
      enum CodingKeys: CodingKey {
        case id
        case name
        case description
        case url
        case category
        case language
        case country
      }
      
        var isSelected = false
    }
  
  
}
