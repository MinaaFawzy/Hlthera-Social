//
//  AddProductsLifeVC.swift
//  HSN
//
//  Created by Prashant Panchal on 30/11/21.
//  Copyright © 2021 Kartikeya. All rights reserved.
//

import UIKit

class AddProductsLifeVC: UIViewController {
    @IBOutlet weak var labelPageTitle: UILabel!
    @IBOutlet weak var labelPageDescription: UILabel!
    @IBOutlet weak var imageDescription: UIImageView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var buttonAddProduct: UIButton!
    @IBOutlet weak var viewNoDataFound: UIView!
    var pageId = ""
    var hasCameFrom:HasCameFrom = .none
    var products:[PageProductModel] = []
    var lifes:[PageLifeModel] = []
    var jobs:[JobModel] = []
    override func viewDidLoad() {
        tableView.register(LifeProductsListTVC.nib, forCellReuseIdentifier: LifeProductsListTVC.identifier)
        tableView.delegate = self
        tableView.dataSource = self
        setStatusBar()//color: #colorLiteral(red: 0.1176470588, green: 0.2470588235, blue: 0.4235294118, alpha: 1))
        super.viewDidLoad()
        switch hasCameFrom{
        case .addLife:
            self.labelPageTitle.text = "Add Life"
            self.labelPageDescription.text = "Add Life Events"
            self.imageDescription.image = UIImage(named: "Group 104739")
            self.buttonAddProduct.setTitle("Add Life", for: .normal)
        
        case .addProduct:
            self.labelPageTitle.text = "Add Products"
            self.labelPageDescription.text = "Add Your Products"
            self.imageDescription.image = UIImage(named: "undraw_add_to_cart_re_wrdo")
            self.buttonAddProduct.setTitle("Add Product", for: .normal)
            
        case .createJob:
            self.labelPageTitle.text = "Jobs"
            self.labelPageDescription.text = "Add Jobs"
            self.imageDescription.image = UIImage(named: "undraw_add_to_cart_re_wrdo")
            self.buttonAddProduct.setTitle("Add Job", for: .normal)
        
        default:break
        }
        

        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
        var type:PageMediaType = .lifeMedia
        switch hasCameFrom{
        case .addLife:
            type = .lifeMedia
        case .addProduct:
            type = .productMedia
        case .createJob:
            type = .jobMedia
        default:
            break
        }
        
        globalApis.getPageProductsLife(type:type,pageId:self.pageId , completion: { product,life,jobs in
            self.products = product
            self.lifes = life
            self.jobs = jobs
            self.tableView.reloadData()
            if  self.hasCameFrom == .addLife{
                if self.lifes.isEmpty{
                    self.tableView.isHidden = true
                }
                else{
                    self.tableView.isHidden = false
                }
            }
            else if self.hasCameFrom == .addProduct{
                if self.products.isEmpty{
                    self.tableView.isHidden = true
                }
                else{
                    self.tableView.isHidden = false
                }
            }
            else if self.hasCameFrom == .createJob{
                if self.jobs.isEmpty{
                    self.tableView.isHidden = true
                }
                else{
                    self.tableView.isHidden = false
                }
            }
            
            
        })
    }
    
