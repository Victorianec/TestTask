import UIKit

class SelectUsersVC: UIViewController {
    
    private var usersManager = UsersManager.init()
    
    @IBOutlet weak var usersTableView: UITableView!
    @IBOutlet weak var selectedUsersCollectionView: UICollectionView!
    @IBOutlet weak var noSelectedLabel: UILabel!
    
    @IBOutlet weak var nextBarButtonItem: UIBarButtonItem!
    
    @IBOutlet weak var networkActivityIndicator: UIActivityIndicatorView!

    override func viewDidLoad() {
        super.viewDidLoad()
        setUIState()
        getGithubUsers()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        usersTableView.reloadData()
        selectedUsersCollectionView.reloadData()
        setUIState()
    }
    
    //MARK: UI setup
    
    private func setUIState() {
        nextBarButtonItem.isEnabled = usersManager.selectedUsers.count != 0
        noSelectedLabel.isHidden = usersManager.selectedUsers.count != 0
    }
    
    //MARK: Getting of data
    
    private func getGithubUsers() {
        networkActivityIndicator.startAnimating()
        usersManager.getGithubUsers { (errors) in
            self.networkActivityIndicator.stopAnimating()
            if let errors = errors {
                self.handleErrors(errors: errors)
                return
            }
            self.usersTableView.reloadData()
        }
    }
    
    private func getNextUsersPage() {
        usersManager.getNextPage { (errors) in
            if let errors = errors {
                self.handleErrors(errors: errors)
                return
            }
            self.usersTableView.reloadData()
        }
    }
    
    //MARK: User selection
    
    private func setUserSelected(at indexPath: IndexPath) {
        let user = usersManager.users[indexPath.row]
//        self.selectedUsersCollectionView.reloadData()
        
        if !user.isSelected {
            user.isSelected = !user.isSelected
            self.selectedUsersCollectionView.reloadData()
        }
        else {
            if let index = usersManager.selectedUsers.index(where: { $0.id == user.id}) {
                selectedUsersCollectionView.performBatchUpdates({
                    user.isSelected = !user.isSelected
                    let indexPathToDelete = IndexPath.init(item: index, section: 0)
                    self.selectedUsersCollectionView.deleteItems(at: [indexPathToDelete])
                }) { (completed) in
                    self.selectedUsersCollectionView.reloadData()
                }
            }
            else {
                user.isSelected = !user.isSelected
                self.selectedUsersCollectionView.reloadData()
            }
            
        }
        usersTableView.reloadRows(at: [indexPath], with: .none)
        setUIState()
    }
    
    private func deselectUser(at indexPath: IndexPath) {
        let user = usersManager.selectedUsers[indexPath.row]
        user.isSelected = false
        usersTableView.reloadData()
        selectedUsersCollectionView.performBatchUpdates({
            self.selectedUsersCollectionView.deleteItems(at: [indexPath])
        }) { (completed) in
            self.selectedUsersCollectionView.reloadData()
        }
        setUIState()
    }
    
    //MARK: Alert displaying
    
    func showAlert(title: String?, message: String?) {
        let alert = UIAlertController.init(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction.init(title: "OK", style: UIAlertActionStyle.cancel, handler: nil))
        self.present(alert, animated: false, completion: nil)
    }
    
    //MARK: ErrorDisplayable
    
    func errorDisplayable(in view: UIView) -> Array<ErrorDisplayable> {
        var eds: Array<ErrorDisplayable> = []
        
        for subview in view.subviews {
            if let ed = subview as? ErrorDisplayable { eds.append(ed) }
            if subview.subviews.count > 0 { eds.append(contentsOf: errorDisplayable(in: subview)) }
        }
        
        return eds
    }
    
    func errorDisplayable(for identifier: String) -> ErrorDisplayable? {
        return errorDisplayable(in: self.view).first(where: { (ed) -> Bool in
            let identifiers = ed.accessibilityIdentifier?.components(separatedBy: ",")
            return identifiers?.contains(identifier) ?? false
        })
    }
    
    //MARK: Handling of errors
    
    func handleErrors(errors: ErrorsDict) {
        var alertKey: String? // Only one error should be displayed as popup
        
        for (key, error) in errors {
            if let ed = errorDisplayable(for: key) {
                ed.error = error
            } else {
                alertKey = key
            }
        }
        
        if let key = alertKey,
            let error = errors[key] {
            let title = ResponseKeyError(rawValue: key)?.title ?? key
            self.showAlert(title: title, message: error.localizedDescription)
        }
    }
    
    //MARK: IBActions
    
    @IBAction func next(_ sender: AnyObject) {
        if usersManager.selectedUsers.count > 0 {
            let composeMessageVC = self.storyboard?.instantiateViewController(withIdentifier: ComposeMessageVC.vcId) as! ComposeMessageVC
            composeMessageVC.usersManager = usersManager
            self.navigationController?.pushViewController(composeMessageVC, animated: true)
        }
    }
}

extension SelectUsersVC: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return usersManager.users.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: GithubUserTableCell.cellId, for: indexPath) as! GithubUserTableCell
        cell.setInfo(user: usersManager.users[indexPath.row])
        cell.selectUserAction = {() in
            self.setUserSelected(at: indexPath)
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.row == usersManager.users.count - 1 && usersManager.isNextPageExists == true {
            self.getNextUsersPage()
        }
    }
    
}

extension SelectUsersVC: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return usersManager.selectedUsers.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: GithubUserCollectionCell.cellId, for: indexPath) as! GithubUserCollectionCell
        cell.setInfo(user: usersManager.selectedUsers[indexPath.item])
        cell.deselectAction = {() in
            self.deselectUser(at: indexPath)
        }
        return cell
    }
    

}
