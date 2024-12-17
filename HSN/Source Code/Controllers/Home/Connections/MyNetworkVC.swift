//
//  MyNetworkVC.swift
//  HSN
//
//  Created by Prashant Panchal on 04/05/21.
//  Copyright © 2021 Kartikeya. All rights reserved.
//

import UIKit

class MyNetworkVC: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    // @IBOutlet weak var scrollView: UIScrollView!
    // @IBOutlet weak var collectionView: UICollectionView!
    //@IBOutlet weak var constraintTableViewHeight: NSLayoutConstraint!
    //@IBOutlet weak var constraintCollectionViewHeight: NSLayoutConstraint!
    
    var headerSections = ["Manage My Connections","Invitations","Recommendations"]
    var recommendedUsers: [RecommendedUsersModel] = [] {
        didSet{
            self.tableView.reloadData()
        }
    }
    
    var invitations:[InvitationsModel] = [] {
        didSet {
            //self.tableView.reloadSections(IndexSet.init(integer: 0), with: .fade)
            self.tableView.reloadData()
            // DispatchQueue.main.asyncAfter(deadline: .now() + , execute: { [self] in
            //  invitations.isEmpty ? (self.constraintTableViewHeight.constant = 0) : (constraintTableViewHeight.constant = CGFloat(100*invitations.count))
            // })
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //        setStatusBar(color: #colorLiteral(red: 0.1176470588, green: 0.2470588235, blue: 0.4235294118, alpha: 1))
        setStatusBar()
        setupTableCollectionView()
        
        // Do any additional setup after loading the view.
        let refreshControl = UIRefreshControl()
        refreshControl.tintColor = UIColor(named:"5")
        refreshControl.attributedTitle = NSAttributedString(string: "Pull to refresh")
        refreshControl.addTarget(self,
                                 action: #selector(refresh(_:)),
                                 for: .valueChanged)
        tableView.refreshControl = refreshControl
        tableView.delegate = self
        tableView.dataSource = self
        tableView.tableFooterView = UIView()
    }
    
    @objc func refresh(_ sender:UIRefreshControl) {
        fetchData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        fetchData()
    }
    
    //override func viewDidAppear(_ animated: Bool) {
    //        DispatchQueue.main.asyncAfter(deadline: .now() + 0.25, execute: { [self] in
    //            constraintCollectionViewHeight.constant = collectionView.contentSize.height
    //            constraintTableViewHeight.constant = tableView.contentSize.height
    //                //CGFloat((ceil(Float(recommendedUsers.count)/2.0)*239))
    //        })
    //    }
    
    func setupTableCollectionView() {
        tableView.register(UINib(nibName: InvitationTVC.identifier, bundle: nil), forCellReuseIdentifier: InvitationTVC.identifier)
        tableView.register(UINib(nibName: MyConnectionsTVC.identifier, bundle: nil), forCellReuseIdentifier: MyConnectionsTVC.identifier)
        if #available(iOS 15.0, *) {
            tableView.sectionHeaderTopPadding = 0.0
        }
    }
    
    func fetchData() {
        globalApis.getInvitations() { [weak self] (_, received) in
            guard let self = self else { return }
            self.invitations = received
            globalApis.getRecommendedUsers() { [weak self] (users,_) in
                guard let self = self else { return }
                self.recommendedUsers = users
                self.tableView.refreshControl?.endRefreshing()
            }
        }
    }
    
    @IBAction private func buttonSearchTapped(_ sender: Any) {
        guard let vc = UIStoryboard(name: Storyboards.kHome, bundle: nil).instantiateViewController(withIdentifier: HomeSearchVC.getStoryboardID()) as? HomeSearchVC else { return }
        vc.callback = { [weak self] index,user in
            guard let self = self else { return }
            globalApis.getProfile(id: String.getString(user?.id), completion: {  [weak self] data in
                guard let self = self else { return }
                guard let vc = UIStoryboard(name: Storyboards.kHome, bundle: nil).instantiateViewController(withIdentifier: OtherUserProfileVC.getStoryboardID()) as? OtherUserProfileVC else { return }
                vc.data = data
                vc.id = data.id
                vc.hasCameFrom = .viewProfile
                self.navigationController?.pushViewController(vc, animated: true)
                
            })
        }
        vc.modalTransitionStyle = .crossDissolve
        vc.modalPresentationStyle = .overFullScreen
        
        self.navigationController?.present(vc, animated: true)
    }
    
    @IBAction private func buttonViewAllInvitationsTapped(_ sender: Any) {
        guard let vc = UIStoryboard(name: Storyboards.kHome, bundle: nil).instantiateViewController(withIdentifier: InvitationsVC.getStoryboardID()) as? InvitationsVC else { return }
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction private func buttonViewAllRecommendationsTapped(_ sender: Any) {
        guard let vc = UIStoryboard(name: Storyboards.kHome, bundle: nil).instantiateViewController(withIdentifier: DiscoverProfilesVC.getStoryboardID()) as? DiscoverProfilesVC else { return }
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction private func buttonManageConnectionsTapped(_ sender: UIButton) {
        guard let vc = UIStoryboard(name: Storyboards.kHome, bundle: nil).instantiateViewController(withIdentifier: MyConnectionsVC.getStoryboardID()) as? MyConnectionsVC else { return }
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction private func buttonMessageTapped(_ sender: Any) {
        guard let vc = UIStoryboard(name: Storyboards.kChat, bundle: nil).instantiateViewController(withIdentifier: MessagesVC.getStoryboardID()) as? MessagesVC else { return }
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
}

extension MyNetworkVC: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return 0
        case 1:
            return invitations.count
        case 2:
            return 1
        default: return 0
        }
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        switch section {
        case 0:
            return tableView.createHeaderViewSingleBtn(text: "Manage My Connections",withBackgroundColor: false, font: UIFont(name: "Corben-Regular", size: 16)!,completion: { sender in
                guard let vc = UIStoryboard(name: Storyboards.kHome, bundle: nil).instantiateViewController(withIdentifier: MyConnectionsVC.getStoryboardID()) as? MyConnectionsVC else { return }
                self.navigationController?.pushViewController(vc, animated: true)
            })
        case 1:
            //return tableView.createHeaderView(text:"Invitations",color: UIColor(named: "5")!,backgroundColor: #colorLiteral(red: 0.9607843137, green: 0.968627451, blue: 0.9764705882, alpha: 1),font: UIFont(name: "Corben-Regular", size: 16)!)
            return tableView.createHeaderViewBtn(text: "Invitations", btnTitle: "View all", withBackgroundColor: false, color: #colorLiteral(red: 0.9607843137, green: 0.968627451, blue: 0.9764705882, alpha: 1),titleColor: #colorLiteral(red: 0.168627451, green: 0.4705882353, blue: 0.7843137255, alpha: 1),trailing: 0,font: UIFont(name: "SFProDisplay-Bold", size: 16)!,viewBackgroundColor: .white ,completion: { sender in
                guard let vc = UIStoryboard(name: Storyboards.kHome, bundle: nil).instantiateViewController(withIdentifier: InvitationsVC.getStoryboardID()) as? InvitationsVC else { return }
                self.navigationController?.pushViewController(vc, animated: true)
            })
        case 2:
            return tableView.createHeaderViewBtn(text: "Recommendations", btnTitle: "View all", withBackgroundColor: false, color: #colorLiteral(red: 0.9607843137, green: 0.968627451, blue: 0.9764705882, alpha: 1),titleColor: #colorLiteral(red: 0.168627451, green: 0.4705882353, blue: 0.7843137255, alpha: 1),trailing: 0,font: UIFont(name: "SFProDisplay-Bold", size: 16)!,viewBackgroundColor: .white, completion: { sender in
                guard let vc = UIStoryboard(name: Storyboards.kHome, bundle: nil).instantiateViewController(withIdentifier: DiscoverProfilesVC.getStoryboardID()) as? DiscoverProfilesVC else { return }
                self.navigationController?.pushViewController(vc, animated: true)
            })
        default: return UIView()
        }
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        switch section {
        case 0:
            return 50
        case 1:
            return invitations.isEmpty ? 0 : 40
        case 2:
            return 40
        default:
            return 30
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
        case 1:
            let cell = tableView.dequeueReusableCell(withIdentifier: InvitationTVC.identifier, for: indexPath) as! InvitationTVC
            let obj = invitations[indexPath.row]
            cell.updateCell(data: obj)
            cell.acceptCallback = { [weak self] in
                guard let self = self else { return }
                globalApis.acceptConnectionRequest(id: obj.id, completion: { [weak self] in
                    guard let self = self else { return }
                    self.moveToPopUp(text: "Request Accepted Successfully") {
                        globalApis.getInvitations() { [weak self] (_,received) in
                            guard let self = self else { return }
                            self.invitations = received
                        }
                    }
                })
            }
            cell.rejectCallback = { [weak self] in
                guard let self = self else { return }
                globalApis.rejectConnectionRequest(id: obj.id, type: .receiver,completion: { [weak self] in
                    guard let self = self else { return }
                    self.moveToPopUp(text: "Request Rejected Successfully") {
                        globalApis.getInvitations() { [weak self] (_,received) in
                            guard let self = self else { return }
                            self.invitations = received
                        }
                    }
                })
            }
            return cell
        case 2:
            let cell = tableView.dequeueReusableCell(withIdentifier: MyConnectionsTVC.identifier, for: indexPath) as! MyConnectionsTVC
            cell.updateCell(data: recommendedUsers, nav: self.navigationController)
            return cell
        default: return UITableViewCell()
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath.section {
        case 0:
            return UITableView.automaticDimension
        case 1:
            return UITableView.automaticDimension
        case 2:
            if recommendedUsers.indices.contains(indexPath.row) && !recommendedUsers.isEmpty {
                //let label = UILabel()
                let obj = recommendedUsers[indexPath.row]
                var height: CGFloat = 30
                //we are just measuring height so we add a padding constant to give the label some room to breathe!
                let padding: CGFloat = 20
                //estimate each cell's height
                let text = String.getString(obj.full_name).capitalized
                height = estimateFrameForText(text: text).height + padding + 204
                //  204 + label.frame.height
                // width that you want
                let temp = ceil(Float(recommendedUsers.count)/2.0)
                return recommendedUsers.isEmpty ? (UIScreen.main.bounds.height) : CGFloat((temp*Float(height)))
            } else {
                return 275
            }
            //return recommendedUsers.isEmpty ? (200) : CGFloat((ceil(Float(recommendedUsers.count)/2.0)*236.5))
        default:
            return UITableView.automaticDimension
        }
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.section {
        case 1, 2:
            globalApis.getProfile(id: String.getString(self.invitations[indexPath.row].user?.id), completion: { [weak self] fetchedUser in
                guard let self = self else { return }
                guard let vc = UIStoryboard(name: Storyboards.kHome, bundle: nil).instantiateViewController(withIdentifier: OtherUserProfileVC.getStoryboardID()) as? OtherUserProfileVC else { return }
                vc.data = fetchedUser
                vc.id = fetchedUser.id
                vc.hasCameFrom = .viewProfile
                self.navigationController?.pushViewController(vc, animated: true)
            })
        default: return
        }
    }
    
}

