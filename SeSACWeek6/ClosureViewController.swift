//
//  ClosureViewController.swift
//  SeSACWeek6
//
//  Created by yongseok lee on 2022/08/08.
//

import UIKit


class ClosureViewController: UIViewController {

    @IBOutlet weak var cardView: CardView!
    
    @IBOutlet weak var sampleView2: UIView!
    
    //Frame Based layout
    
    var sampleView = UIView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //위치,크기,추가
        /*
         오토리사이징을 오토레이아웃 제약조건처럼 설정해주는 기능이 내부적으로 구현되어 있음.
         이 기능은 디폴트가 true, 하지만 오토레이아웃을 지정해주면 오토리사이징을 안쓰겠다는 의미인 false로 상태가 내부적으로 변경됨
         코드기반 ui > true
         인터페이스빌더 기반 레이아웃 ui> false
         
         */
      
        sampleView.frame = CGRect(x: 100, y: 400, width: 100, height: 100)
        sampleView.backgroundColor = .red
//        view.addSubview(sampleView)
        
        cardView.posterImageView.backgroundColor = .red
        cardView.likeButton.backgroundColor = .yellow
        cardView.likeButton.addTarget(self, action: #selector(likeButtonClicked), for: .touchUpInside)

        
    }
    
    @objc func likeButtonClicked() {
        print("button click")
    }
    
    @IBAction func colorPickerButtonClicked(_ sender: UIButton) {
        showAlert(title: "컬러피커를 띄우겟습니까", message: nil, okTitle: "Yes") {
            let picker = UIColorPickerViewController()
            self.present(picker, animated: true)
        }
    }
    
    @IBAction func backgroundColorChanged(_ sender: UIButton) {
        
        showAlert(title: "배경색을 바ㅣ꾸시겠어요?", message: nil, okTitle: "바꾸기") {
            self.view.backgroundColor = .gray
        }
    }
    

}

extension UIViewController {
    
    func showAlert(title: String, message: String?, okTitle: String, okAction: @escaping () -> ()) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let cancel = UIAlertAction(title: "cancel", style: .cancel)
        let ok = UIAlertAction(title: okTitle, style: .default) { action in
            
            okAction()
            
        }
        
        alert.addAction(cancel)
        alert.addAction(ok)
        
        present(alert, animated: true)
    }
}
