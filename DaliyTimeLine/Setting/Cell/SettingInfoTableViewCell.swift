//
//  SettingInfoTableViewCell.swift
//  DaliyTimeLine
//
//  Created by Chung Wussup on 3/3/24.
//

import UIKit

class SettingInfoTableViewCell: UITableViewCell {
    static let id = "SettingInfoTableViewCell"
    lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "OTSBAggroM", size: 14)
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        selectionStyle = .none
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    func configureUI() {
        contentView.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { make in
            make.leading.equalTo(self).offset(16)
            make.centerX.centerY.equalToSuperview()
            make.height.equalTo(44)
        }
    }
    
    func counfigureCell(title: String) {
        titleLabel.text = title
    }
    
}
