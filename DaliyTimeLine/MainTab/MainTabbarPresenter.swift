//
//  MainTabbarPresenter.swift
//  DaliyTimeLine
//
//  Created by Chung Wussup on 9/15/24.
//

import Foundation
import UIKit

protocol MainTabbarPresenterProtocol: AnyObject {
    func viewDidLoad()
    func didSelectUpload()
    func didFinishPickingMedia(selectedImage: UIImage)
    func reloadMainList()
    func didFetchUser(user: User)
}

class MainTabbarPresenter: MainTabbarPresenterProtocol {
    weak var view: MainTabbarViewProtocol?
    var interactor: MainTabbarInteractorProtocol?
    var router: MainTabbarRouterProtocol?
    
    func viewDidLoad() {
        interactor?.fetchUser()
    }
    
    func didSelectUpload() {
        router?.presentYPImagePicker()
    }
    
    func didFinishPickingMedia(selectedImage: UIImage) {
        guard let user = interactor?.getUser() else { return }
        router?.presentUploadController(with: user, selectedImage: selectedImage)
    }
    
    func reloadMainList() {
        view?.reloadMainListView()
    }
    
    func didFetchUser(user: User) {
        view?.configureTabbar(user: user)
    }
}
