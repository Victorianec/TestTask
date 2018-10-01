import Foundation
import Alamofire

let API_URL = "https://api.github.com"

let requestPageSize = 30

// MARK: - Typealias

typealias JSON = Dictionary<String, Any>
typealias ErrorsDict = Dictionary<String, Error> // For errors from server response

typealias ActionBlock = (() -> ())

typealias OptionalErrorResponse = ((_ errors: ErrorsDict?) -> Void)

typealias ResponseObjectBlock<T: Any> = (_ value: T?, _ error: ErrorsDict?) -> Void

// MARK: - Wrappers

typealias Response = DataResponse // Wrapper for DataResponse - helps to avoid Alamofire import in every file
typealias RequestPage = String
