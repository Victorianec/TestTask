//
//  ComposeMessageVC.swift
//  SwivlTestTask
//
//  Created by Victor on 01.10.2018.
//  Copyright © 2018 Victor. All rights reserved.
//

import UIKit

class ComposeMessageVC: UIViewController {
    
    static let vcId = "ComposeMessageVC"
    
    var usersManager: UsersManager!
    
    @IBOutlet weak var selectedUsersCollectionView: UICollectionView!
    @IBOutlet weak var noSelectedLabel: UILabel!
    @IBOutlet weak var messageTextView: UITextView!
    @IBOutlet weak var sendButton: UIButton!
    
    @IBOutlet weak var bottomConstraint: NSLayoutConstraint!

    override func viewDidLoad() {
        super.viewDidLoad()
        self.setUIState()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.registerForKeyboardNotifications(viewController: self)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        unregisterForKeyboardNotifications(viewController: self)
    }
    
    //MARK: UI setup
    
    private func setUIState() {
        noSelectedLabel.isHidden = usersManager.selectedUsers.count != 0
        sendButton.isEnabled = usersManager.selectedUsers.count != 0 && !messageTextView.text.isEmpty
    }
    
    //MARK: User selection
    
    private func deselectUser(at indexPath: IndexPath) {
        let user = usersManager.selectedUsers[indexPath.row]
        user.isSelected = false
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
    
    //MARK: IBActions
    
    @IBAction func send(_ sender: AnyObject) {
        self.view.endEditing(true)
        usersManager.resetSelection()
        self.navigationController?.popViewController(animated: false)
    }
    
    //MARK: Keyboard notifications
    
    func registerForKeyboardNotifications(viewController: ComposeMessageVC) {
        NotificationCenter.default.addObserver(viewController, selector: #selector(ComposeMessageVC.keyboardWillShow(notification:)), name: .UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(viewController, selector: #selector(ComposeMessageVC.keyboardWillHide(notification:)), name: .UIKeyboardWillHide, object: nil)
    }
    
    func unregisterForKeyboardNotifications(viewController: ComposeMessageVC) {
        NotificationCenter.default.removeObserver(viewController, name: .UIKeyboardWillShow, object: nil)
        NotificationCenter.default.removeObserver(viewController, name: .UIKeyboardWillHide, object: nil)
    }
    
    @objc func keyboardWillShow(notification: NSNotification) {
        
        let keyboardFrame = getKeyboardFrame(notification: notification)
        bottomConstraint.constant = keyboardFrame.height + 20.0
        view.layoutIfNeeded()
    }
    
    func getKeyboardFrame(notification: NSNotification) -> CGRect {
        var userInfo = notification.userInfo!
        let keyboardFrame = (userInfo[UIKeyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
        return keyboardFrame
    }
    
    @objc func keyboardWillHide(notification: NSNotification) {
        bottomConstraint.constant = 20.0
        view.layoutIfNeeded()
    }

    //MARK: Touches
    
    override open func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
}


extension ComposeMessageVC: UICollectionViewDataSource {
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

extension ComposeMessageVC: UITextViewDelegate {
    
    func textViewDidChange(_ textView: UITextView) {
        sendButton.isEnabled = usersManager.selectedUsers.count != 0 && !messageTextView.text.isEmpty
    }
    
}
