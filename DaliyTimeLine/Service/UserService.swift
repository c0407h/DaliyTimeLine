//
//  UserService.swift
//  DaliyTimeLine
//
//  Created by Chung Wussup on 1/22/24.
//

import Firebase
struct UserService {
//    static func fetchUser(withUid uid: String, completion: @escaping(User) -> Void) {
//        
//        COLLECTION_USERS.document(uid).getDocument { snapshot, error in
//            guard let dictionary = snapshot?.data() else { return }
//            let user = User(dictionary: dictionary)
//            completion(user)
//        }
//    }
    
    static func createUserPassCode(passcode: String) {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        COLLECTION_USERS.document(uid).collection("passCode").document().setData(["passCode": passcode])
    }
    
    static func deleteUSerPassCode() {
        guard let uid = Auth.auth().currentUser?.uid else { return }
          COLLECTION_USERS.document(uid).collection("passCode").getDocuments { (querySnapshot, error) in
              if let error = error {
                  print("Error getting documents: \(error)")
                  return
              } else {
                  for document in querySnapshot!.documents {
                      document.reference.delete()
                  }
              }
          }
    }
}
