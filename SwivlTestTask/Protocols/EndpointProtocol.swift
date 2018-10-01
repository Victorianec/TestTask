import Foundation
import Alamofire

protocol EndpointProtocol {
    var endpoint: String { get }
    var parameters: Parameters? { get }
}
