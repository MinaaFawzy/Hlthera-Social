//
//  AppsCountryPicker.swift
//  CountryPickerDemo
//
//  Created by Shubham Kaliyar on 29/01/20.
//  Copyright © 2020 Shubham Kaliyar. All rights reserved.
//

import Foundation
import UIKit

//MARK:- AppsCountryPickerDelegate
protocol AppsCountryPickerDelegate: class {
    func countryPicker(_ picker: AppsCountryPicker, didSelectCountryWithName name: String, code: String, dialCode: String , flag:UIImage)
}

//MARK:- object
public var currentcountryCode = NSLocale.current.regionCode
public var currentcountrylanguageCode = NSLocale.current.languageCode
fileprivate var savedContentOffset = CGPoint(x: 0, y: -50)
fileprivate var savedCountryCode = String()


//MARK:- Class for Country Picker
final class AppsCountryPicker: UITableViewController {
    
    
    //MARK:- objects
    var countries = [[String:String]]()
    var filteredCountries = [[String:String]]()
    var searchBar = UISearchBar()
    var headerView = UIView()
    var cancelButton = UIButton()
    weak var delegate: AppsCountryPickerDelegate?
    
    var searchBarBackground   = UIColor.white
    var searchBartextColor    = UIColor.systemBlue
    var countrytextColor      = UIColor.gray
    var tableBackgroundColor  = UIColor.white
    var cellBackgroundColor   = UIColor.white
    var saperatorColor        = UIColor.gray
    var cancelButtonColor     = #colorLiteral(red: 0.1176470588, green: 0.2470588235, blue: 0.4235294118, alpha: 1)
    var placeholderTextSearch = "Search"
    var placeholderTextColor = UIColor.gray
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.fetchCountries()
        self.configureView()
        self.configureSearchBar()
        self.configureTableView()
        self.tableView.register(CountryCodeCell.self, forCellReuseIdentifier: CountryCodeCell.cellidentifier)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.setContentOffset(savedContentOffset, animated: false)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        savedContentOffset = tableView.contentOffset
    }
    
    
    func fetchCountries () {
        guard let path = Bundle.main.path(forResource: "CallingCodes", ofType: "plist") else {return}
        let url = URL(fileURLWithPath: path)
        let data = try! Data(contentsOf: url)
        guard let plist = try! PropertyListSerialization.propertyList(from: data, options: .mutableContainers, format: nil) as? [[String:String]] else {return}
        print(plist)
        self.countries = plist
    }
    
    
    
    
    fileprivate func configureView() {
        title = "Select your country"
        view.backgroundColor = tableBackgroundColor
        self.headerView.backgroundColor = searchBarBackground
        self.headerView.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: 50)
    }
    
    fileprivate func configureSearchBar() {
        searchBar.delegate = self
        searchBar.searchBarStyle = .minimal
        searchBar.searchTextField.attributedPlaceholder = NSAttributedString(string:self.placeholderTextSearch, attributes: [NSAttributedString.Key.foregroundColor: self.placeholderTextColor])
        searchBar.backgroundColor = searchBarBackground
        searchBar.searchTextField.textColor = self.searchBartextColor
        searchBar.keyboardAppearance = .light
        
        searchBar.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width-100, height: 50)
        cancelButton.frame = CGRect(x: UIScreen.main.bounds.width - 100, y: 0, width:100, height: 50)
        cancelButton.setTitle("Cancel", for: .normal)
        cancelButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 18)
        cancelButton.setTitleColor(cancelButtonColor, for: .normal)
        cancelButton.addTarget(self, action: #selector(dismissController), for: .touchUpInside)
        self.headerView.addSubview(cancelButton)
        self.headerView.addSubview(searchBar)
    }
    
    @objc func dismissController() {
        self.dismiss(animated: true, completion: nil)
    }
    
    fileprivate func configureTableView() {
        tableView.indicatorStyle = .default
        tableView.separatorStyle = .none
        tableView.backgroundColor = tableBackgroundColor
        filteredCountries = countries
    }
}

extension AppsCountryPicker {
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return self.headerView
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        50
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredCountries.count
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 55
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let countryObjects = filteredCountries[indexPath.row]
        let cell =  (tableView.dequeueReusableCell(withIdentifier: CountryCodeCell.cellidentifier) as? CountryCodeCell)!
        cell.selectionStyle = .gray
        cell.backgroundColor = cellBackgroundColor
        cell.updateCell(dataforCell: countryObjects, countrytextColor: countrytextColor)
        cell.accessoryType = currentcountryCode == countryObjects["code"]! ?  .checkmark : .none
        return cell
    }
    
    
    fileprivate func resetCheckmark() {
        for index in 0...filteredCountries.count {
            let indexPath = IndexPath(row: index , section: 0)
            let cell = tableView.cellForRow(at: indexPath)
            cell?.accessoryType = .none
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.dismiss(animated: true, completion: nil)
        let countryObjects = filteredCountries[indexPath.row]
        resetCheckmark()
        let cell = tableView.cellForRow(at: indexPath)
        cell?.accessoryType = .none
        currentcountryCode = countryObjects["code"] ?? ""
        delegate?.countryPicker(self, didSelectCountryWithName: countryObjects["name"] ?? "",
                                code: countryObjects["code"] ?? "",
                                dialCode: countryObjects["dial_code"] ?? "", flag: UIImage(named: countryObjects["code"]!) ?? UIImage())
        
    }
}

