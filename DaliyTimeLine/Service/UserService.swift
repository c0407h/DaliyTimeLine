//
//  UserService.swift
//  DaliyTimeLine
//
//  Created by Chung Wussup on 1/22/24.
//

import Firebase
struct UserService {
    
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
