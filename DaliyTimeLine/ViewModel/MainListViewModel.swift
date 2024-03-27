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

protocol MainListViewModelType {
    //input
    
    //output
    //전체 포스트
    
    
}

enum PostSection: CaseIterable {
    case dailyPost
}

class MainListViewModel {
    
    var posts = [Post]()
    var mainPosts = [Post]()
    var service: PostService
    var selectedDate: Date = Date()
    var preSelectedDate: Date?
    var disposeBag = DisposeBag()

    var isPostsEmpty: Bool {
        get {
            return posts.count > 0 ? true : false
        }
    }
    
    
    init(service: PostService) {
        self.service = service
        getAllPost()
    }

    
    func getPost(date: Date, completion: @escaping () -> Void) {
        service.getPost(date: date) { posts in
            self.selectedDate = date
            self.posts = posts
            
            completion()
        }
    }

    
    func getAllPost() {
        self.service.getAllPosts { posts in
            self.mainPosts = self.filterFirstPostForUniqueTimestamps(posts: posts)
        }
    }
    
    
    func getPostData(_ index: Int) -> Post {
        return self.posts[index]
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
    
    
    func getDatePost(date: Date, compltion: @escaping(URL?)->Void) {
        var imageUrl = ""
        
        self.service.getAllPosts { posts in
            self.filterFirstPostForUniqueTimestamps(posts: posts).forEach { post in
                let postDateComponents = self.dateComponets(date: post.timestamp.dateValue())
                let dateComponents = self.dateComponets(date: date)
                
                if dateComponents == postDateComponents {
                    imageUrl = post.imageUrl
                    compltion(URL(string: imageUrl))
                }
            }
        }
    }
    
    func isCurrentSelected(_ date: Date) -> Bool {
        let selectDateComponent = self.dateComponets(date: self.selectedDate)
        let nowDateComponent = self.dateComponets(date: date)
        
        return selectDateComponent == nowDateComponent ? true : false
    }
    
    
    func updateSelectedDate(_ date: Date) {
        self.preSelectedDate = self.selectedDate
        selectedDate = date
    }
    
}
