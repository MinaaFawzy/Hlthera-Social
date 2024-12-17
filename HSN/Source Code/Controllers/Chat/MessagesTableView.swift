import UIKit
@objc protocol tableViewDelegate {
    @objc optional func didTap(_ tableView: UITableView, index:Int, data: Any?)
}
class MessagesTableView: UITableView, UITableViewDelegate, UITableViewDataSource {
    
    var contactsArray = [Contacts]()
    var searchedContactsArray = [Contacts](){
        didSet{
            self.reloadData()
//            if (self.searchedContactsArray.count > 0){
//                self.parentViewController?.performSegue(withIdentifier: "SubscribePopUp", sender: nil)
//            }
        }
    }
    
    var messageDelegate:tableViewDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.delegate = self
        self.dataSource = self
        self.getChatList()
    }
    
    func getChatList(){
        let url = ServiceName.getChatContacts + String.getString(UserData.shared.id)
        AppsNetworkManager.sharedInstanse.requestApi(parameters: [:], serviceurl: url, methodType: .get, completionClosure: {response in
            let data = kSharedInstance.getDictionaryArray(withDictionary: (response))
            self.contactsArray = data.map{Contacts(data: $0)}
            self.searchedContactsArray = self.contactsArray
        })
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //self.searchedContactsArray.count == 0 ? self.setEmptyView(title: String.getString(Notifications.kNoDataError).localized(), message: ""):self.restore()
        return self.searchedContactsArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: MessagesTVC.identifier) as? MessagesTVC else{return
            UITableViewCell()}
        cell.contact = self.searchedContactsArray[indexPath.row]
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.messageDelegate?.didTap?(self, index: indexPath.row, data: self.searchedContactsArray[indexPath.row])
    }
}
