//
//  SettingTableViewCell.swift
//  DaliyTimeLine
//
//  Created by Chung Wussup on 3/3/24.
//

import UIKit

enum SettingCellType: Int {
    case autoSave
    case screenSecret
}

protocol SettingTableViewCellDelegate: AnyObject {
    func showSettingSecretView()
    
//    func settingSecretCancel()
}

class SettingTableViewCell: UITableViewCell {
    static let id = "SettingTableViewCell"
    
    var cellType: SettingCellType = .autoSave
    weak var delegate: SettingTableViewCellDelegate?
    
    lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "OTSBAggroM", size: 14)
        return label
    }()
    
    lazy var photoAutoSaveSwitch: UISwitch = {
        let us = UISwitch()
        us.addTarget(self, action: #selector(onClickSwitch(sender:)), for: .valueChanged)
        return us
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
        
        contentView.addSubview(photoAutoSaveSwitch)
        photoAutoSaveSwitch.snp.makeConstraints { make in
            make.trailing.equalTo(self).offset(-16)
            make.centerY.equalToSuperview()
        }
    }
    
    func configureCell(title: String, index: SettingCellType) {
        self.cellType = index
        switch index {
        case .autoSave :
            configureAutuSaveCell(title: title)
        case .screenSecret:
            configureScreenSecretCell(title: title)
        }
        
    }
    
    func configureAutuSaveCell(title: String){
        titleLabel.text = title
        let autoSave = UserDefaults.standard.value(forKey: "AutoSave") as? Bool
        photoAutoSaveSwitch.isOn = autoSave ?? false
    }
    
    @objc func onClickSwitch(sender: UISwitch) {
        print(cellType)
        switch cellType {
        case .autoSave:
            UserDefaults.standard.setValue(sender.isOn, forKey: "AutoSave")
        case .screenSecret:
            if sender.isOn {
                self.delegate?.showSettingSecretView()
            } else {
                UserDefaults.standard.removeObject(forKey: "LoginSecret")
            }
        }
    }
    
    func configureScreenSecretCell(title: String) {
        titleLabel.text = title
        photoAutoSaveSwitch.isOn = UserDefaults.standard.string(forKey: "LoginSecret") != nil ? true : false
    }
    
}
