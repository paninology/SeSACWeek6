//
//  ViewController.swift
//  SeSACWeek6
//
//  Created by yongseok lee on 2022/08/08.
//

import UIKit

import Alamofire
import SwiftyJSON
import Kingfisher


/*
 1. html tag <> </> 기능 활용
 2. 문자열 대체 메서드 활용
 */


/*
 TableView automaticDemension
 -컨텐츠 양에 따라서 크기 다르게
 -조건:
 -조건: 
 -조건 : 레이아웃
 
 */

class ViewController: UIViewController {

    @IBOutlet weak var tablewView: UITableView!
 
    var blogList: [String] = []
    var cafeList: [String] = []
    var isExpanded = false //false면 2줄, 트루면 0줄
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tablewView.delegate = self
        tablewView.dataSource = self
       
       searchBlog()
    
    }
    
    func searchBlog() {
        
         KakaoAPIManager.shared.callRequest(type: .blog, query: "고래밥") { json in
             self.blogList = json["documents"].arrayValue.map { $0["contents"].stringValue.replacingOccurrences(of: "<b>", with: "").replacingOccurrences(of: "</b>", with: "") }
 
             self.searchCafe()
         }
    }
    
    func searchCafe() {
        KakaoAPIManager.shared.callRequest(type: .cafe, query: "고래밥") { json in
            self.cafeList = json["documents"].arrayValue.map { $0["contents"].stringValue.replacingOccurrences(of: "<b>", with: "").replacingOccurrences(of: "</b>", with: "") }
            print(self.blogList)
            self.tablewView.reloadData()
        }
    }
    
    @IBAction func expandCell(_ sender: UIBarButtonItem) {
        
        self.isExpanded.toggle()
        tablewView.reloadData()
        print("blog",blogList ,"cafe",cafeList)
    }
    
}

extension ViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    
        return section == 0 ? blogList.count : cafeList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "kakaoCell") as? kakaoCell else {
            return UITableViewCell()
        }
        cell.testLabel.numberOfLines = isExpanded ? 2 : 0
        
        cell.testLabel.text = indexPath.section == 0 ? blogList[indexPath.row] : cafeList[indexPath.row]
        print(indexPath.row)
        
        return cell
    }
  
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return section == 0 ? "블로그 검색결과" : "카페 검색결과"
    }
    
}

class kakaoCell: UITableViewCell {
    
    
    @IBOutlet weak var testLabel: UILabel!
}

