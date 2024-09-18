//
//  MainListPresenter.swift
//  DaliyTimeLine
//
//  Created by Chung Wussup on 9/17/24.
//

import Foundation
import RxSwift

class MainListPresenter: MainListPresenterProtocol {
    weak var view: MainListViewProtocol?
    var interactor: MainListInteractorProtocol?
    var router: MainListRouterProtocol?
    
    var mainPost = PublishSubject<[Post]>()
    var dailyPost = PublishSubject<[Post]>()
    var imageURL = PublishSubject<URL>()
    var selectedDateSubject = BehaviorSubject<Date>(value: Date())
    var currentSelectedDateSubject = BehaviorSubject<Bool>(value: true)
    var postUpdateSubject = PublishSubject<Bool>()
    
    func viewDidLoad() {
        interactor?.getAllPost()
    }
    
    func didSelectDate(_ date: Date) {
        interactor?.getPost(date: date)
    }
    
    func getAllPost() {
        interactor?.getAllPost()
    }
    
    func getPostImg(date: Date) {
        interactor?.getPostImage(date: date)
    }
    
    func getCurrentDateCheck(date: Date) {
        interactor?.isCurrentSelected(date)
    }
    

}
