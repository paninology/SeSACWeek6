//
//  CardView.swift
//  SeSACWeek6
//
//  Created by yongseok lee on 2022/08/09.
//

import UIKit
/*
 Xml Interface Builder 원래 셀에서만 사용가능. 비슷하게 만들수 있다.
 1. uiview custom class
 2. File's owner
 */

/*
 view:
 -인터페이스 필더 ui c초기화 구문 required init
  -> 프로토콜 초기화 구문. required > 초기화 구문이 프로토콜로 명시되어 있음을 의미
 - 코드 ui 초기화 구문: override init
 
 */

protocol A {
    func example()
    init()
}


class CardView: UIView {

    @IBOutlet weak var posterImageView: UIImageView!
    
    @IBOutlet weak var likeButton: UIButton!
    
    @IBOutlet weak var contentsLabel: UILabel!
    
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
       
        
        let view = UINib(nibName: "CardView", bundle: nil).instantiate(withOwner: self).first as! UIView
        
        view.backgroundColor = .blue
        self.addSubview(view)
        
        //카드뷰를 인터페이스 빌더 기반으로 만들고, 오토레이아앗도 설정했는데 왜 트루냐......
        //addSubView를 하는 과정이 코드로 뷰를 만들었다고 보기 때문
        //오토리사이징이 내부적으로 constraints 처리를 해주는것....
        print(view.translatesAutoresizingMaskIntoConstraints, "cardViewAouto=====")
    }
    
}
