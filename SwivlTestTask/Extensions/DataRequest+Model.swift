import Foundation
import Alamofire

extension DataRequest {
    
    // MARK: - Single model
    
    @discardableResult
    func responseModel<T: DecodableExpanded>(queue: DispatchQueue? = nil, completionHandler: @escaping (Response<T>) -> Void) -> Self {
        let modelSerializer: DataResponseSerializer<T> = DataRequest.modelResponseSerializer()
        return response(queue: queue, responseSerializer: modelSerializer, completionHandler: completionHandler)
    }
    
    internal static func modelResponseSerializer<T: DecodableExpanded>() -> DataResponseSerializer<T> {
        
        return DataResponseSerializer { request, response, data, error in
            
            // Basic validators already included in json serializer
            let jsonResponse = serializeResponseJSON(options: .allowFragments, response: response, data: data, error: error)
            
            if let jsonParsingError = jsonResponse.error {
                return .failure(AFError.responseSerializationFailed(reason: .jsonSerializationFailed(error: jsonParsingError)))
            }
            
            do {
                let model = try T.decoder.decode(T.self, from: data!)
                return .success(model)
            } catch {
                return .failure(AFError.responseSerializationFailed(reason: .jsonSerializationFailed(error: error)))
            }
        }
    }
    
    // MARK: - Array of models
    
    @discardableResult
    func responseModelArray<T: DecodableExpanded>(queue: DispatchQueue? = nil, rootKey: String = "results", completionHandler: @escaping (Response<Array<T>>) -> Void) -> Self {
        let modelArraySerializer: DataResponseSerializer<Array<T>> = DataRequest.modelArrayResponseSerializer(rootKey: rootKey)
        return response(queue: queue, responseSerializer: modelArraySerializer, completionHandler: completionHandler)
    }
    
    internal static func modelArrayResponseSerializer<T: DecodableExpanded>(rootKey: String) -> DataResponseSerializer<Array<T>> {
        
        return DataResponseSerializer { request, response, data, error in
            
            // Basic validators already included in json serializer
            let jsonResponse = serializeResponseJSON(options: .allowFragments, response: response, data: data, error: error)
            
            if let jsonParsingError = jsonResponse.error {
                return .failure(AFError.responseSerializationFailed(reason: .jsonSerializationFailed(error: jsonParsingError)))
            }
            
            // Detect if response is list with pagination
            guard let objectsList = (jsonResponse.value as? JSON)?[rootKey] as? Array<JSON> else {
                return .failure(NetworkError.parsingError)
            }
            
            do {
                let values = try T.decoder.decode(Array<T>.self, from: objectsList)
                return .success(values)
            } catch {
                return .failure(AFError.responseSerializationFailed(reason: .jsonSerializationFailed(error: error)))
            }
        }
    }
}
