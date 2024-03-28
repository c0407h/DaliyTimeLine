//
//  MainListViewController.swift
//  DaliyTimeLine
//
//  Created by Chung Wussup on 1/19/24.
//

import UIKit
import Firebase
import SnapKit
import FSCalendar
import RxSwift
import RxCocoa
import RxDataSources


protocol MainListViewControllerDelegate: AnyObject {
    func reload()
    func postUpdate(documentID: String, caption: String)
}

class MainListViewController: UIViewController {
    lazy var calendarView: FSCalendar = {
        let calendar = FSCalendar()
        
        calendar.delegate = self
        calendar.dataSource = self
        
        calendar.clipsToBounds = false
        calendar.contentView.clipsToBounds = false
        calendar.collectionView.clipsToBounds = false
        
        calendar.scope = .month
        calendar.locale = Locale(identifier: "ko_KR")
        calendar.scrollDirection = .horizontal
        calendar.firstWeekday = 1
        calendar.select(Date())
        calendar.placeholderType = .none

        calendar.appearance.weekdayTextColor = .black
        
        calendar.appearance.headerMinimumDissolvedAlpha = 0.0
        calendar.appearance.headerDateFormat = "yyyy년 MM월"
        calendar.appearance.headerTitleColor = UIColor.darkGray
        calendar.appearance.headerTitleOffset = .init(x: -75, y: 0)
        calendar.appearance.headerTitleFont = UIFont(name: "OTSBAggroB", size: 20)
        calendar.appearance.headerTitleAlignment = .left
        
        
        calendar.appearance.weekdayFont = UIFont(name: "OTSBAggroM", size: 14)
        calendar.appearance.weekdayTextColor = UIColor.darkGray
        
        calendar.appearance.titleSelectionColor = .red
        calendar.appearance.titleFont = UIFont(name: "OTSBAggroL", size: 14)
        
        
        
        calendar.appearance.subtitleOffset = CGPoint(x: 0, y: 20)
        calendar.appearance.subtitleSelectionColor = .black
        calendar.appearance.subtitleTodayColor = .black
        calendar.appearance.subtitleFont = UIFont(name: "OTSBAggroM", size: 10)
        
        calendar.headerHeight = 45
        
        calendar.appearance.todayColor = .clear
        calendar.appearance.selectionColor = .clear

        calendar.calendarWeekdayView.weekdayLabels.last!.textColor = .blue
        calendar.calendarWeekdayView.weekdayLabels.first!.textColor = .red
        
        calendar.register(CalendarCell.self, forCellReuseIdentifier: CalendarCell.description())
        calendar.allowsMultipleSelection = false
        return calendar
    }()
    
    var logoutButton: UIButton = {
        let button = UIButton()
        button.setTitle("로그아웃", for: .normal)
        return button
    }()
    
    lazy var dateLabel: UILabel = {
        let label = UILabel()
        label.text = Date().dateToString()
        label.textColor = UIColor.darkGray
        label.font = UIFont(name: "OTSBAggroB", size: 15)
        return label
    }()
    
    lazy var postCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 5
        layout.scrollDirection = .vertical
        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.showsVerticalScrollIndicator = false
        cv.delegate = self
        return cv
    }()
    
    lazy var calendarSettingButton: UIButton = {
       let button = UIButton()
        button.setTitle("주/월", for: .normal)
        button.titleLabel?.font = UIFont(name: "OTSBAggroL", size: 14)
        button.setTitleColor(UIColor.darkGray, for: .normal)
        button.addTarget(self, action: #selector(calendarSettingTapped), for: .touchUpInside)
        return button
    }()
    
    private var dataSource: UICollectionViewDiffableDataSource<PostSection, Int>!
    var viewModel = MainListViewModel(service: PostService())
    weak var delegate: MainListViewControllerDelegate?
    let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.configureUI()
        
        
        self.viewModel.dailyPost
            .subscribe {[weak self] _ in
                self?.cvReload()
            }
            .disposed(by: disposeBag)
        
        self.viewModel.dailyPost
                   .bind(to: postCollectionView.rx.items(cellIdentifier: "FeedCollectionViewCell", cellType: FeedCollectionViewCell.self)) { index, post, cell in
                       cell.configureUI(post: post)
                   }
                   .disposed(by: disposeBag)
        
        self.postCollectionView.rx.modelSelected(Post.self)
                .subscribe(onNext: { [weak self] post in
                    guard let self = self else { return }
                    let viewModel = PostDetailViewModel(post: post)
                    let detailVC = PostDetailViewController(viewModel: viewModel)
                    detailVC.delegate = self
                    self.navigationController?.pushViewController(detailVC, animated: true)
                })
                .disposed(by: disposeBag)

        self.viewModel.rxGetPost(date: Date())
            
    }
    
    
    private func configureUI() {
        self.delegate = self
        
        self.view.addSubview(calendarView)
        calendarView.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide)
            $0.leading.trailing.equalTo(view)
            $0.height.equalTo(300)
        }
        
        self.view.addSubview(dateLabel)
        dateLabel.snp.makeConstraints {
            $0.top.equalTo(calendarView.snp.bottom)
            $0.trailing.equalTo(view)
            $0.leading.equalTo(16)
        }
        
        self.view.addSubview(postCollectionView)
        postCollectionView.snp.makeConstraints {
            $0.top.equalTo(dateLabel.snp.bottom)
            $0.bottom.trailing.leading.equalTo(view)
        }
        
        postCollectionView.register(FeedCollectionViewCell.self, forCellWithReuseIdentifier: "FeedCollectionViewCell")
    }
    
    func updateReload() {
        self.calendarView.select(Date())
        viewModel.rxGetPost(date: Date())
    }
    
    func cvReload() {        
        DispatchQueue.main.async {
            self.configureCV()
            self.postCollectionView.reloadData()
        }
    }
    
    
    @objc private func calendarSettingTapped() {
        if self.calendarView.scope == .week {
            self.calendarView.scope = .month
        } else {
            self.calendarView.scope = .week
        }
    }
}

