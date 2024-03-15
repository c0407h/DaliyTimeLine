//
//  UploadViewModel.swift
//  DaliyTimeLine
//
//  Created by Chung Wussup on 3/16/24.
//

import UIKit

class UploadViewModel {
    var currentUser: User?
    var originalImage: UIImage?
    var selectedImage: UIImage? {
        didSet {
            if let image = selectedImage {
                originalImage = image
            }
        }
    }
    
    init(currentUser: User? = nil, originalImage: UIImage? = nil, selectedImage: UIImage? = nil) {
        self.currentUser = currentUser
        self.originalImage = originalImage
        self.selectedImage = selectedImage
    }
    
    func uploadPost(caption: String, image: UIImage, user: User, completion: @escaping () -> Void) {
        UploadService.uploadPost(caption: caption, image: image, user: user) { error in
            
            
            if let error = error {
                print(#function,"\(error.localizedDescription)")
                return
            }
            
            completion()
        }
    }
}
