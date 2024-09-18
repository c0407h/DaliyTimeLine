//
//  MainListModulesProtocols.swift
//  DaliyTimeLine
//
//  Created by Chung Wussup on 9/17/24.
//

import Foundation
import RxSwift

protocol MainListRouterProtocol {
    
}

protocol MainListViewProtocol: AnyObject {
    
}

protocol MainListPresenterProtocol: AnyObject {
    var mainPost: PublishSubject<[Post]> { get set }
    var dailyPost: PublishSubject<[Post]> { get set }
    var imageURL: PublishSubject<URL> { get set }
    var selectedDateSubject: BehaviorSubject<Date> { get set }
    var currentSelectedDateSubject: BehaviorSubject<Bool> { get set }
    var postUpdateSubject: PublishSubject<Bool> { get set }
    
    
    func viewDidLoad()
    func didSelectDate(_ date: Date)
    func getAllPost()
    func getPostImg(date: Date)
    func getCurrentDateCheck(date: Date)
}

protocol MainListInteractorProtocol {
    func getAllPost()
    func getPost(date: Date)
    func getPostImage(date: Date)
    func isCurrentSelected(_ date: Date)
}

