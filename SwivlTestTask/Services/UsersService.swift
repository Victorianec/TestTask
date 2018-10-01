import Foundation
import Alamofire

protocol UsersServiceProtocol {
    func getGithubUsers(_ page: Int, _ completion: @escaping (_ users: Array<ShortGithubUser>?, _ errors: ErrorsDict?) -> Void)
}

class UsersService: UsersServiceProtocol {
    func getGithubUsers(_ page: Int, _ completion: @escaping (Array<ShortGithubUser>?, ErrorsDict?) -> Void) {
        let endpoint = UrlEndpoint.users(page: page, pageSize: requestPageSize)
        NetworkManager.request(urlEndpoint: endpoint, method: .get).responseModelArray { (response: Response<Array<ShortGithubUser>>) in
            completion(response.value, NetworkManager.parseErrors(response: response))
        }
    }
    
}
