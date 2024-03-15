//
//  PostDetailViewController.swift
//  DaliyTimeLine
//
//  Created by Chung Wussup on 2/9/24.
//

import UIKit
import SnapKit
import Kingfisher

class PostDetailViewController: UIViewController {
    
    private var viewModel: PostDetailViewModel
    weak var delegate: MainListViewControllerDelegate?
    
    
    private lazy var scrollView: UIScrollView = {
        let sv = UIScrollView()
        sv.delegate = self
        return sv
    }()
    
    
    lazy var postImageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFit
        iv.layer.cornerRadius = 10
        iv.layer.masksToBounds = true
        
        return iv
    }()
    
    lazy var dateLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.darkGray
        label.font = UIFont(name: "OTSBAggroB", size: 15)
        return label
    }()
    
    private lazy var captionTextView: InputTextView = {
        let tv = InputTextView()
        tv.backgroundColor = .white
        tv.font = UIFont(name: "OTSBAggroL", size: 16)
        tv.textColor = .black
        tv.isEditable = false
        tv.delegate = self
        return tv
    }()
    
    private let charaterCountLabel: UILabel = {
        let label = UILabel()
        label.textColor = .lightGray
        label.font = UIFont.systemFont(ofSize: 14)
        label.text = "0/100"
        return label
    }()
    
    init(viewModel: PostDetailViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleTap(sender:))))
        configureUI()
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.isHidden = false
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.navigationBar.isHidden = true
        NotificationCenter.default.removeObserver(self)
    }
    
    private func configureUI() {
        let deleteButton = UIBarButtonItem(image: UIImage(systemName: "trash"), style: .plain, target: self, action: #selector(deletePost))
        let sharedButton = UIBarButtonItem(image: UIImage(systemName: "square.and.arrow.up"), style: .plain, target: self, action: #selector(sharePost))
        let editButton = UIBarButtonItem(title: "수정", style: .plain, target: self, action: #selector(editPost))
        
        self.navigationItem.rightBarButtonItems = [deleteButton, sharedButton, editButton]
        self.navigationController?.navigationBar.tintColor = .black
        
        postImageView.kf.setImage(with: URL(string: viewModel.post.imageUrl))
        dateLabel.text = viewModel.post.timestamp.dateValue().dateToString()
        captionTextView.text = viewModel.post.caption
        
        self.view.addSubview(scrollView)
        scrollView.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide)
            $0.leading.trailing.bottom.equalToSuperview()
        }
        
        self.scrollView.addSubview(postImageView)
        postImageView.snp.makeConstraints {
            $0.top.equalTo(scrollView.snp.top).offset(10)
            $0.leading.equalToSuperview().offset(16)
            $0.trailing.equalToSuperview().offset(-16)
            $0.width.height.equalTo(UIScreen.main.bounds.size.width - 32)
            $0.centerX.equalTo(scrollView.snp.centerX)
        }
        
        self.scrollView.addSubview(dateLabel)
        dateLabel.snp.makeConstraints {
            $0.top.equalTo(postImageView.snp.bottom).offset(10)
            $0.leading.equalTo(postImageView.snp.leading).offset(16)
            $0.trailing.equalTo(postImageView.snp.trailing).offset(-16)
//            $0.bottom.equalTo(postImageView.snp.bottom).offset(-16)
        }
        
        self.scrollView.addSubview(captionTextView)
        captionTextView.backgroundColor = .red
        captionTextView.snp.makeConstraints {
            $0.top.equalTo(dateLabel.snp.bottom).offset(10)
            $0.leading.equalTo(self.scrollView.snp.leading).offset(10)
            $0.trailing.equalTo(self.scrollView.snp.trailing).inset(10)
        }
        
        scrollView.addSubview(charaterCountLabel)
        charaterCountLabel.snp.makeConstraints { make in
            make.top.equalTo(captionTextView.snp.bottom)
            make.trailing.equalToSuperview().offset(-12)
            make.bottom.lessThanOrEqualToSuperview()
        }
                
//        captionTextView.translatesAutoresizingMaskIntoConstraints = true
        captionTextView.sizeToFit()
        captionTextView.isScrollEnabled = false
        
        charaterCountLabel.text = "\(captionTextView.text.count)/100"
    }
    
    @objc func deletePost() {
        
        let sheet = UIAlertController(title: "삭제하시겠습니까??", message: nil, preferredStyle: .alert)
        sheet.addAction(UIAlertAction(title: "삭제", style: .destructive, handler: {[weak self] _ in
            guard let self = self else { return }
            
            self.viewModel.deletePost(documentID: self.viewModel.post.documentId) {
                self.delegate?.reload()
                self.navigationController?.popViewController(animated: true)
            }
        }))
        
        sheet.addAction(UIAlertAction(title: "아니요", style: .cancel, handler: { _ in }))
        
        present(sheet, animated: true)
    }
    
    @objc func editPost() {
        let doneButton = UIBarButtonItem(title: "완료", style: .plain, target: self, action: #selector(editDone))
        self.navigationItem.rightBarButtonItems = [doneButton]
        
        if captionTextView.text.isEmpty {
            captionTextView.placeholderText = "내용을 입력해 주세요"
        } else {
            captionTextView.text = self.viewModel.post.caption
        }
        
        self.captionTextView.isEditable = true
    }
    
    @objc func editDone() {
        let deleteButton = UIBarButtonItem(image: UIImage(systemName: "trash"), style: .plain, target: self, action: #selector(deletePost))
        let sharedButton = UIBarButtonItem(image: UIImage(systemName: "square.and.arrow.up"), style: .plain, target: self, action: #selector(sharePost))
        let editButton = UIBarButtonItem(title: "수정", style: .plain, target: self, action: #selector(editPost))
        
        self.navigationItem.rightBarButtonItems = [deleteButton, sharedButton, editButton]
    }
    
    @objc func sharePost() {
        guard let image = postImageView.image else { return }
    
        let ac = UIActivityViewController(activityItems: [image], applicationActivities: nil)
        ac.popoverPresentationController?.sourceView = self.view
        ac.excludedActivityTypes = [.assignToContact, .copyToPasteboard]
        present(ac, animated: true)
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
    
    func checkMaxLength(_ textView: UITextView) {
        if (textView.text.count) > 100 {
            textView.deleteBackward()
        }
    }
    
    
}

//MARK: - UITextViewDelegate
extension PostDetailViewController: UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
        checkMaxLength(textView)
        let count = textView.text.count
        charaterCountLabel.text = "\(count)/100"
        
//        let size = CGSize(width: view.frame.width, height: .infinity)
//        let estimatedSize = textView.sizeThatFits(size)
//        
//        textView.constraints.forEach { (constraint) in
//            // 더 이상 줄어들지 않게하기
//            if estimatedSize.height <= 64 {
//            } else if estimatedSize.height >= 180 {
//            } else {
//                if constraint.firstAttribute == .height {
//                    constraint.constant = estimatedSize.height
//                }
//                scrollView.scrollRectToVisible(captionTextView.frame, animated: true)
//            }
//        }
    }
}

extension PostDetailViewController: UIScrollViewDelegate {
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        self.view.endEditing(true)
    }
}
