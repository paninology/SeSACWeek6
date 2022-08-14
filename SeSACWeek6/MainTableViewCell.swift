//
//  MainTableViewCell.swift
//  SeSACWeek6
//
//  Created by yongseok lee on 2022/08/09.
//

import UIKit

class MainTableViewCell: UITableViewCell {

    @IBOutlet weak var contentCollectionView: UICollectionView!
    @IBOutlet weak var titleLAbel: UILabel!
    
    var test = 1
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupUI()
        print(test)
        
    }

    func setupUI() {
        
        titleLAbel.font = .boldSystemFont(ofSize: 24)
        titleLAbel.text = "넷플릭스 인기 콘텐츠"
        
        contentCollectionView.backgroundColor = .lightGray
        contentCollectionView.collectionViewLayout = collectionViewLayout()
    }
    func collectionViewLayout() -> UICollectionViewFlowLayout {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.itemSize = CGSize(width: 300, height: 180)
        layout.minimumLineSpacing = 8
        layout.minimumInteritemSpacing = 8
        layout.sectionInset = UIEdgeInsets(top: 0, left: 8, bottom: 0, right: 0)
        
        return layout
        
    }
    
    
    
}
