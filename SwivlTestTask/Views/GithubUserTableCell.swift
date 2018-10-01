import UIKit
import SDWebImage

class GithubUserTableCell: UITableViewCell {
    
    static let cellId = "GithubUserTableCell"
    
    @IBOutlet weak var avatarView: UIImageView!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var profileLinkLabel: UILabel!
    @IBOutlet weak var checkboxButton: UIButton!

    var selectUserAction: ActionBlock?
    
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
        self.profileLinkLabel.text = user.profileLink ?? ""
        checkboxButton.setImage(user.isSelected ? UIImage.init(named: "icon_checkbox_selected") : UIImage.init(named: "icon_checkbox_deselected"), for: .normal)
    }
    
    @IBAction func selectUser(_ sender: AnyObject) {
        guard let selectUserAction = selectUserAction else { return }
        selectUserAction()
    }

    override func prepareForReuse() {
        self.avatarView.image = UIImage.init(named: "avatar_placeholder")
        self.usernameLabel.text = ""
        self.profileLinkLabel.text = ""
         checkboxButton.setImage(UIImage.init(named: "icon_checkbox_deselected"), for: .normal)
    }
    
}
