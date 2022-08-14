//
//  WeatherAPIManager.swift
//  SeSACWeek6
//
//  Created by yongseok lee on 2022/08/13.
//

import Foundation
import CoreLocation

import Alamofire
import SwiftyJSON

class WeatherAPIManager {
    
    static let shared = WeatherAPIManager()
    private init() { }
  
    
    func callRequest(lat: Double, lon: Double, completionHandler: @escaping (JSON) -> ()) {
       
        let url = "https://api.openweathermap.org/data/2.5/weather?lat=\(lat)&lon=\(lon)&appid=\(APIKey.weather)&lang=kr"
        AF.request(url, method: .get).validate().responseData { response in
            switch response.result {
            case.success(let value):
                let json = JSON(value)

                completionHandler(json)
                
            case .failure(let error):
                print(error)
            }
        }
    }
    
    func iconURL(id: String)-> String {
        return "http://openweathermap.org/img/wn/\(id)@2x.png"
    }
}
