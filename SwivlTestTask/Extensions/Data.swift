import Foundation

extension Data {
    
    var json: JSON? {
        return (try? JSONSerialization.jsonObject(with: self, options: .allowFragments)) as? JSON
    }
}
