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
    func talkLabelsSet() {
        self.layer.cornerRadius = 5
        self.clipsToBounds = true
        self.backgroundColor = .white
        self.font = .systemFont(ofSize: 16)
        self.textColor = .black
        
        
    }
}
