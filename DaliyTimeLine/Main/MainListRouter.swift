//
//  MainListRouter.swift
//  DaliyTimeLine
//
//  Created by Chung Wussup on 9/17/24.
//

import Foundation
import UIKit

class MainListRouter: MainListRouterProtocol {
    weak var viewController: UIViewController?
    
    static func createModule() -> UIViewController {
        let view = MainListViewController()
        let presenter = MainListPresenter()
        let interactor = MainListInteractor(service: PostService())
        let router = MainListRouter()
        
        view.presenter = presenter
        presenter.view = view
        presenter.interactor = interactor
        presenter.router = router
        router.viewController = view
        
        return view
    }
    
    func navigateToPostDetail(post: Post) {
//        let detailVC = PostDetailViewController(post: post)
//        viewController?.navigationController?.pushViewController(detailVC, animated: true)
    }
}
