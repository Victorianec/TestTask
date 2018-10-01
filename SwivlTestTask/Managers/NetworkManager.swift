import Foundation
import Alamofire

private extension HTTPMethod {
    var encoding: ParameterEncoding {
        switch self {
        case .get: return URLEncoding.queryString
        default:   return JSONEncoding.default
        }
    }
}

class NetworkManager {
    
    // Common request
    
    class func request(urlEndpoint: EndpointProtocol, method: HTTPMethod = .get) -> DataRequest {
        return NetworkManager.request(url: API_URL + urlEndpoint.endpoint, method: method, parameters: urlEndpoint.parameters)
    }

    class func request(url: URLConvertible, method: HTTPMethod = .get, parameters: Parameters? = nil) -> DataRequest {
        let request = Alamofire.request(url, method: method, parameters: parameters, encoding: method.encoding, headers: HTTPHeaders.init()).validate()
        return request
    }
    
}

// MARK: - Error parsing

extension NetworkManager {
    
    class func parseErrors<T : Any>(response: Response<T>) -> ErrorsDict? {
        guard let _ = response.error else { return nil }

        guard let json = response.data?.json else {
            return ErrorsDict.init(error: NetworkError.parsingError)
        }
        
        return parseErrors(json: json)
    }
    
    private class func parseErrors(json: JSON) -> ErrorsDict {
        var errors: ErrorsDict = [:]
        for (key, value) in json {
            switch value {
                
            case is String:             errors[key] = NetworkError.custom(text: value as! String)
                
            case is Array<String>:      errors[key] = NetworkError.custom(text: (value as! Array<String>).first!)
                
            case is JSON:               errors.append(contentsOf: parseErrors(json: value as! JSON))
                
            case is Array<JSON>: (value as! Array<JSON>).forEach({ errors.append(contentsOf: parseErrors(json: $0)) })
                
            default: break
            }
        }
        
        return errors
    }
}
