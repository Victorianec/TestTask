//
//  UsersManager.swift
//  SwivlTestTask
//
//  Created by Victor on 01.10.2018.
//  Copyright © 2018 Victor. All rights reserved.
//

import Foundation
import UIKit

class UsersManager: NSObject {
    
    private let usersService = UsersService.init()
    var currentPage = 0
    var users = Array<ShortGithubUser>()
    var isNextPageExists: Bool = false
    
    var selectedUsers: Array<ShortGithubUser> {
        return users.filter({$0.isSelected == true})
    }
    
    func getGithubUsers(_ completion: @escaping OptionalErrorResponse) {
        usersService.getGithubUsers(currentPage) { (users, errors) in
            if let users = users {
                self.users.append(contentsOf: users)
                self.isNextPageExists = users.count == requestPageSize //Check that next page MAYBE exists
            }
            completion(errors)
        }
    }
    
    func getNextPage(_ completion: @escaping OptionalErrorResponse) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        currentPage = currentPage + 1
        getGithubUsers { (errors) in
            UIApplication.shared.isNetworkActivityIndicatorVisible = false
            completion(errors)
        }
    }
    
}
