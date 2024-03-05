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
    
    var originalImage: UIImage?
    var selectedImage: UIImage? {
        didSet {
            if let image = selectedImage{
                originalImage = image
                photoImageView.image = image
            }
        }
    }
    
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
        tv.font = UIFont(name: "OTSBAggroL", size: 16)
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
    
    private let dateLabel: UILabel = {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy년 MM월 dd일 (E)\nHH:mm"
        let dateString = dateFormatter.string(from: Date())
        
        let label = UILabel()
        label.numberOfLines = 0
        label.text = dateString
        label.font = UIFont(name: "OTSBAggroM", size: 24) ?? UIFont.boldSystemFont(ofSize: 24)
        label.textColor = .white
        return label
    }()

    weak var delegate: MainListViewControllerDelegate?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        NotificationCenter.default.removeObserver(self)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    
    
    func configureUI() {
        view.backgroundColor = .white
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(didTapCancel))
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "등록", style: .done, target: self, action: #selector(didTapDone))
        
        view.addSubview(photoImageView)
        photoImageView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide)
            make.leading.equalToSuperview().offset(16)
            make.trailing.equalToSuperview().offset(-16)
            make.height.equalTo(photoImageView.snp.width)
            make.centerX.equalTo(view)
        }
        
        photoImageView.addSubview(dateLabel)
        dateLabel.snp.makeConstraints { make in
            make.leading.equalTo(photoImageView.snp.leading).offset(16)
            make.trailing.equalTo(photoImageView.snp.trailing).offset(-16)
            make.bottom.equalTo(photoImageView.snp.bottom).offset(-16)
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
            make.bottom.lessThanOrEqualTo(view.safeAreaLayoutGuide)
        }
        
        
    }
    
    @objc func didTapCancel() {
        //        delegate?.controllerDidFinishUploadingPost(self)
        dismiss(animated: true)
    }
    
    @objc func didTapDone() {
        LoadingIndicator.showLoading()
        
        guard let mergedImage = self.transfromToImage(view: photoImageView) else {
            print("Error: Failed to merge text to image")
            LoadingIndicator.hideLoading()
            return
        }
        
        guard let caption = captionTextView.text else { return }
        guard let user = currentUser else { return }
        
        UploadService.uploadPost(caption: caption, image: mergedImage, user: user) { error in
            
            LoadingIndicator.hideLoading()
            if let error = error {
                print(#function,"\(error.localizedDescription)")
                return
            }
            
            self.dismiss(animated: true) {
                if let autoSave = UserDefaults.standard.value(forKey: "AutoSave") as? Bool {
                    if autoSave {
                        UIImageWriteToSavedPhotosAlbum(mergedImage, self, nil, nil)
                    }
                }
                
                self.delegate?.reload()
            }
        }
    }
    
    
    func checkMaxLength(_ textView: UITextView) {
        if (textView.text.count) > 100 {
            textView.deleteBackward()
        }
    }
    
    func transfromToImage(view: UIView) -> UIImage? {
        UIGraphicsBeginImageContextWithOptions(view.bounds.size, true, 0.0)
        defer {
            UIGraphicsEndImageContext()
        }
        if let context = UIGraphicsGetCurrentContext() {
            view.layer.render(in: context)
            return UIGraphicsGetImageFromCurrentImageContext()
        }
        return nil
    }
    
    @objc func keyboardWillShow(_ notification:NSNotification) {
        if let keyboardFrame:NSValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
            let keyboardRectangle = keyboardFrame.cgRectValue
            
            UIView.animate(withDuration: 0.3, animations: {
                self.view.transform = CGAffineTransform(translationX: 0, y: -(keyboardRectangle.height/2))
                }
            )
        }
    }
    
    @objc func keyboardWillHide(_ notification:NSNotification) {
        self.view.transform = .identity
    }
    

    
}


//MARK: - UITextViewDelegate
extension UploadContentViewController: UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
        checkMaxLength(textView)
        let count = textView.text.count
        charaterCountLabel.text = "\(count)/100"
        
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
