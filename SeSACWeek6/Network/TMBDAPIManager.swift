//
//  TMBDAPIManager.swift
//  SeSACWeek6
//
//  Created by yongseok lee on 2022/08/10.
//

import Foundation

import Alamofire
import SwiftyJSON
/*
 TMDB API
 https://developers.themoviedb.org/3/tv-seasons/get-tv-season-details
 */

class TMBDAPIManager {
    static let shared = TMBDAPIManager()
    
    private init() { }
    
    let tvList = [
        ("환혼", 135157),
        ("이상한 변호사 우영우", 197067),
        ("인사이더", 135655),
        ("미스터 션사인", 75820),
        ("스카이 캐슬", 84327),
        ("사랑의 불시착", 94796),
        ("이태원 클라스", 96162),
        ("호텔 델루나", 90447)
    ]
    
    let imageURL = "https://image.tmdb.org/t/p/w500"
    
    
    
    func callRequest(query: Int, completionHandler: @escaping ([String]) -> ()) {
       
        let url = "https://api.themoviedb.org/3/tv/\(query)/season/1?api_key=\(APIKey.TMDB)&language=ko-KR"
        
        //Alaofire로 해도 애플의 URLSession을 써서 비동기 처리를 한다. 내부적으로
        AF.request(url, method: .get ).validate().responseData { response in
            switch response.result {
            case.success(let value):
                let json = JSON(value)
                
                let stillPath = json["episodes"].arrayValue.map { $0["still_path"].stringValue }
                dump(stillPath) //print vs dump
                               
                completionHandler(stillPath)
   
                
            case .failure(let error):
                print(error)
            }
        }
    }
    
    func requestEpisodeImage(completionHandler: @escaping ([[String]])-> ()) {
        
        //어떤 문제가 생길 수 있을까?
        //1.순서보장이 없다. 언제 끝날지 모른다. 3. limit에 짤릴수있음 => 다음주에 해결
//        for item in tvList {
//            TMBDAPIManager.shared.callRequest(query: item.1) { stillPath in
//                print(stillPath)
//            }
//        }
        
        var posterList: [[String]] = []
       
        //나중에 배울것: async/await(iOS13이상) -> 이게 좋은 이유가 아래와 같은 문제 해결
        
        TMBDAPIManager.shared.callRequest(query: tvList[0].1) { value in
            posterList.append(value)

            TMBDAPIManager.shared.callRequest(query: self.tvList[1].1) { value in
                posterList.append(value)

                TMBDAPIManager.shared.callRequest(query: self.tvList[2].1) { value in
                    posterList.append(value)
                   
                    TMBDAPIManager.shared.callRequest(query: self.tvList[3].1) { value in
                        posterList.append(value)
                     
                        TMBDAPIManager.shared.callRequest(query: self.tvList[4].1) { value in
                            posterList.append(value)
                           
                            TMBDAPIManager.shared.callRequest(query: self.tvList[5].1) { value in
                                posterList.append(value)
                                
                                TMBDAPIManager.shared.callRequest(query: self.tvList[6].1) { value in
                                    posterList.append(value)
                                    
                                    TMBDAPIManager.shared.callRequest(query: self.tvList[7].1) { value in
                                        posterList.append(value)
                                        completionHandler(posterList)
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }
    }
    
}
