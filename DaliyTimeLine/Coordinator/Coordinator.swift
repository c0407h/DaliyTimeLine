//
//  Coordinator.swift
//  DaliyTimeLine
//
//  Created by Chung Wussup on 4/14/24.
//

import Foundation

protocol Coordinator: AnyObject {
    var childCoordinators: [Coordinator] { get set }
    func start()
}