extension UITableView {
    
    func createHeaderView(
        text: String,
        color: UIColor = #colorLiteral(red: 0.5176470588, green: 0.5803921569, blue: 0.6784313725, alpha: 1),
        backgroundColor: UIColor = .clear,
        font: UIFont = UIFont(name: "SFProDisplay-Bold", size: 16)!
    ) -> UIView {
        let headerView = UIView(frame: CGRect(x: 0, y: 0, width: self.frame.width, height: 40))
        let labelTitle = UILabel()
        headerView.backgroundColor = backgroundColor
        headerView.addSubview(labelTitle)
        labelTitle.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            labelTitle.centerYAnchor.constraint(equalTo: headerView.centerYAnchor),
            labelTitle.leadingAnchor.constraint(equalTo: headerView.leadingAnchor,constant: 15),
        ])
        labelTitle.text = text
        labelTitle.font = font
        labelTitle.textColor = color
        return headerView
    }
    
    func createHeaderView(text: String, subText: String) -> UIView {
        let headerView = UIView(frame: CGRect(x: 0, y: 0, width: self.frame.width, height: 40))
        let labelTitle = UILabel()
        let labelSubTitle = UILabel()
        
        headerView.backgroundColor = .clear
        headerView.addSubview(labelTitle)
        headerView.addSubview(labelSubTitle)
        labelTitle.translatesAutoresizingMaskIntoConstraints = false
        labelSubTitle.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            labelTitle.centerYAnchor.constraint(equalTo: headerView.centerYAnchor),
            labelTitle.leadingAnchor.constraint(equalTo: headerView.leadingAnchor,constant: 15),
            labelSubTitle.centerYAnchor.constraint(equalTo: headerView.centerYAnchor),
            labelSubTitle.leadingAnchor.constraint(equalTo: labelTitle.trailingAnchor,constant: 10),
        ])
        
        labelTitle.text = text
        labelSubTitle.text = subText
        labelTitle.font = UIFont.SFDisplayMedium(fontSize: 14)
        labelSubTitle.font = UIFont.SFDisplayRegular(fontSize: 12)
        labelTitle.textColor = #colorLiteral(red: 0.1176470588, green: 0.2470588235, blue: 0.4235294118, alpha: 1)
        labelSubTitle.textColor = #colorLiteral(red: 0.5176470588, green: 0.5803921569, blue: 0.6784313725, alpha: 1)
        return headerView
    }
    
    func createHeaderViewBtn(
        text: String,
        btnTitle: String,
        btnIsSelected: Bool = false,
        withBackgroundColor: Bool = true,
        isHidden: Bool = false,
        color: UIColor = .white,
        titleColor: UIColor = UIColor(named: "3")!,
        trailing: Int = 15, font: UIFont = UIFont(name: "SFProDisplay-Bold", size: 16)!,
        viewBackgroundColor: UIColor = .clear,
        completion: @escaping (UIButton) -> ()
    ) -> UIView {
        let headerView = UIView(frame: CGRect(x: 0, y: 0, width: self.frame.width, height: 40))
        let labelTitle = UILabel()
        headerView.backgroundColor = viewBackgroundColor
        let button = ActionButton()
        button.setTitle(btnTitle, for: .normal)
        if withBackgroundColor {
            button.backgroundColor = UIColor(named: "5")
        } else {
            button.backgroundColor = UIColor.clear
            button.setTitleColor(titleColor, for: .normal)
        }
        button.layer.cornerRadius = 25/2
        button.titleLabel?.font = UIFont(name: "SFProDisplay-Medium", size: 14)
        button.isSelected = btnIsSelected
        button.isHidden = isHidden
        button.callback = { completion(button) }
        labelTitle.translatesAutoresizingMaskIntoConstraints = false
        button.translatesAutoresizingMaskIntoConstraints = false
        headerView.addSubview(labelTitle)
        headerView.addSubview(button)
        NSLayoutConstraint.activate([
            labelTitle.centerYAnchor.constraint(equalTo: headerView.centerYAnchor),
            labelTitle.leadingAnchor.constraint(equalTo: headerView.leadingAnchor,constant: 15),
            button.trailingAnchor.constraint(equalTo: headerView.trailingAnchor,constant: CGFloat(trailing)),
            button.centerYAnchor.constraint(equalTo: labelTitle.centerYAnchor),
            button.heightAnchor.constraint(equalToConstant: 25)
        ])
        labelTitle.text = text
        labelTitle.font = font
        labelTitle.textColor = UIColor(named: "5")
        return headerView
    }
    
    func createHeaderViewSingleBtn(
        text: String,
        btnIsSelected: Bool = false,
        withBackgroundColor: Bool = true,
        viewBackroundColor: UIColor = #colorLiteral(red: 0.9607843137, green: 0.968627451, blue: 0.9764705882, alpha: 1),
        isHidden: Bool = false,
        color: UIColor = #colorLiteral(red: 0.168627451, green: 0.4705882353, blue: 0.7843137255, alpha: 1),
        font: UIFont = UIFont(name: "SFProDisplay-Regular", size: 14)!,
        completion: @escaping (UIButton) -> ()) -> UIView {
            let headerView = UIView(frame: CGRect(x: 0, y: 0, width: self.frame.width, height: 40))
            headerView.backgroundColor = .white//viewBackroundColor
            let button = ActionButton()
            button.setTitle(text, for: .normal)
            if withBackgroundColor {
                button.backgroundColor = UIColor(named: "5")
            } else {
                button.backgroundColor = UIColor.clear
                button.setTitleColor(#colorLiteral(red: 0.168627451, green: 0.4705882353, blue: 0.7843137255, alpha: 1), for: .normal)
            }
            button.layer.cornerRadius = 25/2
            button.titleLabel?.font = font
            button.isSelected = btnIsSelected
            button.isHidden = isHidden
            button.callback = {
                completion(button)
            }
            button.translatesAutoresizingMaskIntoConstraints = false
            //button.trailingAnchor.constraint(equalTo: headerView.trailingAnchor,constant: -15)
            headerView.addSubview(button)
            NSLayoutConstraint.activate([
                button.centerYAnchor.constraint(equalTo: headerView.centerYAnchor),
                button.leadingAnchor.constraint(equalTo: headerView.leadingAnchor,constant: -8),
                button.centerYAnchor.constraint(equalTo: headerView.centerYAnchor),
            ])
            return headerView
        }
    
    func createHeaderViewBtnAdd(
        text: String,
        btnTitle: String,
        btnIsSelected: Bool = false,
        viewBackroundColor: UIColor = .white,
        completion: @escaping (UIButton) -> ()
    ) -> UIView {
        let headerView = UIView(frame: CGRect(x: 0, y: 0, width: self.frame.width, height: 40))
        let labelTitle = UILabel()
        headerView.backgroundColor = viewBackroundColor
        let button = ActionButton()
        button.setTitle(btnTitle, for: .normal)
        button.backgroundColor = .clear
        button.setTitleColor(UIColor(named: "3")!, for: .normal)
        button.layer.cornerRadius = 25/2
        button.titleLabel?.font = UIFont(name: "SFProDisplay-Regular", size: 12)
        button.titleEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 14)
        button.setImage(#imageLiteral(resourceName: "add_new_filed"), for:.normal)
        button.semanticContentAttribute = .forceRightToLeft
        button.isSelected = btnIsSelected
        button.callback = {
            completion(button)
        }
        labelTitle.translatesAutoresizingMaskIntoConstraints = false
        button.translatesAutoresizingMaskIntoConstraints = false
        headerView.addSubview(labelTitle)
        headerView.addSubview(button)
        NSLayoutConstraint.activate([
            labelTitle.centerYAnchor.constraint(equalTo: headerView.centerYAnchor),
            labelTitle.leadingAnchor.constraint(equalTo: headerView.leadingAnchor,constant: 15),
            button.trailingAnchor.constraint(equalTo: headerView.trailingAnchor,constant: -5),
            button.centerYAnchor.constraint(equalTo: labelTitle.centerYAnchor),
            button.heightAnchor.constraint(equalToConstant: 25)
        ])
        labelTitle.text = text
        labelTitle.font = UIFont(name: "SFProDisplay-Bold", size: 16)
        labelTitle.textColor = UIColor(named: "5")
        return headerView
    }
    
    //    let headerView = UIView(frame: CGRect(x: 0, y: 0, width: tableView.frame.width, height: 25))
    //    let labelTitle = UILabel(frame: CGRect(x: 15, y: 15, width: headerView.frame.width-15, height: 25))
    //    let xx = data?.is_following ?? false ? 95 : 80
    //    let widthh = data?.is_following ?? false ? 75 : 65
    //    headerView.backgroundColor = .white
    //    let button = UIButton(frame: CGRect(x: Int(headerView.frame.width)-xx, y: 15, width: widthh, height: 25))
    //    button.isSelected = data?.is_following ?? false ? true : false
    //    button.setTitle(followBtnText, for: .normal)
    //    button.backgroundColor = UIColor(named: "5")
    //    button.layer.cornerRadius = 25/2
    //    button.titleLabel?.font = UIFont(name: "SFProDisplay-Medium", size: 14)
    //    button.addTarget(self, action: #selector(followTapped(_:)), for: .touchUpInside)
    //    headerView.addSubview(labelTitle)
    //    headerView.addSubview(button)
    //    labelTitle.text = "Activities"
    //    labelTitle.font = UIFont(name: "SFProDisplay-Bold", size: 16)
    //    labelTitle.textColor = UIColor(named: "5")
    //    return headerView
}

class ActionButton: ResizableButton {
    var callback: (() -> ()) = {}
    var text: String = "sample test"
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.addTarget(self, action: #selector(tapped(_:)), for: .touchUpInside)
        //self.size = self.sizeThatFits(CGSize.zero)
        //self.layoutIfNeeded()
    }
    
    @objc func tapped(_ sender: UIButton) {
        callback()
    }
}

extension UIViewController {
    func moveToPopUp(text: String, completion: @escaping () -> ()) {
        guard let vc = UIStoryboard(name: Storyboards.kHome, bundle: nil).instantiateViewController(withIdentifier: PopUpVC.getStoryboardID()) as? PopUpVC else { return }
        vc.modalTransitionStyle = .crossDissolve
        vc.modalPresentationStyle = .overFullScreen
        vc.popUpDescription = text
        vc.callback = { [weak self] in
            guard let self = self else { return }
            DispatchQueue.main.asyncAfter(deadline: .now() + 3, execute: { [weak self] in
                guard let self = self else { return }
                self.dismiss(animated: true, completion: {
                    completion()
                })
            })
        }
        UIApplication.topViewController()?.navigationController?.present(vc, animated: true)
    }
}