extension AppsCountryPicker: UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        filteredCountries = searchText.isEmpty ? countries : countries.filter({ (data: [String : String]) -> Bool in
            return data["name"]!.lowercased().contains(searchText.lowercased()) || data["dial_code"]!.lowercased().contains(searchText.lowercased())
        })
        tableView.reloadData()
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        self.searchBar.endEditing(true)
    }
}

extension AppsCountryPicker {
    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView.isDecelerating {
            view.endEditing(true)
        }
    }
}

let AppsCountryPickers = AppsCountryPickerInstanse.sharedInstanse

//MARK:- Show countryPicker
class AppsCountryPickerInstanse : AppsCountryPickerDelegate {
    func countryPicker(_ picker: AppsCountryPicker, didSelectCountryWithName name: String, code: String, dialCode: String, flag: UIImage) {
        let selectCountry = CountryModel()
        selectCountry.countryCode = dialCode
        selectCountry.name = name
        selectCountry.code = code
        selectCountry.image = flag
        self.hitClosure?(selectCountry)
    }
    
    
    //MARK:- Closore
    var hitClosure:((CountryModel)->())?
    
    //MARK:- sharedInsranse
    static let sharedInstanse = AppsCountryPickerInstanse()
    
    func showController(referense:UIViewController? ,handler:@escaping (_ result:CountryModel?) -> ()) -> Void {
        let picker = AppsCountryPicker()
        picker.delegate = self
        picker.cellBackgroundColor  = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        picker.searchBartextColor   = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        self.hitClosure = {selectCountry in  handler(selectCountry)}
         referense?.present(picker, animated: true)
    }
    
    class CountryModel {
        var name:String?
        var image:UIImage?
        var code:String?
        var countryCode:String?
    }
}



import UIKit

final class CountryCodeCell: UITableViewCell {
    
    //MARK:- Objects
    static let cellidentifier = String(describing: CountryCodeCell.self)
    
    var lblCountryCode = UILabel()
    var lblCountryName = UILabel()
    var imgCountryFlag = UIImageView()
    var underlineView = UIView()
    
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .subtitle, reuseIdentifier: reuseIdentifier)
        self.lblCountryCode.frame = CGRect(x: UIScreen.main.bounds.width - 110, y: (self.contentView.frame.height/2) , width: 100, height: 20)
        self.underlineView.frame = CGRect(x: self.textLabel?.frame.origin.x ?? 0, y: (self.contentView.frame.height + 10) , width: UIScreen.main.bounds.width , height: 0.5)
        self.textLabel?.frame =  CGRect(x: 0, y: (self.contentView.frame.height/2) , width: UIScreen.main.bounds.width-110 , height: 20)
        self.textLabel?.numberOfLines = 2
        self.lblCountryCode.textAlignment = .right
        self.lblCountryCode.font = UIFont.systemFont(ofSize: 17)
        self.contentView.addSubview(lblCountryCode)
        self.contentView.addSubview(underlineView)
        selectionStyle = .none
        backgroundColor = nil
        contentView.backgroundColor = nil
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    //MARK:- func for update Cell
    func updateCell(dataforCell data:[String:String]? , countrytextColor:UIColor) {
        self.underlineView.backgroundColor = .gray
        self.imageView?.image = UIImage(named: data?["code"] ?? "")?.countryFlagSize(size: CGSize(width: 32, height: 24), roundedRadius: 3)
        self.setNeedsLayout()
        self.layoutIfNeeded()
        self.lblCountryCode.text = (data?["dial_code"] ?? "")
        self.textLabel?.text = data?["name"] ?? ""
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        accessoryType = selected ? .checkmark : .none
    }
    
    
}


//MARK:- Extension for image Size
extension UIImage {
    func countryFlagSize(size: CGSize, roundedRadius radius: CGFloat) -> UIImage? {
        UIGraphicsBeginImageContextWithOptions(size, false, UIScreen.main.scale)
        if let currentContext = UIGraphicsGetCurrentContext() {
            let rect = CGRect(origin: .zero, size: size)
            currentContext.addPath(UIBezierPath(roundedRect: rect,byRoundingCorners: .allCorners,cornerRadii: CGSize(width: radius, height: radius)).cgPath)
            currentContext.clip()
            draw(in: rect)
            currentContext.drawPath(using: .fillStroke)
            let roundedCornerImage = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()
            return roundedCornerImage
        }
        return nil
    }
}

