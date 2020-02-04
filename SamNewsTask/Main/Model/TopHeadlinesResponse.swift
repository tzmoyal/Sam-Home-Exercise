//
//  TopHeadlinesResponse.swift
//  SamNewsTask
//
//  Created by tzahi moyal on 02/02/2020.
//  Copyright © 2020 TZAHIMOYAL. All rights reserved.
//

import Foundation

struct TopHeadlinesResponse: Codable {
  let totalResults: Int
  let articles:[ArticleItem]
    
  struct ArticleItem: Codable {
    let source: Source
    let author, title, description, url, urlToImage, publishedAt, content: String?
        
    }
  
  struct Source: Codable {
    let id, name: String
  }
  
}
