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
        tv.layer.borderWidth = 1
        tv.layer.borderColor = UIColor.lightGray.cgColor
        tv.layer.cornerRadius = 10
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
        configureUI()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.navigationBar.isHidden = true
    }
    
    private func configureUI() {
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
    
}
