//
//  URL+Extension.swift
//  SeSACWeek6
//
//  Created by yongseok lee on 2022/08/08.
//

import Foundation
import UIKit


extension URL {
    static let baseURL = "https://dapi.kakao.com/v2/search/"
    
    static func makeEndPointString(_ endpoint: String) -> String {
        return baseURL + endpoint
    }
}

extension UILabel {
    
}
