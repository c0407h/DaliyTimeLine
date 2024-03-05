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

protocol MainListViewControllerDelegate: AnyObject {
    func reload()
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
        label.text = String(dateFormatter().string(from: Date()))
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
        cv.dataSource = self
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
    
    var viewModel = MainListViewModel(service: PostService())
    private var dataSource: UICollectionViewDiffableDataSource<PostSection, Int>!
    weak var delegate: MainListViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        self.configureCV()
        
        viewModel.getPost(date: Date()) {
            self.cvReload()
        }
    }

    
    
    private func configureUI() {
        self.delegate = self
        self.view.addSubview(calendarView)
        
        calendarView.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide)
            $0.leading.trailing.equalTo(view)
            $0.height.equalTo(300)
        }
        
//        self.calendarView.addSubview(calendarSettingButton)
//        calendarSettingButton.snp.makeConstraints {
//            $0.trailing.equalTo(calendarView.snp.trailing).offset(-10)
//            $0.top.equalTo(calendarView.snp.top).offset(10)
//        }
        
        
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
        viewModel.getPost(date: Date()) {
            self.calendarView.select(Date())
            self.cvReload()
        }
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
    
    func dateFormatter() -> DateFormatter {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "ko_KR")
        dateFormatter.timeZone = TimeZone(abbreviation: "KST")
        dateFormatter.dateFormat = "yyyy-MM-dd"
        return dateFormatter
    }
    
    //오늘날짜까지만 선택
    func maximumDate(for calendar: FSCalendar) -> Date {
        return Date()
    }
    
    func calendar(_ calendar: FSCalendar, cellFor date: Date, at position: FSCalendarMonthPosition) -> FSCalendarCell {
        guard let cell = calendar.dequeueReusableCell(withIdentifier: CalendarCell.description(), for: date, at: position) as? CalendarCell else { return FSCalendarCell() }
        
        viewModel.getDatePost(date: date) { url in
            if let imageUrl = url {
                cell.backImageView.kf.setImage(with: imageUrl)
            }
        }
        
        // 현재 선택되어 있는 날짜인지 확인 후 배경 이미지의 alpha값을 조절한다
        cell.backImageView.alpha = viewModel.isCurrentSelected(date) ? 1 : 0.5
        
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
        
        let chgDate = dateFormatter().string(from: date)
        if let date = dateFormatter().date(from: chgDate) {
            viewModel.getPost(date: date) {
                self.dateLabel.text = self.dateFormatter().string(from: date)
                self.cvReload()
            }
        }
        
        // 기존에 선택했던 날짜의 셀 배경의 alpha값을 다시 0.5로 바꿔주고,
        // 새롭게 선택한 날짜의 셀 배경의 alpha값을 1로 바꿔준다
        if let previous = viewModel.preSelectedDate {
            if let preCell = calendar.cell(for: previous, at: monthPosition) as? CalendarCell  {
                preCell.backImageView.alpha = 0.5
            }
        }
        
        if let currentCell = calendar.cell(for: viewModel.selectedDate, at: monthPosition) as? CalendarCell {
            currentCell.backImageView.alpha = 1
        }
    }
    
    //날자를 string으로 변환
    //    func calendar(_ calendar: FSCalendar, titleFor date: Date) -> String? {
    //        switch dateFormatter().string(from: date) {
    //        case dateFormatter().string(from: Date()):
    //            return "오늘"
    //        default:
    //            return nil
    //        }
    //    }
    
    //날자 하단 subtitle string으로 변환
    func calendar(_ calendar: FSCalendar, subtitleFor date: Date) -> String? {
        switch dateFormatter().string(from: date) {
        case dateFormatter().string(from: Date()):
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


extension MainListViewController: UICollectionViewDataSource, UICollectionViewDelegate{
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if !self.viewModel.posts.isEmpty {
            return self.viewModel.posts.count
        } else {
            return 1
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "FeedCollectionViewCell", for: indexPath) as? FeedCollectionViewCell {
            
            if self.viewModel.posts.count == 0 {
                cell.cofigureTitle()
            } else {
                let post = self.viewModel.getPostData(indexPath.row)
                cell.configureUI(post: post)
            }
            return cell
        }
        return UICollectionViewCell()
    }
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {

        if self.viewModel.isPostsEmpty{
            let viewModel = PostDetailViewModel(post: viewModel.posts[indexPath.row])
            let detailVC = PostDetailViewController(viewModel: viewModel)
            detailVC.delegate = self
            self.navigationController?.navigationBar.isHidden = false
            self.navigationController?.pushViewController(detailVC, animated: true)
        }
        
    }
    
    func configureCV() {
        let itemSize: CGFloat = viewModel.posts.count > 0 ? 1/3 : 1
        let groupItemCnt = viewModel.posts.count > 0 ? 3 : 1
        
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
        
        viewModel.getPost(date: Date()) {
            self.calendarView.select(Date())
            self.calendarView.reloadData()
            self.cvReload()
        }
    }
}
