//
//  SettingAppInfoTableViewCell.swift
//  DaliyTimeLine
//
//  Created by Chung Wussup on 3/3/24.
//

import UIKit

class SettingAppInfoTableViewCell: UITableViewCell {
    static let id = "SettingAppInfoTableViewCell"
   
    lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "OTSBAggroM", size: 14)
        return label
    }()
    
    lazy var appVersionLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "OTSBAggroM", size: 12)
        label.textColor = .lightGray
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
        
        contentView.addSubview(appVersionLabel)
        appVersionLabel.snp.makeConstraints { make in
            make.trailing.equalTo(self).offset(-16)
            make.centerY.equalToSuperview()
        }
        
  
    }
    
    func counfigureCell(title: String, appVersion: String) {
        titleLabel.text = title
        appVersionLabel.text = appVersion
    }

}
