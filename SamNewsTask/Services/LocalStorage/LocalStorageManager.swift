//
//  LocalStorageManager.swift
//  SamNewsTask
//
//  Created by tzahi moyal on 04/02/2020.
//  Copyright © 2020 TZAHIMOYAL. All rights reserved.
//

import Foundation

struct LocalStorageManager {
  
  private static let userDefault = UserDefaults.standard
  
  static let sourcesListKey = "com.SamNewsTask.sourceslist"
  static let articelsListKey = "com.SamNewsTask.articelslist"
  static let lastSourceSelectedIndexKey = "com.SamNewsTask.lastsourceselected"
  
  /**
   - Description - Saving sources
   - Inputs -list of sources
   */
  static func save(_ sources: [SourcesResponse.SourceItem]) {
    do {
        let encoder = JSONEncoder()
        let encodedData: Data = try encoder.encode(sources)
        userDefault.set(encodedData,
        forKey: sourcesListKey)
    } catch {
        print("Couldn't save sources")
    }
      
  }
  
  /**
   - Description - Fetching sources list.
   - Output - `[SourcesResponse.SourceItem]` model
   */
  static func getSourcesList()-> [SourcesResponse.SourceItem] {
    do {
        if let decoded  = userDefault.data(forKey: sourcesListKey) {
          let decoder = JSONDecoder()
          return try decoder.decode([SourcesResponse.SourceItem].self, from: decoded)
      }
    } catch {
        print("Couldn't load sources")
    }
   
    return []
  }
  
    /**
     - Description - Saving articels for source
     - Inputs -list of articels
     */
  static func save(_ articels: [TopHeadlinesResponse.ArticleItem], forSource source:String) {
      do {
          let encoder = JSONEncoder()
          let encodedData: Data = try encoder.encode(articels)
          userDefault.set(encodedData,
                          forKey: "\(articelsListKey).\(source)")
      } catch {
          print("Couldn't save articels")
      }
        
    }
  
  /**
   - Description - Fetching articels list for source.
   - Output - `[TopHeadlinesResponse.ArticleItem]` model
   */
  static func getArticelsListForSource(_ source: String) -> [TopHeadlinesResponse.ArticleItem] {
    do {
        if let decoded  = userDefault.data(forKey: "\(articelsListKey).\(source)") {
          let decoder = JSONDecoder()
          return try decoder.decode([TopHeadlinesResponse.ArticleItem].self, from: decoded)
      }
    } catch {
        print("Couldn't load articels")
    }
   
    return []
  }
  
  /**
  - Description - save last source selected.
  - Inputs - Int
  */
  static func saveLastSourceSelected(_ lastSourceSelectedIndex: Int) {
    userDefault.set(lastSourceSelectedIndex, forKey: lastSourceSelectedIndexKey)
  }
  
  /**
  - Description - return last source selected.
  - Output - Int
  */
  static func getLastSourceSelected() -> Int {
    return userDefault.integer(forKey: lastSourceSelectedIndexKey)
  }
  
  /**
      - Description - Clearing user defaults
   */
  static func clearUserData(){
      userDefault.removeObject(forKey: sourcesListKey)
  }
  
}
