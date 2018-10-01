import Foundation
import Alamofire

extension DataRequest {
    
    @discardableResult
    func responseOptionalErrors(completionHandler: @escaping OptionalErrorResponse) -> Self {
        return self.responseJSON { (response: Response<Any>) in
            if let errors = NetworkManager.parseErrors(response: response) {
                completionHandler(errors)
                return
            }
            
            completionHandler(nil)
        }
    }
}
