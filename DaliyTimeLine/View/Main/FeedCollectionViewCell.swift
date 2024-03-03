//
//  FeedCollectionViewCell.swift
//  DaliyTimeLine
//
//  Created by Chung Wussup on 2/5/24.
//

import UIKit
import SnapKit
import Kingfisher

class FeedCollectionViewCell: UICollectionViewCell {
    
    var imageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
        iv.layer.cornerRadius = 10
        iv.layer.masksToBounds = true
        iv.kf.indicatorType = .activity
        return iv
    }()
    
    var titleLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.numberOfLines = 0
        label.font = UIFont(name: "OTSBAggroM", size: 14)
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(imageView)
        imageView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        addSubview(titleLabel)
        titleLabel.snp.makeConstraints{
            $0.edges.equalToSuperview()
            $0.centerX.centerY.equalTo(self)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func configureUI(post: Post) {
        self.titleLabel.isHidden = true
        self.imageView.isHidden = false
        if let postImageURL = URL(string:post.imageUrl) {
            imageView.kf.setImage(with: postImageURL,options: [.transition(.fade(1.2))])
        }
    }
    
    func cofigureTitle() {
        self.titleLabel.isHidden = false
        self.imageView.isHidden = true
        self.titleLabel.text = "등록된 사진이 없습니다."
    }
    
}
