import Foundation

class ShortGithubUser : CodableExpandedProtocol {
    
    var avatarUrl: String?
    var id: Int!
    var profileLink: String?
    var username: String?
    
    var isSelected = false

    required init(from decoder: Decoder) throws {
        
        let values = try decoder.container(keyedBy: CodingKeys.self)
        
        avatarUrl = try values.decodeIfPresent(String.self, forKey: .avatarUrl)
        profileLink = try values.decodeIfPresent(String.self, forKey: .profileLink)
        id = try values.decodeIfPresent(Int.self, forKey: .id)
        username = try values.decodeIfPresent(String.self, forKey: .username)
        
    }
    
}

extension ShortGithubUser {
    
    private enum CodingKeys: String, CodingKey {
        case avatarUrl = "avatar_url"
        case id
        case profileLink = "html_url"
        case username = "login"
    }
    
}
