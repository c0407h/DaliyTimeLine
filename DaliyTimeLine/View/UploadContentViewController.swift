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
                //                drawText(onImage: image)
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
        }
    }
    
    @objc func didTapCancel() {
        //        delegate?.controllerDidFinishUploadingPost(self)
        dismiss(animated: true)
    }
    
    @objc func didTapDone() {
        //        guard let image = selectedImage else { return }
        //내용 없을 시 Alert띄ㅣ어줘야함
        //        guard let mergedImage = self.drawText(onImage: image) else {
        //            print("Error: Failed to merge text to image")
        //            return
        //        }
        guard let mergedImage = self.transfromToImage(view: photoImageView) else {
            print("Error: Failed to merge text to image")
            return
        }
        //        photoImageView.image = mergedImage
        
        
        guard let caption = captionTextView.text else { return }
        guard let user = currentUser else { return }
        //                showLoader(true)
        
        UploadService.uploadPost(caption: caption, image: mergedImage, user: user) { error in
            //            self.showLoader(false)
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
    
    //TODO: - 수정필요
    //    func drawText(onImage image: UIImage) -> UIImage? {
    //        let dateFormatter = DateFormatter()
    //        dateFormatter.dateFormat = "yyyy년 MM월 dd일 (E)\nHH:mm"
    //        let dateString = dateFormatter.string(from: Date())
    //
    //
    //        let imageSize = self.originalImage?.size ?? .zero
    //        UIGraphicsBeginImageContextWithOptions(CGSize(width: imageSize.width, height: imageSize.height), false, 1.0)
    //        let currentView = UIView(frame: CGRect(x: 0, y: 0, width: imageSize.width, height: imageSize.height))
    //        let currentImage = UIImageView(image: self.originalImage)
    //        currentImage.frame = CGRect(x: 0, y: 0, width: imageSize.width, height: imageSize.height)
    //        currentView.addSubview(currentImage)
    //
    //        let label = UILabel()
    //        label.frame = currentView.frame
    //
    //        let fontSize: CGFloat = 18
    //        let font = UIFont(name:"OTSBAggroM" , size: fontSize)
    //        let attributedStr = NSMutableAttributedString(string: dateString)
    //        attributedStr.addAttribute(NSAttributedString.Key(rawValue: kCTFontAttributeName as String), value: font ?? .init(), range: (dateString as NSString).range(of: dateString))
    //        attributedStr.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor.white, range: (dateString as NSString).range(of: dateString))
    //
    //        label.attributedText = attributedStr
    //        label.numberOfLines = 0
    //        label.textAlignment = .left
    //        label.text = dateString
    //
    //        let labelSize = label.sizeThatFits(currentView.bounds.size)
    //        label.frame = CGRect(x: currentView.bounds.midX,
    //                             y: currentView.bounds.midY,
    //                             width: labelSize.width,
    //                             height: labelSize.height)
    //
    //
    //        currentView.addSubview(label)
    //
    //        guard let currentContext = UIGraphicsGetCurrentContext() else {
    //            return nil
    //        }
    //        currentView.layer.render(in: currentContext)
    //        let img = UIGraphicsGetImageFromCurrentImageContext()
    //        UIGraphicsEndImageContext()
    //        return img
    //
    //
    ////                let dateFormatter = DateFormatter()
    ////                dateFormatter.dateFormat = "yyyy년 MM월 dd일 (E)\nHH:mm"
    ////                let dateString = dateFormatter.string(from: Date())
    ////
    ////                let imageSize = image.size
    ////
    ////                // 이미지 그래픽 컨텍스트 생성
    ////                UIGraphicsBeginImageContextWithOptions(imageSize, false, 0.0)
    ////
    ////                // 이미지 그리기
    ////                image.draw(in: CGRect(origin: .zero, size: imageSize))
    ////
    ////                // 텍스트 속성 설정
    ////                let textFont = UIFont(name: "OTSBAggroM", size: 12) ?? UIFont.boldSystemFont(ofSize: 12)
    ////                let textColor = UIColor.white
    ////
    ////                // 텍스트 크기 계산
    ////                let textSize = (dateString as NSString).size(withAttributes: [.font: textFont])
    ////
    ////                // 텍스트 위치 계산
    ////                let textRect = CGRect(x: 10,
    ////                                      y: imageSize.height - 35,
    ////                                      width: textSize.width,
    ////                                      height: textSize.height)
    ////
    ////                // 텍스트 그리기
    ////                let textAttributes: [NSAttributedString.Key: Any] = [
    ////                    .font: textFont,
    ////                    .foregroundColor: textColor
    ////                ]
    ////                (dateString as NSString).draw(in: textRect, withAttributes: textAttributes)
    ////
    ////                // 이미지 컨텍스트에서 이미지 추출
    ////                let combinedImage = UIGraphicsGetImageFromCurrentImageContext()
    ////
    ////                // 이미지 그래픽 컨텍스트 종료
    ////                UIGraphicsEndImageContext()
    ////
    ////                return combinedImage
    //    }
    
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