extension UIViewController{
    func getCountryCallingCode(countryRegionCode:String)->String{

              let prefixCodes = ["AF": "93", "AE": "971", "AL": "355", "AN": "599", "AS":"1", "AD": "376", "AO": "244", "AI": "1", "AG":"1", "AR": "54","AM": "374", "AW": "297", "AU":"61", "AT": "43","AZ": "994", "BS": "1", "BH":"973", "BF": "226","BI": "257", "BD": "880", "BB": "1", "BY": "375", "BE":"32","BZ": "501", "BJ": "229", "BM": "1", "BT":"975", "BA": "387", "BW": "267", "BR": "55", "BG": "359", "BO": "591", "BL": "590", "BN": "673", "CC": "61", "CD":"243","CI": "225", "KH":"855", "CM": "237", "CA": "1", "CV": "238", "KY":"345", "CF":"236", "CH": "41", "CL": "56", "CN":"86","CX": "61", "CO": "57", "KM": "269", "CG":"242", "CK": "682", "CR": "506", "CU":"53", "CY":"537","CZ": "420", "DE": "49", "DK": "45", "DJ":"253", "DM": "1", "DO": "1", "DZ": "213", "EC": "593", "EG":"20", "ER": "291", "EE":"372","ES": "34", "ET": "251", "FM": "691", "FK": "500", "FO": "298", "FJ": "679", "FI":"358", "FR": "33", "GB":"44", "GF": "594", "GA":"241", "GS": "500", "GM":"220", "GE":"995","GH":"233", "GI": "350", "GQ": "240", "GR": "30", "GG": "44", "GL": "299", "GD":"1", "GP": "590", "GU": "1", "GT": "502", "GN":"224","GW": "245", "GY": "595", "HT": "509", "HR": "385", "HN":"504", "HU": "36", "HK": "852", "IR": "98", "IM": "44", "IL": "972", "IO":"246", "IS": "354", "IN": "91", "ID":"62", "IQ":"964", "IE": "353","IT":"39", "JM":"1", "JP": "81", "JO": "962", "JE":"44", "KP": "850", "KR": "82","KZ":"77", "KE": "254", "KI": "686", "KW": "965", "KG":"996","KN":"1", "LC": "1", "LV": "371", "LB": "961", "LK":"94", "LS": "266", "LR":"231", "LI": "423", "LT": "370", "LU": "352", "LA": "856", "LY":"218", "MO": "853", "MK": "389", "MG":"261", "MW": "265", "MY": "60","MV": "960", "ML":"223", "MT": "356", "MH": "692", "MQ": "596", "MR":"222", "MU": "230", "MX": "52","MC": "377", "MN": "976", "ME": "382", "MP": "1", "MS": "1", "MA":"212", "MM": "95", "MF": "590", "MD":"373", "MZ": "258", "NA":"264", "NR":"674", "NP":"977", "NL": "31","NC": "687", "NZ":"64", "NI": "505", "NE": "227", "NG": "234", "NU":"683", "NF": "672", "NO": "47","OM": "968", "PK": "92", "PM": "508", "PW": "680", "PF": "689", "PA": "507", "PG":"675", "PY": "595", "PE": "51", "PH": "63", "PL":"48", "PN": "872","PT": "351", "PR": "1","PS": "970", "QA": "974", "RO":"40", "RE":"262", "RS": "381", "RU": "7", "RW": "250", "SM": "378", "SA":"966", "SN": "221", "SC": "248", "SL":"232","SG": "65", "SK": "421", "SI": "386", "SB":"677", "SH": "290", "SD": "249", "SR": "597","SZ": "268", "SE":"46", "SV": "503", "ST": "239","SO": "252", "SJ": "47", "SY":"963", "TW": "886", "TZ": "255", "TL": "670", "TD": "235", "TJ": "992", "TH": "66", "TG":"228", "TK": "690", "TO": "676", "TT": "1", "TN":"216","TR": "90", "TM": "993", "TC": "1", "TV":"688", "UG": "256", "UA": "380", "US": "1", "UY": "598","UZ": "998", "VA":"379", "VE":"58", "VN": "84", "VG": "1", "VI": "1","VC":"1", "VU":"678", "WS": "685", "WF": "681", "YE": "967", "YT": "262","ZA": "27" , "ZM": "260", "ZW":"263"]
              let countryDialingCode = prefixCodes[countryRegionCode]
              return countryDialingCode!

      }
}
