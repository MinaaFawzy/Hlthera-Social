//
//  InvitationsVC.swift
//  HSN
//
//  Created by Prashant Panchal on 17/05/21.
//  Copyright © 2021 Kartikeya. All rights reserved.
//

import UIKit

class InvitationsVC: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet var navigationViews: [UIView]!
    var selectedTab = 0 {
        didSet{
            switch selectedTab{
            case 0:
                globalApis.getInvitations(){ _,rec in
                    self.data = rec
                }
            case 1:
                globalApis.getInvitations(){ sent,_ in
                    self.data = sent
                    
                }
            default: break
            }
        }
    }
    var data:[InvitationsModel] = [] {
        didSet{
            self.tableView.reloadData()
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigation()
        setStatusBar()//(color: #colorLiteral(red: 0.1176470588, green: 0.2470588235, blue: 0.4235294118, alpha: 1))
        tableView.register(UINib(nibName: InvitationTVC.identifier, bundle: nil), forCellReuseIdentifier: InvitationTVC.identifier)
        globalApis.getInvitations(){ _,rec in
            self.data = rec
        }
        // Do any additional setup after loading the view.
    }
    
    func setupNavigation(selectedIndex:Int = 0){
   
        for (index,view) in self.navigationViews.enumerated(){
            for btn in view.subviews{
                if let button  = btn as? UIButton{
                    button.setTitleColor(selectedIndex == index ? (#colorLiteral(red: 0.1512879729, green: 0.3206651807, blue: 0.4994546771, alpha: 1)) : (#colorLiteral(red: 0.5176470588, green: 0.5803921569, blue: 0.6784313725, alpha: 1)), for: .normal)
                  //  button.titleLabel?.font = selectedIndex == index ? (UIFont(name: "SFProDisplay-Medium", size: 16)) : (UIFont(name: "SFProDisplay-Regular", size: 16))
                    button.adjustsImageWhenDisabled = false
                    button.adjustsImageWhenHighlighted = false
                }
                
                else{
                    btn.isHidden = index == selectedIndex ? (false) : (true)
                    btn.backgroundColor = index == selectedIndex ? (#colorLiteral(red: 0.1512879729, green: 0.3206651807, blue: 0.4994546771, alpha: 1)) : (#colorLiteral(red: 0.5176470588, green: 0.5803921569, blue: 0.6784313725, alpha: 1))
                    
                }
            }
        }
    }
    @IBAction func buttonBackTapped(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    @IBAction func buttonsNavigationTapped(_ sender: UIButton) {
        setupNavigation(selectedIndex: sender.tag)
        self.selectedTab = sender.tag
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
extension InvitationsVC:UITableViewDelegate,UITableViewDataSource{
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return tableView.createHeaderView(text: "\(data.count) Request")
        
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 30
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tableView.numberOfRow(numberofRow:data.count)
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: InvitationTVC.identifier, for: indexPath) as! InvitationTVC
        
        let obj = data[indexPath.row]
        cell.updateCell(data: obj)
        
        if selectedTab == 0{
            cell.buttonAccept.isHidden = false
            cell.acceptCallback = {
                globalApis.acceptConnectionRequest(id: obj.recipient_id, completion: {
                    self.moveToPopUp(text: "Request Accepted Successfully"){
                        globalApis.getInvitations(){ _,received in
                            self.data = received
                        }
                    }
                    
                })
            }
            cell.rejectCallback = {
                globalApis.rejectConnectionRequest(id: obj.id, type: .receiver,completion: {
                    self.moveToPopUp(text: "Request Rejected Successfully"){
                        globalApis.getInvitations(){ _,received in
                            self.data = received
                        }
                    }
                    
                })
            }
        }else{
            cell.buttonAccept.isHidden = true
            cell.rejectCallback = {
                globalApis.rejectConnectionRequest(id: obj.id, type: .sender,completion: {
                    self.moveToPopUp(text: "Request Rejected Successfully"){
                        globalApis.getInvitations(){ sent,_ in
                            self.data = sent
                        }
                    }
                    
                })
            }
        }
        
        
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        globalApis.getProfile(id: String.getString(self.data[indexPath.row].user?.id), completion: {user in
            guard let vc = UIStoryboard(name: Storyboards.kHome, bundle: nil).instantiateViewController(withIdentifier: OtherUserProfileVC.getStoryboardID()) as? OtherUserProfileVC else { return }
            vc.data = user
            vc.id = user.id
            vc.hasCameFrom = .viewProfile
            self.navigationController?.pushViewController(vc, animated: true)
        })
    }
    
    
}
