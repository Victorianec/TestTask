import Foundation

extension Dictionary {
    
    mutating func append(contentsOf right: Dictionary) {
        for (key, value) in right {
            self[key] = value
        }
    }
}
