//
//  MainListViewModel.swift
//  DaliyTimeLine
//
//  Created by Chung Wussup on 2/5/24.
//

import Foundation
import Firebase
import RxSwift
import RxRelay
import Differentiator


struct MySection {
    var items: [Post]

    init(items: [Post]) {
        self.items = items
    }
}

extension MySection: SectionModelType {
    
    typealias Item = Post
    
    init(original: MySection, items: [Post]) {
        self = original
        self.items = items
    }
    
    
}



protocol MainListViewModelType {
    //input
    
    //output
    //전체 포스트
    
    
}

enum PostSection: CaseIterable {
    case dailyPost
}

class MainListViewModel {
    var mainPost = PublishSubject<[Post]>()
    var dailyPost = PublishSubject<[Post]>()
    var dailyPostCount = PublishSubject<Int>()
    
    var service: PostService
    var disposeBag = DisposeBag()

    
    
    func rxGetAllPost() {
        service.getAllPosts { posts in
            self.mainPost.onNext(posts)
        }
    }
    
    func rxGetPost(date: Date) {
        self.updateSelectedDate(date)
        service.getPost(date: date) { post in
            self.dailyPost.onNext(post)
            self.dailyPostCount.onNext(post.count)
            
        }
    }
    
    func postUpdate(documentID: String, caption: String) {
        
        dailyPost.subscribe(onNext: { [weak self] posts in
              if let updateIndex = posts.firstIndex(where: { $0.documentId == documentID }) {
                  var updatedPosts = posts
                  updatedPosts[updateIndex].caption = caption
                  self?.dailyPost.onNext(updatedPosts)
              }
            print("updatepost")
          }).disposed(by: disposeBag)
    }
    
    func rxGetPostImg(date: Date) -> Observable<URL?> {
        return service.rxGetAllPosts()
            .map { posts in
                let filteredPosts = self.filterFirstPostForUniqueTimestamps(posts: posts)
                let post = filteredPosts.first { post in
                    let postDateComponents = self.dateComponets(date: post.timestamp.dateValue())
                    let dateComponents = self.dateComponets(date: date)
                    return dateComponents == postDateComponents
                }
                
                return URL(string: post?.imageUrl ?? "")
            }
    }
    
    init(service: PostService) {
        self.service = service
        rxGetAllPost()
        
    }

    
    func filterFirstPostForUniqueTimestamps(posts: [Post]) -> [Post] {
        // timestamp를 기준으로 중복 제거
        let uniqueTimestamps = Set(posts.map { $0.timestamp })
        
        var filteredPosts: [Post] = []
        
        // 중복 제거된 timestamp에 대해 첫 번째 Post를 찾아서 추가
        for timestamp in uniqueTimestamps {
            if let firstPost = posts.first(where: { $0.timestamp == timestamp }) {
                filteredPosts.append(firstPost)
            }
        }
        
        return filteredPosts
    }
    
    //년월일로 바꿔주는 메서드
    func dateComponets(date: Date) -> DateComponents {
        let calendar = Calendar.current
        let dateComponents = calendar.dateComponents([.year, .month, .day], from: date)
        
        return dateComponents
    }
    
    
    let selectedDateSubject = BehaviorSubject<Date>(value: Date())

    // 선택된 날짜를 업데이트하는 메서드를 추가합니다.
    func updateSelectedDate(_ date: Date) {
        selectedDateSubject.onNext(date)
    }

    // 선택된 날짜를 확인하는 메서드를 추가합니다.
    func isCurrentSelected(_ date: Date) -> Observable<Bool> {
        return selectedDateSubject.map { selectedDate in
            let selectDateComponent = self.dateComponets(date: selectedDate)
            let nowDateComponent = self.dateComponets(date: date)
            return selectDateComponent == nowDateComponent
        }
    }
    
}
