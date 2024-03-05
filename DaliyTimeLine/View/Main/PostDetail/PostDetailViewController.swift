//
//  PostDetailViewController.swift
//  DaliyTimeLine
//
//  Created by Chung Wussup on 2/9/24.
//

import UIKit
import SnapKit
import Kingfisher
import LinkPresentation

class PostDetailViewController: UIViewController {
    
    private var viewModel: PostDetailViewModel
    weak var delegate: MainListViewControllerDelegate?
    
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
    
    private lazy var captionTextView: UITextView = {
        let tv = InputTextView()
        tv.backgroundColor = .white
        tv.font = UIFont(name: "OTSBAggroL", size: 16)
        tv.textColor = .black
        tv.isEditable = false
        return tv
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
        self.navigationController?.navigationBar.backgroundColor = .white
        configureUI()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.navigationBar.isHidden = true
    }
    
    private func configureUI() {
        let firstButton = UIBarButtonItem(image: UIImage(systemName: "trash"), style: .plain, target: self, action: #selector(deletePost))
        let secondButton = UIBarButtonItem(image: UIImage(systemName: "square.and.arrow.up.fill"), style: .plain, target: self, action: #selector(sharePost))
        self.navigationItem.rightBarButtonItems = [firstButton, secondButton]
        
        self.navigationController?.navigationBar.tintColor = .black
        
        postImageView.kf.setImage(with: URL(string:viewModel.post.imageUrl))
        dateLabel.text = String(dateFormatter().string(from: viewModel.post.timestamp.dateValue()))
        captionTextView.text = viewModel.post.caption
        
        self.view.addSubview(postImageView)
        postImageView.snp.makeConstraints {
            $0.top.equalTo(self.view.safeAreaLayoutGuide).offset(10)
            $0.leading.equalTo(self.view).offset(10)
            $0.trailing.equalTo(self.view).inset(10)
            $0.height.equalTo(postImageView.snp.width)
        }
        
        self.view.addSubview(dateLabel)
        dateLabel.snp.makeConstraints {
            $0.top.equalTo(postImageView.snp.bottom).offset(10)
            $0.trailing.equalTo(view)
            $0.leading.equalTo(16)
        }
        
        self.view.addSubview(captionTextView)
        captionTextView.snp.makeConstraints {
            $0.top.equalTo(dateLabel.snp.bottom).offset(10)
            $0.leading.equalTo(self.view).offset(10)
            $0.trailing.equalTo(self.view).inset(10)
            $0.bottom.equalTo(self.view.safeAreaLayoutGuide)
        }
        
    }
    
    func dateFormatter() -> DateFormatter {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "ko_KR")
        dateFormatter.timeZone = TimeZone(abbreviation: "KST")
        dateFormatter.dateFormat = "yyyy-MM-dd"
        return dateFormatter
    }
    
    func convertTimestamp(serverTimestamp: Double) -> String {
        let x = serverTimestamp / 1000
        let date = NSDate(timeIntervalSince1970: x)
        let formatter = DateFormatter()
        formatter.dateStyle = .long
        formatter.timeStyle = .medium
        
        return formatter.string(from: date as Date)
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
    
    var metadata: LPLinkMetadata?
        
    
    @objc func sharePost() {
//        var objectsToShare = [UIImage, String]()
//        if let image = postImageView.image {
//            objectsToShare.append(image)
//            print("[INFO] textField's Text : ", text)
//        }
//        
//        let activityVC = UIActivityViewController(activityItems: objectsToShare, applicationActivities: nil)
//        activityVC.popoverPresentationController?.sourceView = self.view
//        
//        // 공유하기 기능 중 제외할 기능이 있을 때 사용
//        //        activityVC.excludedActivityTypes = [UIActivityType.airDrop, UIActivityType.addToReadingList]
//        self.present(activityVC, animated: true, completion: nil)
        
//        let url = URL(string: viewModel.post.imageUrl)!
//            LPMetadataProvider().startFetchingMetadata(for: url) { linkMetadata, _ in
//                linkMetadata?.iconProvider = linkMetadata?.imageProvider
//                self.metadata = linkMetadata
//                let activityVc = UIActivityViewController(activityItems: [self.metadata], applicationActivities: nil)
//                DispatchQueue.main.async {
//                    self.present(activityVc, animated: true)
//                }
//            }
////        
        guard let text: String = captionTextView.text else { return }
        guard let image: UIImage = postImageView.image else { return }
        let shareAll: [Any] = [image]
        let activityViewController = UIActivityViewController(activityItems: shareAll, applicationActivities: nil)
        
        activityViewController.popoverPresentationController?.sourceView = self.view
        self.present(activityViewController, animated: true, completion: nil)
    }
    
    
}
extension PostDetailViewController: UIActivityItemSource {
    func activityViewControllerPlaceholderItem(_ activityViewController: UIActivityViewController) -> Any {
        return "captionTextView.text"
    }

    func activityViewController(_ activityViewController: UIActivityViewController, itemForActivityType activityType: UIActivity.ActivityType?) -> Any? {
        return postImageView.image
    }
    func activityViewController(_ activityViewController: UIActivityViewController, thumbnailImageForActivityType activityType: UIActivity.ActivityType?, suggestedSize size: CGSize) -> UIImage? {
        return postImageView.image
    }

    func activityViewControllerLinkMetadata(_ activityViewController: UIActivityViewController) -> LPLinkMetadata? {
        let image = postImageView.image!
        let imageProvider = NSItemProvider(object: image)
        let metadata = LPLinkMetadata()
        metadata.imageProvider = imageProvider
        return metadata
    }
}
