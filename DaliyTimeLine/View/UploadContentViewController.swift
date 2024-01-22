//
//  UploadContentViewController.swift
//  DaliyTimeLine
//
//  Created by Chung Wussup on 1/22/24.
//

import UIKit
import SnapKit

class UploadContentViewController: UIViewController {
    
    var currentUser: User?
    var selectedImage: UIImage? {
        didSet {
            photoImageView.image = selectedImage
        }
    }
    
//    init(currentUser: User? = nil, selectedImage: UIImage? = nil) {
//        self.currentUser = currentUser
//        self.selectedImage = selectedImage
//        super.init(nibName: nil, bundle: nil)
//    }
//    
//    required init?(coder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
    
    private let photoImageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        iv.layer.cornerRadius = 10
        return iv
    }()
    
    private lazy var captionTextView: InputTextView = {
        let tv = InputTextView()
        tv.backgroundColor = .white
        tv.layer.borderWidth = 1
        tv.layer.borderColor = UIColor.lightGray.cgColor
        tv.layer.cornerRadius = 10
        tv.placeholderText = "내용을 입력해 주세요"
        tv.font = UIFont.systemFont(ofSize: 16)
        tv.textColor = .black
        tv.delegate = self
        tv.placeholderShouldCenter = false
        return tv
    }()
    
    private let charaterCountLabel: UILabel = {
        let label = UILabel()
        label.textColor = .lightGray
        label.font = UIFont.systemFont(ofSize: 14)
        label.text = "0/100"
        return label
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
    }
    
    func configureUI() {
        view.backgroundColor = .white
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(didTapCancel))
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "등록", style: .done, target: self, action: #selector(didTapDone))
        
        view.addSubview(photoImageView)
        photoImageView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide)
            make.height.width.equalTo(180)
            make.centerX.equalTo(view)
        }
        
        view.addSubview(captionTextView)
        captionTextView.snp.makeConstraints { make in
            make.top.equalTo(photoImageView.snp.bottom).offset(16)
            make.leading.equalTo(view).offset(12)
            make.trailing.equalTo(view).offset(-12)
            make.height.equalTo(64)
        }
        
        view.addSubview(charaterCountLabel)
        charaterCountLabel.snp.makeConstraints { make in
            make.top.equalTo(captionTextView.snp.bottom)
            make.trailing.equalTo(view).offset(-12)
            
            
        }
        
        
    }
    
    @objc func didTapCancel() {
        //        delegate?.controllerDidFinishUploadingPost(self)
        dismiss(animated: true)
    }
    
    @objc func didTapDone() {
        guard let image = selectedImage else { return }
        guard let caption = captionTextView.text else { return }
        guard let user = currentUser else { return }
        //                showLoader(true)
        
        UploadService.uploadPost(caption: caption, image: image, user: user) { error in
//            self.showLoader(false)
            if let error = error {
                print(#function,"\(error.localizedDescription)")
                return
            }
            
        }
    }
    
    
    func checkMaxLength(_ textView: UITextView) {
        if (textView.text.count) > 100 {
            textView.deleteBackward()
        }
    }
}


//MARK: - UITextViewDelegate
extension UploadContentViewController: UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
        checkMaxLength(textView)
        let count = textView.text.count
        charaterCountLabel.text = "\(count)/100"
        
        //        captionTextView.placeholderLabel.isHidden = !captionTextView.text.isEmpty
        
        let size = CGSize(width: view.frame.width, height: .infinity)
        let estimatedSize = textView.sizeThatFits(size)
        
        textView.constraints.forEach { (constraint) in
            
            // 더 이상 줄어들지 않게하기
            
            
            if estimatedSize.height <= 64 {
                
            } else if estimatedSize.height >= 180 {
            }else {
                if constraint.firstAttribute == .height {
                    constraint.constant = estimatedSize.height
                }
            }
        }
    }
}