    @IBAction func buttonBackTapped(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    @IBAction func buttonAddTapped(_ sender: Any) {
        switch hasCameFrom{
        case .addLife:
            guard let vc = UIStoryboard(name: Storyboards.kPages, bundle: nil).instantiateViewController(withIdentifier: AddPageLifeVC.getStoryboardID()) as? AddPageLifeVC else { return }
            vc.hasCameFrom = .addLife
            vc.pageId = self.pageId
            self.navigationController?.pushViewController(vc, animated: true)
        case .addProduct:
            guard let vc = UIStoryboard(name: Storyboards.kPages, bundle: nil).instantiateViewController(withIdentifier: AddPageProductVC.getStoryboardID()) as? AddPageProductVC else { return }
           // vc.hasCameFrom = .addProduct
            vc.pageId = self.pageId
            self.navigationController?.pushViewController(vc, animated: true)
        case .createJob:
            guard let vc = UIStoryboard(name: Storyboards.kJobs, bundle: nil).instantiateViewController(withIdentifier: CreateJobVC.getStoryboardID()) as? CreateJobVC else { return }
           // vc.hasCameFrom = .addProduct
            vc.pageId = self.pageId
            
            self.navigationController?.pushViewController(vc, animated: true)
        default:break
        }
        
        
    }
    @IBAction func btnSkipTapped(_ sender: Any) {
        switch hasCameFrom{
        case .addLife:
            guard let vc = UIStoryboard(name: Storyboards.kPages, bundle: nil).instantiateViewController(withIdentifier: AddProductsLifeVC.getStoryboardID()) as? AddProductsLifeVC else { return }
            vc.hasCameFrom = .createJob
            vc.pageId = self.pageId
            self.navigationController?.pushViewController(vc, animated: true)
        case .addProduct:
            guard let vc = UIStoryboard(name: Storyboards.kPages, bundle: nil).instantiateViewController(withIdentifier: AddProductsLifeVC.getStoryboardID()) as? AddProductsLifeVC else { return }
            vc.hasCameFrom = .addLife
            vc.pageId = self.pageId
            self.navigationController?.pushViewController(vc, animated: true)
        case .createJob:
            guard let vc = UIStoryboard(name: Storyboards.kHome, bundle: nil).instantiateViewController(withIdentifier: EventListingVC.getStoryboardID()) as? EventListingVC else { return }
            vc.hasCameFrom = .viewCompanyEvent
            vc.pageId = self.pageId
            self.navigationController?.pushViewController(vc, animated: true)
        default:break
        }
        
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
extension AddProductsLifeVC:UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if hasCameFrom == .addLife{
            lifes.isEmpty ? (viewNoDataFound.isHidden = false) : (viewNoDataFound.isHidden = true)
            lifes.isEmpty ? (self.tableView.isHidden = true) : (self.tableView.isHidden = false)
            
            return lifes.count
        }
        else if hasCameFrom == .addProduct{
            products.isEmpty ? (viewNoDataFound.isHidden = false) : (viewNoDataFound.isHidden = true)
            products.isEmpty ? (self.tableView.isHidden = true) : (self.tableView.isHidden = false)
            return products.count
            
        }
        else {
            jobs.isEmpty ? (viewNoDataFound.isHidden = false) : (viewNoDataFound.isHidden = true)
            jobs.isEmpty ? (self.tableView.isHidden = true) : (self.tableView.isHidden = false)
            return jobs.count
            
        }
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: LifeProductsListTVC.identifier, for: indexPath) as! LifeProductsListTVC
        
        if hasCameFrom == .addLife{
            let obj = lifes[indexPath.row]
            cell.labelName.text = obj.view_name
            cell.editCallback = {
                guard let vc = UIStoryboard(name: Storyboards.kPages, bundle: nil).instantiateViewController(withIdentifier: AddPageLifeVC.getStoryboardID()) as? AddPageLifeVC else { return }
                vc.hasCameFrom = .editLife
                vc.pageId = self.pageId
                vc.data = obj
                self.navigationController?.pushViewController(vc, animated: true)
            }
        }
        else if hasCameFrom == .addProduct{
            let obj = products[indexPath.row]
            cell.labelName.text = obj.product_name
            cell.editCallback = {
                guard let vc = UIStoryboard(name: Storyboards.kPages, bundle: nil).instantiateViewController(withIdentifier: AddPageProductVC.getStoryboardID()) as? AddPageProductVC else { return }
                vc.hasCameFrom = .editProduct
                vc.pageId = self.pageId
                vc.data = obj
                self.navigationController?.pushViewController(vc, animated: true)
            }
        }
        else{
            let obj = jobs[indexPath.row]
            cell.labelName.text = obj.job_title
            cell.editCallback = {
                guard let vc = UIStoryboard(name: Storyboards.kJobs, bundle: nil).instantiateViewController(withIdentifier: CreateJobVC.getStoryboardID()) as? CreateJobVC else { return }
                vc.hasCameFrom = .editJob
                vc.pageId = self.pageId
                vc.data = obj
                self.navigationController?.pushViewController(vc, animated: true)
            }
        }
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath)
            -> UISwipeActionsConfiguration? {
                
                    let deleteAction = UIContextualAction(style: .destructive, title: nil) { (_, _, completionHandler) in
                        
                        var type:PageMediaType = .lifeMedia
                        switch self.hasCameFrom{
                        case .addLife:
                            type = .lifeMedia
                        case .addProduct:
                            type = .productMedia
                        case .createJob:
                            type = .jobMedia
                        default:
                            break
                        }
                        
                        globalApis.deletePageLifeOrProduct(type:type ,id: self.hasCameFrom == .addLife ? (self.lifes[indexPath.row].id) : (self.products[indexPath.row].id), completion: {
                            if self.hasCameFrom == .addLife {
                                self.lifes.remove(at: indexPath.row)
                            }else if self.hasCameFrom == .addProduct{
                                self.products.remove(at: indexPath.row)
                            }
                            else{
                                self.jobs.remove(at: indexPath.row)
                            }
                             
                            self.tableView.reloadData()
                        })
                        
                        
                    }
                    deleteAction.image = #imageLiteral(resourceName: "delete_white")
                    deleteAction.backgroundColor = .red
                
                    let configuration = UISwipeActionsConfiguration(actions: [deleteAction])

                    return configuration
                
                    
                
    }

    
    func tableView(_ tableView: UITableView, willBeginEditingRowAt indexPath: IndexPath) {
       // let cell = tableView.cellForRow(at: indexPath) as! HomeSearchTVC
       // cell.viewBG.isHidden = false
        let mainView = tableView.subviews.filter{String(describing:Swift.type(of: $0)) == "_UITableViewCellSwipeContainerView"}
        if !mainView.isEmpty{
            let backgroundView = mainView[0].subviews
            if !backgroundView.isEmpty{
                backgroundView[0].frame = CGRect(x: 0, y: 5, width: mainView[0].frame.width, height: mainView[0].frame.height-10)
                backgroundView[0].layoutIfNeeded()
            }
        }
        
        }
    
    
}
