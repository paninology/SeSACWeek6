//
//  CardCollectionViewCell.swift
//  SeSACWeek6
//
//  Created by yongseok lee on 2022/08/09.
//

import UIKit

class CardCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var cardView: CardView!
    
    //변경되지 않는 UI 작성
    override func awakeFromNib() {
        super.awakeFromNib()
        print("CardCollectionViewcell", #function)
        setupUI()
        
    }
    override func prepareForReuse() {
        super.prepareForReuse()
//        cardView.contentsLabel.text = "a"
    }
    
    func setupUI() {
        cardView.backgroundColor = .clear
        cardView.posterImageView.backgroundColor = .lightGray
        cardView.posterImageView.layer.cornerRadius = 5
        cardView.likeButton.tintColor = .systemPink
        
    
    }

}
