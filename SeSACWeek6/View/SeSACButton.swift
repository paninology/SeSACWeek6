//
//  SeSACButton.swift
//  SeSACWeek6
//
//  Created by yongseok lee on 2022/08/09.
//

import UIKit

/*
 Swift Attribute
 @IBInspectable, @IBDesignable @objc
 */



@IBDesignable    //인터페이스 빌더 컴파일 시점 실시간으로 객체 속성을 확인할 수 있음
class SeSACButton: UIButton {
    //인터페이스 빌더 인스펙터 영역에 보여준다 show!
   @IBInspectable
    var cornerRadius: CGFloat {
        get {
            return layer.cornerRadius
        }
        set {
            layer.cornerRadius = newValue
        }
    }
    
    @IBInspectable var borderWidth: CGFloat {
        get { return layer.borderWidth }
        set { layer.borderWidth = newValue }
    }

    @IBInspectable var borderColor: UIColor {
        get { return UIColor(cgColor: layer.borderColor!) }
        set { layer.borderColor = newValue.cgColor }
    }
}
