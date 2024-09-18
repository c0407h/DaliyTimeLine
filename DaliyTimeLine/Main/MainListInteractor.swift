//
//  MainListInteractor.swift
//  DaliyTimeLine
//
//  Created by Chung Wussup on 9/17/24.
//

import Foundation
import RxSwift

class MainListInteractor: MainListInteractorProtocol {
    var presenter: MainListPresenterProtocol?
    var service: PostService
    var disposeBag = DisposeBag()
    
    init(service: PostService) {
        self.service = service
    }
    
    func getAllPost() {
        service.rxGetAllPosts()
            .subscribe { [weak self] posts in
                self?.presenter?.mainPost.onNext(posts)
            }
            .disposed(by: disposeBag)

    }
    
    func getPost(date: Date) {
        service.rxGetPost(date: date)
            .subscribe {[weak self] post in
                if let posts = post.element {
                    self?.presenter?.dailyPost.onNext(posts)
                }
            }
            .disposed(by: disposeBag)
    }
    
    func getPostImage(date: Date) {
        service.rxGetAllPosts()
            .map { [weak self] posts in
                let filteredPosts = self?.filterFirstPostForUniqueTimestamps(posts: posts)
                let post = filteredPosts?.first { post in
                    let postDateComponents = self?.dateComponets(date: post.timestamp.dateValue())
                    let dateComponents = self?.dateComponets(date: date)
                    return dateComponents == postDateComponents
                }
                
                let url = URL(string: post?.imageUrl ?? "")
                
                presenter?.imageURL.onNext(url)
            }
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
    
    func dateComponets(date: Date) -> DateComponents {
        let calendar = Calendar.current
        let dateComponents = calendar.dateComponents([.year, .month, .day], from: date)
        
        return dateComponents
    }
    
    func updateSelectedDate(date: Date) {
        self.presenter?.selectedDateSubject.onNext(date)
    }
    
    func isCurrentSelected(_ date: Date) {
        self.presenter?.selectedDateSubject
            .map {[weak self] selectedDate in
                let selectDateComponent = self?.dateComponets(date: selectedDate)
                let nowDateComponent = self?.dateComponets(date: date)
                return selectDateComponent == nowDateComponent
            }
            .subscribe(onNext: { [weak self] isSelected in
                self?.presenter?.currentSelectedDateSubject.onNext(isSelected)
            })
            .disposed(by: disposeBag)
    }
    
//
//    func fetchAllPosts() {
//        service.getAllPosts { [weak self] posts in
//            self?.presenter?.didFetchPosts(posts)
//        }
//    }
//    
//    func fetchPosts(for date: Date) {
//        service.getPost(date: date) { [weak self] posts in
//            self?.presenter?.didFetchPosts(posts)
//        }
//    }
//    
//    func updatePost(documentID: String, caption: String) {
//        // Update logic
//        service.updatePost(documentID: documentID, caption: caption)
//            .subscribe { [weak self] success in
//                if success {
//                    self?.fetchPosts(for: Date())
//                }
//            }
//            .disposed(by: DisposeBag())
//    }
    
    
    
    
    //    func getAllPost() {
    //        service.getAllPosts { [weak self] posts in
    //            self?.mainPostSubject.onNext(posts)
    //        }
    //    }
    //
    //    func getPost(date: Date) {
    //        service.rxGetPost(date: date)
    //            .subscribe(onNext: { [weak self] posts in
    //                self?.dailyPostSubject.onNext(posts)
    //            })
    //            .disposed(by: disposeBag)
    //    }
    //
    //    func getPostImage(for date: Date) -> Observable<URL> {
    //        return service.rxGetAllPosts()
    //            .map { [weak self] posts in
    //                let filteredPosts = self?.filterFirstPostForUniqueTimestamps(posts: posts)
    //                let post = filteredPosts?.first { post in
    //                    let postDateComponents = self?.dateComponents(from: post.timestamp.dateValue())
    //                    let dateComponents = self?.dateComponents(from: date)
    //                    return dateComponents == postDateComponents
    //                }
    //                return URL(string: post?.imageUrl ?? "")
    //            }
    //    }
    //
    //    private func filterFirstPostForUniqueTimestamps(posts: [Post]) -> [Post] {
    //        // timestamp를 기준으로 중복 제거
    //        let uniqueTimestamps = Set(posts.map { $0.timestamp })
    //        var filteredPosts: [Post] = []
    //
    //        for timestamp in uniqueTimestamps {
    //            if let firstPost = posts.first(where: { $0.timestamp == timestamp }) {
    //                filteredPosts.append(firstPost)
    //            }
    //        }
    //        return filteredPosts
    //    }
    //
    //    func dateComponents(from date: Date) -> DateComponents {
    //        let calendar = Calendar.current
    //        return calendar.dateComponents([.year, .month, .day], from: date)
    //    }
    //
    //
}
