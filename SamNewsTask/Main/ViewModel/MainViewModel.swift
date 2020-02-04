//
//  MainViewModel.swift
//  SamNewsTask
//
//  Created by tzahi moyal on 31/01/2020.
//  Copyright © 2020 TZAHIMOYAL. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

class MainViewModel {
  
  public let sourcesList : PublishSubject<[SourcesResponse.SourceItem]> = PublishSubject()
  public let articelsList : PublishSubject<[TopHeadlinesResponse.ArticleItem]> = PublishSubject()
  public let isConnectionError = BehaviorRelay<Bool>(value: false)
  
  var lastSourceSelectedIndex:Int
  
  init() {
    lastSourceSelectedIndex = LocalStorageManager.getLastSourceSelected()
  }
  
  func getAllSources() {
    var sourceList = LocalStorageManager.getSourcesList()
    if sourceList.count > 0 {
      sourceList[lastSourceSelectedIndex].isSelected = true
      let source = sourceList[lastSourceSelectedIndex]
      self.getArticlesForSource(source: source.id)
      self.sourcesList.onNext(sourceList)
    }
    APIManager.requestAllSources(completion: { (result) in
        switch result {
        case .success(let returnJson) :
          if let allSourcesResponse = returnJson as? SourcesResponse {
            var sourcesList = allSourcesResponse.sources
            if let source = sourcesList.first {
              sourcesList[self.lastSourceSelectedIndex].isSelected = true
              self.getArticlesForSource(source: source.id)
            }
            LocalStorageManager.save(sourcesList)
            self.sourcesList.onNext(sourcesList)
          }
          case .failure(let failure) :
            //TODO: handle error
            print(failure)
            self.isConnectionError.accept(true)
      }
    })
    }
  
  func getArticlesForSource(source: String) {
    let articelsList = LocalStorageManager.getArticelsListForSource(source)
    if articelsList.count > 0 {self.articelsList.onNext(articelsList)}
    APIManager.requestArticelsForSource(source: source, completion: { (result) in
        switch result {
        case .success(let returnJson) :
          if let topHeadlinesResponse = returnJson as? TopHeadlinesResponse {
            LocalStorageManager.save(topHeadlinesResponse.articles, forSource: source)
            self.articelsList.onNext(topHeadlinesResponse.articles)
          }
        case .failure(let failure) :
            //TODO: handle error
            print(failure)
            self.isConnectionError.accept(true)
            
        }
        
    })
  }
  
  func saveLastSourceSelected(_ lastSourceSelectedIndex: Int) {
    LocalStorageManager.saveLastSourceSelected(lastSourceSelectedIndex)
  }
  
  func getLastSourceSelected() -> Int {
    return LocalStorageManager.getLastSourceSelected()
  }
}
