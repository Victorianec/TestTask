import Foundation

enum NetworkError: Error, LocalizedError {
    case parsingError
    case custom(text: String)
    
    var errorDescription: String? {
        switch self {
            
        case .parsingError:     return "Parsing error"
        case .custom(let text): return text
        }
    }
}

enum ResponseKeyError: String {
    case nonField = "non_field_errors"
    
    var title: String {
        switch self {
        case .nonField: return "Error"
        }
    }
}

// MARK: - ErrorsDict

extension Dictionary where Key == String, Value == Error {
    
    init(error: Error) {
        self.init()
        self[ResponseKeyError.nonField.rawValue] = error
    }

}
