import UIKit

class GithubUserCollectionCell: UICollectionViewCell {
    
    static let cellId = "GithubUserCollectionCell"
    
    @IBOutlet weak var avatarView: UIImageView!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var deselectButton: UIButton!
    
    var deselectAction: ActionBlock?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        avatarView.layer.cornerRadius = avatarView.bounds.size.height / 2
    }
    
    func setInfo(user: ShortGithubUser) {
        if let avatar = user.avatarUrl {
            avatarView.sd_setImage(with: URL.init(string: avatar))
        }
        else {
            avatarView.image = UIImage.init(named: "avatar_placeholder")
        }
        self.usernameLabel.text = user.username ?? ""
        deselectButton.setImage(UIImage.init(named: "icon_cross"), for: .normal)
    }
    
    @IBAction func deselectUser(_ sender: AnyObject) {
        guard let deselectAction = deselectAction else { return }
        deselectAction()
    }
    
}
