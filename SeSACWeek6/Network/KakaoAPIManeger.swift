//
//  KakaoAPIManeger.swift
//  SeSACWeek6
//
//  Created by yongseok lee on 2022/08/08.
//

import Foundation

import Alamofire
import SwiftyJSON

class KakaoAPIManager {
    
    static let shared = KakaoAPIManager()
    private init() { }
    
    let header: HTTPHeaders = ["Authorization": "KakaoAK \(APIKey.kakao)"]
    
    func callRequest(type: Endpoint, query: String, completionHandler: @escaping (JSON) -> ()) {
        guard let query = query.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) else { return }
        let url = type.requestURL + query
        //Alaofire로 해도 애플의 URLSession을 써서 비동기 처리를 한다. 내부적으로
        AF.request(url, method: .get, headers: header).validate().responseData { response in
            switch response.result {
            case.success(let value):
                let json = JSON(value)

                completionHandler(json)
                
            case .failure(let error):
                print(error)
            }
        }
    }
}
