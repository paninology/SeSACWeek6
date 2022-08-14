//
//  MainViewController.swift
//  SeSACWeek6
//
//  Created by yongseok lee on 2022/08/09.
//

import UIKit

class MainViewController: UIViewController {

    
    /*
     awakeFromNib = 셀 ui초기화, 재사용 매커니즘에 의해 일정 이상 호출되지 않음
     cellForRowAt = 매번 호출
     - 재사용 될 때마다, 사용자에게 보일 때마다 항상 실행
     - 화면과 데이터는 ㄴ별개, 모든 indexpathitem과 데이터가 매칭되지 않으면 에러
     PrepareForReuse
     - 셀이 재사용 될 때 초기화 하고자 하는 값을 넣으면 오류를 해결할 수 있음. 즉 cellForRowAt에서 모든 indexpath.itme에 대한 조건을 작성하지 않아도 된다.
     CollectionView in TableView
     -하나의 컬렉션부나 테이블뷰라면 문제없음
     -복합적인 구조라면, 테이블뷰셀도 재사용 되어야 하고 컬렉션셀도 재사용이 되어야 함
     */

    @IBOutlet weak var bannerCollectionView: UICollectionView!
    @IBOutlet weak var mainTableView: UITableView!
    
    let color: [UIColor] = [.red, .systemPink, .lightGray, .yellow, .black]
    let numberList: [[Int]] = [
        [Int](100...110),
        [Int](55...75),
        [Int](76...100),
        [Int](100...150),
        [Int](55...105),

    ]
    var episodeList: [[String]] = []
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        bannerCollectionView.dataSource = self
        bannerCollectionView.delegate = self
        bannerCollectionView.register(UINib(nibName: "CardCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "CardCollectionViewCell")
        bannerCollectionView.collectionViewLayout = collectionViewLayout()
        bannerCollectionView.isPagingEnabled = true //디바이스 너비 기준이라서 한계가 있다
        mainTableView.dataSource = self
        mainTableView.delegate = self
        
        
        TMBDAPIManager.shared.requestEpisodeImage { poster in
            dump(poster)
            //1. 네트워크 통신 2. 배열 생성, 3. 배열에 담기
            //4.뷰등에 표현
            //ex. 테이블뷰 섹션, 컬렉션부 셀
            //5. 뷰 갱신
            self.episodeList = poster
            self.mainTableView.reloadData()
        }
        //테이블뷰 셀 높이나 컬렉션뷰 셀 사이즈 수정
    
    }

}

extension MainViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        episodeList.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        1
    }
    
    //내부 매개변수 tableView를 통해 테이블뷸르 특정
    //테이블뷰 객체가 하나일 경우, 내부 매개변수를 활용하지 않아도 문제가 없다.
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "MainTableViewCell") as? MainTableViewCell else { return UITableViewCell() }
 
        print("MainViewcontroller", #function, indexPath)
        
        cell.backgroundColor = .yellow
        cell.contentCollectionView.delegate = self
        cell.contentCollectionView.dataSource = self
        cell.contentCollectionView.backgroundColor = .lightGray
        cell.contentCollectionView.tag = indexPath.section //UIView Tag
        cell.contentCollectionView.register(UINib(nibName: CardCollectionViewCell.reuseIdentifier, bundle: nil), forCellWithReuseIdentifier: CardCollectionViewCell.reuseIdentifier)
        cell.contentCollectionView.reloadData() //Index 오류를 해결해 준다.
        cell.titleLAbel.text = TMBDAPIManager.shared.tvList[indexPath.section].0 + " 드라마 다시보기"
        
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 240
    }
    
    
}

//하나의 프로토콜, 메서드ㅔ서 여러 컬렉션뷰의 delegate, datesource 구현해야함
extension MainViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    /*
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout:  UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize { //각 아이템마다 크기 다르게 하기
        
    }
     */
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return collectionView == bannerCollectionView ? color.count : episodeList[collectionView.tag].count
    }

    //매개변수(collectionView)에 bannerCollectionView나 테이블뷰 안의 컨텐트컬렉션부 둘다 들어갈 수 있다
    //내부 매개변수가 아닌 명확한 아웃렛을 사용할 경우, 셀이 재사용 되면, 특정 collectionView 셀을 재사용 하게 될 수 이다.
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        print("MainViewControoler",#function, indexPath)
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CardCollectionViewCell", for: indexPath) as? CardCollectionViewCell else  {
            return  UICollectionViewCell()
    
        }
        
        if collectionView == bannerCollectionView {
            cell.cardView.posterImageView.backgroundColor = color[indexPath.item]
        } else {
//            cell.cardView.contentsLabel.text = numberList[collectionView.tag][indexPath.item].description
            cell.cardView.contentsLabel.textColor = .white
            cell.cardView.posterImageView.backgroundColor = .black
            cell.cardView.backgroundColor = .red
            
            let url = URL(string: TMBDAPIManager.shared.imageURL + episodeList[collectionView.tag][indexPath.item] )
            cell.cardView.posterImageView.kf.setImage(with: url)
            
            
//            if indexPath.item < 2 {
//                cell.cardView.contentsLabel.text = numberList[collectionView.tag][indexPath.item].description
////            }
//            else {
//                cell.cardView.contentsLabel.text = "happy"
//            }
        }
           
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("collectioncViewcell==============select")
    }

    func collectionViewLayout() -> UICollectionViewFlowLayout {
        
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.itemSize = CGSize(width: UIScreen.main.bounds.width , height: bannerCollectionView.frame.height )
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0 )
        
        return layout
    }
//    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
//        
//    }
    
}




