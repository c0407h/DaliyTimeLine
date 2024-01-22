//
//  InputTextView.swift
//  DaliyTimeLine
//
//  Created by Chung Wussup on 1/22/24.
//

import UIKit
import SnapKit

class InputTextView: UITextView {
    
    //MARK: - Properties
    var placeholderText: String? {
        didSet { placeholderLabel.text = placeholderText }
    }
    
    let placeholderLabel: UILabel = {
       let label = UILabel()
        label.textColor = .lightGray
        return label
    }()
    
    var placeholderShouldCenter = true {
        didSet {
            if placeholderShouldCenter {
                placeholderLabel.snp.makeConstraints { make in
                    make.trailing.equalTo(self).offset(-8)
                    make.leading.equalTo(self).offset(8)
                    make.centerX.equalTo(self)
                }
            } else {
                
                placeholderLabel.snp.makeConstraints { make in
                    make.top.equalTo(self).offset(6)
                    make.leading.equalTo(self).offset(8)
                }
            }
        }
    }
    
    override init(frame: CGRect, textContainer: NSTextContainer?) {
        super.init(frame: frame, textContainer: textContainer)
        
        addSubview(placeholderLabel)
        placeholderLabel.snp.makeConstraints { make in
            make.top.equalTo(self).offset(6)
            make.leading.equalTo(self).offset(8)
        }
        
        
        NotificationCenter.default.addObserver(self, selector: #selector(handleTextDidChange), name: UITextView.textDidChangeNotification, object: nil)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Actions
    @objc func handleTextDidChange() {
        placeholderLabel.isHidden = !text.isEmpty
    }
    
}
