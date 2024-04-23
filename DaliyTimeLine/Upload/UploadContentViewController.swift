//
//  UploadContentViewController.swift
//  DaliyTimeLine
//
//  Created by Chung Wussup on 1/22/24.
//

import UIKit
import SnapKit
import RxSwift

class UploadContentViewController: UIViewController {
    private let viewModel: UploadViewModel?
    weak var delegate: MainListViewControllerDelegate?
    
    let textColorWell: UIColorWell =  {
        let colorWell = UIColorWell()
        colorWell.supportsAlpha = true
        colorWell.selectedColor = .black
        colorWell.title = "텍스트 색상 선택"
        return colorWell
    }()
    
    private lazy var scrollView: UIScrollView = {
        let sv = UIScrollView()
        sv.delegate = self
        return sv
    }()
    
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
        dateFormatter.dateFormat = "yyyy년 MM월 dd일 (E) HH:mm"
        let dateString = dateFormatter.string(from: Date())
        
        let label = UILabel()
        label.numberOfLines = 0
        label.text = dateString
        label.font = UIFont(name: "OTSBAggroM", size: 20) ?? UIFont.boldSystemFont(ofSize: 20)
        label.textColor = .white
        return label
    }()
    
    private let colorSelectLabel: UILabel = {
        let label = UILabel()
        label.text = "텍스트 색상 선택"
        label.font = UIFont(name: "OTSBAggroL", size: 16)
        return label
    }()
    
    private let disposeBag = DisposeBag()
    
    
    init(viewModel: UploadViewModel) {
        self.viewModel = viewModel
        
        super.init(nibName: nil, bundle: nil)
        
        viewModel.selectedImage
            .bind(to: photoImageView.rx.image)
            .disposed(by: disposeBag)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.configureUI()
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)),
                                               name: UIResponder.keyboardWillShowNotification,
                                               object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)),
                                               name: UIResponder.keyboardWillHideNotification,
                                               object: nil)
        view.addGestureRecognizer(UITapGestureRecognizer(target: self,
                                                         action: #selector(handleTap(sender:))))
        
        scrollView.canCancelContentTouches = true
        let panGesture = UIPanGestureRecognizer(target: self,
                                                action: #selector(handlePanGesture(_:)))
        dateLabel.isUserInteractionEnabled = true // dateLabel이 터치 이벤트를 받을 수 있도록 설정
        dateLabel.addGestureRecognizer(panGesture)
    }
    
    @objc func checkFrame(sender: UITapGestureRecognizer) {
        print("checkFram")
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        NotificationCenter.default.removeObserver(self)
        
    }
    
    
    func configureUI() {
        view.backgroundColor = .white
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel,
                                                           target: self,
                                                           action: #selector(didTapCancel))
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "등록",
                                                            style: .done,
                                                            target: self,
                                                            action: #selector(didTapDone))
        
        view.addSubview(scrollView)
        scrollView.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide)
            $0.leading.trailing.bottom.equalToSuperview()
        }
        
        scrollView.addSubview(photoImageView)
        photoImageView.snp.makeConstraints { make in
            make.top.equalTo(scrollView.snp.top).offset(10)
            make.leading.equalToSuperview().offset(16)
            make.trailing.equalToSuperview().offset(-16)
            
            make.width.height.equalTo(UIScreen.main.bounds.size.width - 32)
            make.centerX.equalTo(scrollView.snp.centerX)
        }
        
        
        //        photoImageView.addSubview(dateLabel)
        scrollView.addSubview(dateLabel)
        dateLabel.snp.makeConstraints { make in
            make.leading.equalTo(photoImageView.snp.leading).offset(16)
            //            make.trailing.equalTo(photoImageView.snp.trailing).offset(-16)
            make.bottom.equalTo(photoImageView.snp.bottom).offset(-16)
        }
        dateLabel.sizeToFit()
        
        
        scrollView.addSubview(colorSelectLabel)
        colorSelectLabel.snp.makeConstraints {
            $0.top.equalTo(photoImageView.snp.bottom).offset(10)
            $0.leading.equalToSuperview().offset(16)
//            $0.trailing.equalToSuperview().offset(-16)
        }
        scrollView.addSubview(textColorWell)
        textColorWell.snp.makeConstraints {
            $0.top.equalTo(photoImageView.snp.bottom).offset(10)
            $0.trailing.equalToSuperview().offset(-16)
        }
        textColorWell.addTarget(self, action: #selector(textColorChanged), for: .valueChanged)

        scrollView.addSubview(captionTextView)
        captionTextView.snp.makeConstraints { make in
            make.top.equalTo(colorSelectLabel.snp.bottom).offset(20)
            make.leading.equalToSuperview().offset(12)
            make.trailing.equalToSuperview().offset(-12)
            make.height.equalTo(64)
        }
        
        scrollView.addSubview(charaterCountLabel)
        charaterCountLabel.snp.makeConstraints { make in
            make.top.equalTo(captionTextView.snp.bottom)
            make.trailing.equalToSuperview().offset(-12)
            make.bottom.lessThanOrEqualToSuperview()
        }
    }
    
    @objc func handlePanGesture(_ recognizer: UIPanGestureRecognizer) {
        guard let view = recognizer.view else { return }
        let translation = recognizer.translation(in: view.superview)
        
        switch recognizer.state {
        case .changed:
            // 이동 후의 새로운 위치
            let newX = view.center.x + translation.x
            let newY = view.center.y + translation.y
            
            let halfWidth = view.frame.width/2
            let halfHeight = view.frame.height/2
            
            let newFrame = CGRect(x: photoImageView.frame.origin.x,
                                  y: photoImageView.frame.origin.y,
                                  width: photoImageView.frame.width,
                                  height: photoImageView.frame.height)
            
            
            if newX <= newFrame.maxX - halfWidth && newX >= newFrame.minX + halfWidth &&
                newY <= newFrame.maxY - halfHeight && newY >= newFrame.minY + halfHeight{
                view.center = CGPoint(x: newX, y: newY)
                recognizer.setTranslation(CGPoint.zero, in: view.superview)
            }
        default:
            break
        }
    }
    
    @objc func didTapCancel() {
        dismiss(animated: true)
    }
    
    @objc func didTapDone() {
        LoadingIndicator.showLoading()
        
        guard let mergedImage = self.transfromToImage() else {
            print("Error: Failed to merge text to image")
            LoadingIndicator.hideLoading()
            return
        }
        view.endEditing(true)
        viewModel?.mergeImage
            .accept(mergedImage)
        
        viewModel?.caption
            .accept(self.captionTextView.text)
        
        viewModel?.uploadPost()
            .subscribe(onNext: { [weak self] in
                guard let self = self else { return }
                LoadingIndicator.hideLoading()
                
                self.dismiss(animated: true) {
                    if let autoSave = UserDefaults.standard.value(forKey: "AutoSave") as? Bool,
                       autoSave {
                        UIImageWriteToSavedPhotosAlbum(mergedImage, self, nil, nil)
                    }
                    self.delegate?.reload()
                }
            }, onError: { error in
                LoadingIndicator.hideLoading()
                // 에러 처리
                print("Error: \(error.localizedDescription)")
                
            })
            .disposed(by: disposeBag)
    }
    
    
    func transfromToImage() -> UIImage? {
        // photoImageView와 dateLabel을 포함할 UIView
        let combinedView = UIView(frame: CGRect(x: 0, y: 0,
                                                width: photoImageView.frame.width,
                                                height: photoImageView.frame.height))
        photoImageView.contentMode = .scaleAspectFill
        
        // photoImageView의 크기를 combinedView와 일치시킴
        photoImageView.frame = combinedView.bounds
        combinedView.addSubview(photoImageView)
        
        // dateLabel의 frame을 photoImageView 내의 좌표로 변환하여 추가
        let dateLabelInImageViewFrame = photoImageView.convert(dateLabel.frame,
                                                               from: dateLabel.superview)
        dateLabel.frame = dateLabelInImageViewFrame
        combinedView.addSubview(dateLabel)
        
        UIGraphicsBeginImageContextWithOptions(combinedView.bounds.size, true, 0.0)
        defer {
            UIGraphicsEndImageContext()
        }
        if let context = UIGraphicsGetCurrentContext() {
            combinedView.layer.render(in: context)
            return UIGraphicsGetImageFromCurrentImageContext()
        }
        return nil
    }

    
    @objc func keyboardWillShow(_ notification:NSNotification) {
        
        guard let userInfo = notification.userInfo,
              let keyboardFrame = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect else {
            return
        }
        
        scrollView.contentInset.bottom = keyboardFrame.size.height
        scrollView.scrollRectToVisible(captionTextView.frame, animated: true)
        
        
    }
    
    @objc func keyboardWillHide(_ notification:NSNotification) {
        let contentInset = UIEdgeInsets.zero
        scrollView.contentInset = contentInset
        scrollView.scrollIndicatorInsets = contentInset
    }
    
    @objc func handleTap(sender: UITapGestureRecognizer) {
        if sender.state == .ended {
            view.endEditing(true)
        }
        sender.cancelsTouchesInView = false
    }
    
    
    @objc func textColorChanged() {
        DispatchQueue.main.async {
            self.dateLabel.textColor = self.textColorWell.selectedColor
        }
    }
    
}





//MARK: - UITextViewDelegate
extension UploadContentViewController: UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
        
        let count = textView.text.count
        
        viewModel?.textMaxLength(textCnt: count, completion: {
            textView.deleteBackward()
        })
        
        charaterCountLabel.text = "\(count)/100"
        
        let size = CGSize(width: view.frame.width, height: .infinity)
        let estimatedSize = textView.sizeThatFits(size)
        
        textView.constraints.forEach { (constraint) in
            // 더 이상 줄어들지 않게하기
            if estimatedSize.height <= 64 {
            } else if estimatedSize.height >= 180 {
            } else {
                if constraint.firstAttribute == .height {
                    constraint.constant = estimatedSize.height
                }
                scrollView.scrollRectToVisible(captionTextView.frame, animated: true)
            }
        }
    }
}
