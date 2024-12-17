//
//  ListPickerVC.swift
//  Sconto
//
//  Created by fluper on 21/07/21.
//

import UIKit

class ListPickerVC: UIViewController {

    //MARK: Outlets
    @IBOutlet weak var tableViewList: UITableView!
    
    //MARK: Variables
    @IBOutlet weak var searchBar: UISearchBar!
    var callback:((_ selectedItem:String,_ index:Int)->Void)?
    var items:[String] = []
    var searchedItems:[String] = []
    var isSearching = false
    let pickerView = UIPickerView()
    
    //MARK: Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        tableViewList.tableFooterView = UIView()
        setupSearchBar()
        // setupPickerView()
        
       // searchView?.backgroundImage = UIImage()
        // Do any additional setup after loading the view.
    }
//    func setupPickerView(){
////        if #available(iOS 13.4, *) {
////            pickerView.frame = CGRect(x: 0, y: 0, width: self.view.bounds.width, height: 250.0)
////            pickerView.frame = CGRect(x: 0, y: 0, width: self.view.bounds.width, height: 250.0)
////        }
//        pickerView.frame = CGRect(x: 0, y: 0, width: self.view.bounds.width, height: 250.0)
//        pickerView.frame = CGRect(x: 0, y: 0, width: self.view.bounds.width, height: 250.0)
//        //pickerView.dataSource = self
//       // pickerView.delegate = self
//         self.setToolBar(textField: textFieldEndTime)
//    }
//    func setToolBar(textField:UITextField) {
//        let toolBar = UIToolbar()
//        toolBar.barStyle = .default
//        toolBar.isTranslucent = true
//        let myColor : UIColor = UIColor( red: 2/255, green: 14/255, blue:70/255, alpha: 1.0 )
//        toolBar.tintColor = myColor
//        toolBar.sizeToFit()
//        // Adding Button ToolBar
//
//        toolBar.tag = 0
//        let doneButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(doneClick))
//
//        let cancelButton = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(cancelClick))
//        let spaceButton = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
//        if textField.tag == 0{
//            toolBar.setItems([cancelButton, spaceButton, doneButton], animated: false)
//        }
//
//
//
//        toolBar.isUserInteractionEnabled = true
//        textField.inputView = self.datePickerView
//
//        textField.inputAccessoryView = toolBar
//    }
//    @objc func doneClick() {
//        self.view.endEditing(true)
//        let date = self.datePickerView.date
//        let dateFormatter = DateFormatter()
//        dateFormatter.dateFormat = "h:mm a"
//            let calendar = Calendar.current
//        let comp = calendar.dateComponents([.hour, .minute], from: date)
//            let hour = comp.hour
//            let minute = comp.minute
//
//
//        self.textFieldEndTime.text = dateFormatter.string(from: date)
//    }
    @objc func cancelClick() {
        self.view.endEditing(true)
    }
    @objc func doneAction(_ sender : UITextField!) {
        self.view.endEditing(true)
    }
    
    //MARK: Actions
    @IBAction func buttonCancelTapped(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    func setupSearchBar() {
        let searchView = self.searchBar
        let searchField = self.searchBar.searchTextField
        searchField.backgroundColor = UIColor().hexStringToUIColor(hex: "#F5F7F9")
        searchField.textColor = UIColor().hexStringToUIColor(hex: "#212529")
        searchField.attributedPlaceholder = NSAttributedString(string: searchField.placeholder ?? "", attributes: [NSAttributedString.Key.foregroundColor : UIColor(hexString: "#8794AA")])
        if let leftView = searchField.leftView as? UIImageView {
            leftView.image = leftView.image?.withRenderingMode(.alwaysTemplate)
            leftView.tintColor = UIColor(hexString: "#8794AA")
        }
        searchField.addDoneOnKeyboardWithTarget(self, action: #selector(self.doneAction(_:)), shouldShowPlaceholder: false)
    }

}

//MARK: Extension: UITableView Delegates
extension ListPickerVC:UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return isSearching ? searchedItems.count : items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ListPickerTableViewCell.identifier, for: indexPath) as! ListPickerTableViewCell
        cell.labelItem.text = isSearching ? searchedItems[indexPath.row] : items[indexPath.row]
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        callback?(isSearching ? searchedItems[indexPath.row] : items[indexPath.row],items.firstIndex(of: isSearching ? searchedItems[indexPath.row] : items[indexPath.row] ) ?? 0)
        
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    
}
extension ListPickerVC:UISearchBarDelegate{
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText.isEmpty{
            isSearching = false
            self.tableViewList.reloadData()
        }
        else{
            isSearching = true
            searchedItems = self.items.filter{$0.lowercased().prefix(searchText.count) == searchText.lowercased()}
            self.tableViewList.reloadData()
        }
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        isSearching = false
        self.tableViewList.reloadData()
    }
}

class ListPickerTableViewCell: UITableViewCell {
    //MARK: Outlets
    @IBOutlet weak var labelItem: UILabel!
    
    //MARK: Life Cycle
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
extension UIViewController{
    func showDropDown(on nav:UINavigationController?,present:Bool = false,for data:[String],completion: @escaping ((String,Int)->())){
        
        if data.count > 10{
            guard let vc = UIStoryboard(name: Storyboards.kHome, bundle: nil).instantiateViewController(identifier: ListPickerVC.getStoryboardID()) as? ListPickerVC else {
                return
            }
            vc.items = data
            vc.callback = {
                value,index in
                self.dismiss(animated: true){ [self] in
                   completion(value,index)
                    }
                }
           present ? (self.present(vc, animated: true)) : (nav?.present(vc, animated: true, completion: nil))
            
            
    }
        else if !data.isEmpty{
            guard let vc = UIStoryboard(name: Storyboards.kHome, bundle: nil).instantiateViewController(identifier: PickerVC.getStoryboardID()) as? PickerVC else {
                return
            }
            vc.modalTransitionStyle = .crossDissolve
            vc.modalPresentationStyle = .overFullScreen
            vc.items = data
            vc.callback = {
                value,index in
                self.dismiss(animated: true){ [self] in
                   completion(value,index)
                    }
                }
            present ? (self.present(vc, animated: true)) : (nav?.present(vc, animated: true, completion: nil))
            
        }
        else{
            CommonUtils.showToast(message: "No data found")
            return
        }

        
        
        
        
        
    }
}
