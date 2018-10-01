import Foundation

extension JSONDecoder {
    
    func decode<T>(_ type: T.Type, from json: JSON) throws -> T where T : Decodable {
        let data = try JSONSerialization.data(withJSONObject: json, options: JSONSerialization.WritingOptions.init(rawValue: 0))
        return try self.decode(type, from: data)
    }
    
    func decode<T>(_ type: T.Type, from jsonArray: Array<JSON>) throws -> T where T : Decodable {
        let data = try JSONSerialization.data(withJSONObject: jsonArray, options: JSONSerialization.WritingOptions.init(rawValue: 0))
        return try self.decode(type, from: data)
    }
}
