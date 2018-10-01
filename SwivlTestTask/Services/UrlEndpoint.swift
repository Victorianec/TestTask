import Foundation
import Alamofire

enum UrlEndpoint: EndpointProtocol {
    
    // Users
    case users(page: Int, pageSize: Int)
    
    var endpoint: String {
        switch self {
            
        case .users:                    return "/users/"
            
        }
    }
    
    var endpointWithParams: String? {
        var components = URLComponents(string:  API_URL + self.endpoint)!
        components.queryItems = self.parameters?.map({ (key, value) -> URLQueryItem in
            return URLQueryItem(name: key, value: "\(value)")
        })
        return components.url?.absoluteString
    }
    
    var parameters: Parameters? {
        switch self {
            
        case .users(let page, let pageSize):
            let params = [
                "page" : page,
                "per_page" : pageSize
            ]
            return params
            
        }
    }
}
