//
//  MainTabbarRouter.swift
//  DaliyTimeLine
//
//  Created by Chung Wussup on 9/15/24.
//

import Foundation
import UIKit
import YPImagePicker

protocol MainTabbarRouterProtocol: AnyObject {
    func presentYPImagePicker()
    func presentUploadController(with user: User, selectedImage: UIImage)
}

class MainTabbarRouter: MainTabbarRouterProtocol {
    var viewController: UIViewController?
    
    static func createModule() -> UIViewController {
        
        let presenter = MainTabbarPresenter()  // Presenter 생성
        let interactor = MainTabbarInteractor()  // Interactor 생성
        let router = MainTabbarRouter()  // Router 생성
        let view = MainTabbarController()  // View 생성
        
        
        view.presenter = presenter  // View에 Presenter 주입
        presenter.view = view  // Presenter에 View 주입
        presenter.interactor = interactor  // Presenter에 Interactor 주입
        presenter.router = router  // Presenter에 Router 주입
        interactor.presenter = presenter  // Interactor에 Presenter 주입
        router.viewController = view  // Router에 View 주입

        return view
    }
    
    func presentYPImagePicker() {
        var config = YPImagePickerConfiguration()
        config.library.mediaType = .photo
        config.shouldSaveNewPicturesToAlbum = false
        config.startOnScreen = .photo
        config.screens = [.photo, .library]
        
        config.colors.tintColor = .darkGray
        config.library.maxNumberOfItems = 1
        
        config.fonts.pickerTitleFont =  UIFont(name: "OTSBAggroB", size: 17)!
        config.fonts.libaryWarningFont = UIFont(name: "OTSBAggroM", size: 14)!
        config.fonts.durationFont = UIFont(name: "OTSBAggroM", size: 12)!
        config.fonts.multipleSelectionIndicatorFont = UIFont(name: "OTSBAggroM", size: 12)!
        config.fonts.albumCellTitleFont = UIFont(name: "OTSBAggroM", size: 16)!
        config.fonts.albumCellNumberOfItemsFont = UIFont(name: "OTSBAggroM", size: 12)!
        config.fonts.menuItemFont = UIFont(name: "OTSBAggroL", size: 12)!
        config.fonts.filterNameFont = UIFont(name: "OTSBAggroM", size: 11)!
        config.fonts.filterSelectionSelectedFont = UIFont(name: "OTSBAggroL", size: 11)!
        config.fonts.filterSelectionUnSelectedFont = UIFont(name: "OTSBAggroM", size: 11)!
        config.fonts.cameraTimeElapsedFont = UIFont(name: "OTSBAggroM", size: 13)!
        config.fonts.navigationBarTitleFont = UIFont(name: "OTSBAggroM", size: 17)!
        config.fonts.rightBarButtonFont = UIFont(name: "OTSBAggroL", size: 17)
        config.fonts.leftBarButtonFont = UIFont(name: "OTSBAggroL", size: 17)
        
        let newCapturePhotoImage = config.icons.captureVideoImage
        config.icons.capturePhotoImage = newCapturePhotoImage
        
        let picker = YPImagePicker(configuration: config)
        

        
        
        picker.didFinishPicking {[weak picker] items, cancelled in
            if cancelled {
                picker?.dismiss(animated: true)
            } else {
                picker?.dismiss(animated: false) {
                    guard let selectedImage = items.singlePhoto?.image else { return }
                    guard let presenter = (self.viewController as? MainTabbarController)?.presenter else { return }
                    presenter.didFinishPickingMedia(selectedImage: selectedImage)
                }
            }
        }
        
        viewController?.present(picker, animated: true)
    }
    
    func presentUploadController(with user: User, selectedImage: UIImage) {
        let controller = UploadContentViewController(viewModel: UploadViewModel(currentUser: user, 
                                                                                originalImage: selectedImage,
                                                                                selectedImage: selectedImage)
        )
        let nav = UINavigationController(rootViewController: controller)
        nav.modalPresentationStyle = .fullScreen
        nav.navigationBar.tintColor = .black
        viewController?.present(nav, animated: false)
    }
}
