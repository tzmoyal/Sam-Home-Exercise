//
//  APIManager.swift
//  SamNewsTask
//
//  Created by tzahi moyal on 31/01/2020.
//  Copyright © 2020 TZAHIMOYAL. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa
import Alamofire
import CoreLocation

class APIManager {
    
    enum BaseUrl: String {
      case allSources = "https://newsapi.org/v2/sources?apiKey=2aabe39dfdad43dab39321ec4b3e73e7"
      case source = "https://newsapi.org/v2/top-headlines?sources=[SOURCE]&pageSize=20&page=[PAGE]&apiKey=2aabe39dfdad43dab39321ec4b3e73e7"

    }
  
    typealias parameters = [String:Any]

    enum ApiResult {
        case success(Any)
        case failure(Error)
    }
    
    // MARK: - All named sources available
    
    static func requestAllSources(completion: @escaping (ApiResult)->Void) {
        Alamofire.request(BaseUrl.allSources.rawValue)
          .validate()
          .response { response in
                print(response)
                guard let data = response.data else { return }
                do {
                    let decoder = JSONDecoder()
                    let sourcesResponse = try decoder.decode(SourcesResponse.self, from: data)
                    completion(ApiResult.success(sourcesResponse))
                    print(sourcesResponse)
                } catch let error {
                    completion(ApiResult.failure(error))
                    print(error)
                }
        }

    }
  
  //MARK: - Top headlines from source
  
  static func requestArticelsForSource(source: String, completion: @escaping (ApiResult)->Void) {
    let url = BaseUrl.source.rawValue.replacingOccurrences(of: "[SOURCE]", with: source)
    Alamofire.request(url)
            .validate()
            .response { response in
                  print(response)
                  guard let data = response.data else { return }
                  do {
                      let decoder = JSONDecoder()
                      let topHeadlinesResponse = try decoder.decode(TopHeadlinesResponse.self, from: data)
                      completion(ApiResult.success(topHeadlinesResponse))
                      print(topHeadlinesResponse)
                  } catch let error {
                      completion(ApiResult.failure(error))
                      print(error)
                  }
          }
  }
    
}