extension MainListViewController: FSCalendarDelegate, FSCalendarDataSource, FSCalendarDelegateAppearance {
    
    //오늘날짜까지만 선택
    func maximumDate(for calendar: FSCalendar) -> Date {
        return Date()
    }
    
    func calendar(_ calendar: FSCalendar, cellFor date: Date, at position: FSCalendarMonthPosition) -> FSCalendarCell {
        guard let cell = calendar.dequeueReusableCell(withIdentifier: CalendarCell.description(), for: date, at: position) as? CalendarCell else { return FSCalendarCell() }

        
        self.viewModel.rxGetPostImg(date: date)
            .subscribe { url in
                cell.backImageView.kf.setImage(with: url)
            }
            .disposed(by: disposeBag)
        
        // 현재 선택되어 있는 날짜인지 확인 후 배경 이미지의 alpha값을 조절한다
        self.viewModel.isCurrentSelected(date)
            .subscribe { bool in
                cell.backImageView.alpha = bool ? 1 : 0.5
            }
            .disposed(by: disposeBag)
        
        return cell
    }
    
    
    func calendar(_ calendar: FSCalendar, boundingRectWillChange bounds: CGRect, animated: Bool) {
        calendar.snp.updateConstraints { (make) in
            if calendar.scope == .week {
                make.height.equalTo(120)
            } else {
                make.height.equalTo(bounds.height)
            }
        }
        
        UIView.animate(withDuration: 0.5) {
            self.view.layoutIfNeeded()
        }

    }
    
    // 날짜 선택 시 콜백 메소드
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        viewModel.updateSelectedDate(date)
        
        self.dateLabel.text = date.dateToString()
        self.viewModel.rxGetPost(date: date)

        
        // 기존에 선택했던 날짜의 셀 배경의 alpha값을 다시 0.5로 바꿔주고,
        // 새롭게 선택한 날짜의 셀 배경의 alpha값을 1로 바꿔준다
//        if let previous = viewModel.preSelectedDate {
//            if let preCell = calendar.cell(for: previous, at: monthPosition) as? CalendarCell  {
//                preCell.backImageView.alpha = 0.5
//            }
//        }
//        
//        if let currentCell = calendar.cell(for: viewModel.selectedDate, at: monthPosition) as? CalendarCell {
//            currentCell.backImageView.alpha = 1
//        }
    }

    
    //날자 하단 subtitle string으로 변환
    func calendar(_ calendar: FSCalendar, subtitleFor date: Date) -> String? {
        switch date.dateToString() {
        case Date().dateToString():
            return "오늘"
        default:
            return nil
        }
    }
    
    
    // 일요일에 해당되는 모든 날짜의 색상 red로 변경
    func calendar(_ calendar: FSCalendar, appearance: FSCalendarAppearance, titleDefaultColorFor date: Date) -> UIColor? {
        let day = Calendar.current.component(.weekday, from: date) - 1
        if Calendar.current.shortWeekdaySymbols[day] == "일" {
            return .red
        } else if Calendar.current.shortWeekdaySymbols[day] == "토" {
            return .blue
        } else {
            return .label
        }
    }
    
}


extension MainListViewController:  UICollectionViewDelegate{
    func configureCV() {
        let itemSize: CGFloat = 1/3
        let groupItemCnt = 3
        
        let size = NSCollectionLayoutSize(widthDimension: .fractionalWidth(itemSize), heightDimension: .fractionalWidth(itemSize))
        let item = NSCollectionLayoutItem(layoutSize: size)
        item.contentInsets = .init(top: 5, leading: 5, bottom: 5, trailing: 5)
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalWidth(itemSize))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitem: item, count: groupItemCnt)
        
        let section = NSCollectionLayoutSection(group: group)
        let layout = UICollectionViewCompositionalLayout(section: section)
        
        postCollectionView.collectionViewLayout = layout
    }
}

extension MainListViewController: MainListViewControllerDelegate {
    func reload() {
        viewModel.rxGetPost(date: Date())
        self.calendarView.select(Date())
        self.calendarView.reloadData()
    }
    
    func postUpdate(documentID: String, caption: String) {
//        if let updateIndex = viewModel.posts.firstIndex(where: { $0.documentId == documentID }) {
//            viewModel.posts[updateIndex].caption = caption
//        }
//        viewModel.postUpdate(documentID: documentID, caption: caption)
        viewModel.dailyPost
            .subscribe(onNext: { [weak self] posts in
            print("update", posts)
              if let updateIndex = posts.firstIndex(where: { $0.documentId == documentID }) {
                  var updatedPosts = posts
                  updatedPosts[updateIndex].caption = caption
                  self?.viewModel.dailyPost.onNext(updatedPosts)
              }
            print("updatepost")
            }, onDisposed: {
                print("ondisposed")
            }).disposed(by: disposeBag)
        
    }
}


