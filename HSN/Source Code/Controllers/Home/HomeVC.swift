//
//  HomeVC.swift
//  HSN
//
//  Created by Prashant Panchal on 04/05/21.
//  Copyright © 2021 Kartikeya. All rights reserved.
//

import UIKit
import Kingfisher
import AVKit
import FittedSheets

var navv: UINavigationController?
fileprivate let isClearCacheEnabled = true
var isDeleteSnapEnabled = false

class HomeVC: UIViewController {
    
    // MARK: - Outelts
    @IBOutlet weak private var viewHeader: UIView!
    @IBOutlet weak var tableViewFeed: UITableView!
    @IBOutlet weak private var constraintViewHeaderTop: NSLayoutConstraint!
    
    // MARK: - Stored Properties
    let spinner = UIActivityIndicatorView(style: .medium)
    var session = URLSession.shared
    var apiStories: [IGStories] = []
    var homeFeed: [HomeFeedModel] = []
    var homeFeedImages: [HomeFeedModel] = []
    var thumbnails: [UIImage] = []
    //var data: IGStories?
    var lastPage = 0
    var firstPage = 0
    var currentPage = 1
    var isLoadingList = false
    var totalPost = 0
    var selectedPostType = ""
    var tabBarImageDelegate: ShareImageDelegate?
    var storyView: StoriesHeaderView?
    var exploreView: ExploreHeaderView?
    var loungeView: LoungeHeaderView?
    var headerView: HomeHeaderView?
    var selectedPost = -1
    var viewWillLoadedConstant: CGFloat = 40 // if loaded then set 40 otherwise 0
    var unreadNotify = 0
    var newNotifications: [NotificationModel] = [] {
        didSet {
            if let tabItems = tabBarController?.tabBar.items {
                let tabItem = tabItems[3]
                if self.unreadNotify > 0  {
//                    tabItem.badgeValue = String.getString(self.unreadNotify)
                    tabItem.badgeValue = ""
                } else {
                    tabItem.badgeValue = nil
                }
            }
        }
    }
    //MARK: - iVars
    private var _view: IGHomeView{return view as! IGHomeView}
    // private var viewModel: IGHomeViewModel = IGHomeViewModel()
    
    override var navigationItem: UINavigationItem {
        let navigationItem = UINavigationItem()
        navigationItem.titleView = UIImageView(image: UIImage(named: "icInstaLogo"))
        if isClearCacheEnabled {
            navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Clear Cache", style: .done, target: self, action: #selector(clearImageCache))
            navigationItem.rightBarButtonItem?.tintColor = UIColor(red: 203.0/255, green: 69.0/255, blue: 168.0/255, alpha: 1.0)
        }
        navigationItem.rightBarButtonItem?.tintColor = UIColor(red: 203.0/255, green: 69.0/255, blue: 168.0/255, alpha: 1.0)
        return navigationItem
    }
    
    // MARK: - Private functions
    @objc private func clearImageCache() {
        IGCache.shared.removeAllObjects()
        IGStories.removeAllVideoFilesFromCache()
        showAlert(withMsg: "Images & Videos are deleted from cache")
    }
    
    private func showAlert(withMsg: String) {
        let alertController = UIAlertController(title: withMsg, message: nil, preferredStyle: .alert)
        present(alertController, animated: true) {
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.5) {
                alertController.dismiss(animated: true, completion: nil)
            }
        }
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .darkContent
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewHeader.layer.maskedCorners = [.layerMinXMaxYCorner,.layerMaxXMaxYCorner]
        viewHeader.layer.cornerRadius = 15
        self.tabBarController?.delegate = self
        setStatusBar(color: UIColor(named: "Card Background Color")!)
        statusBarStyleColor()
        setupCells()
        setupStories()
        getExploreOptions()
        getNotificationData()
        
        self.tableViewFeed.sectionHeaderHeight = UITableView.automaticDimension;
        self.tableViewFeed.estimatedSectionHeaderHeight = 25;
        if self.tabBarController?.isKind(of: JBTabBarController.self) ?? false{
            let vc = self.tabBarController as! JBTabBarController
            self.tabBarImageDelegate = vc
        }
        self.tabBarImageDelegate?.updateNotificationIcon(status: false)
        
        //guard let headerView = tableViewFeed.tableHeaderView else {return}
        //let size = headerView.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize)
        //if headerView.frame.size.height != size.height {
        //headerView.frame.size.height = size.height
        //tableViewFeed.tableHeaderView = headerView
        //tableViewFeed.layoutIfNeeded()
        //}
        
        // add these because view will appear is not calling
        //HealthKitInterface()
        navv = self.navigationController
        self.storyView?.storiesCollectionView.reloadData()
        updateData()
        /*var path: UIBezierPath = UIBezierPath()
         path.move(to: CGPoint.init(x: 32.41, y: 0.0))
         path.addLine(to: CGPoint.init(x: 32.41, y: 600.0))
         
         // Create a CAShape Layer
         var pathLayer: CAShapeLayer = CAShapeLayer()
         pathLayer.frame = self.view.bounds
         pathLayer.path = path.cgPath
         pathLayer.strokeColor = UIColor.red.cgColor
         pathLayer.fillColor = nil
         pathLayer.lineWidth = 2.0
         pathLayer.lineJoin = CAShapeLayerLineJoin.bevel
         
         // Add layer to views layer
         self.tableViewFeed.layer.addSublayer(pathLayer)
         
         // Basic Animation
         var pathAnimation: CABasicAnimation = CABasicAnimation(keyPath: "strokeEnd")
         pathAnimation.duration = 2.0
         pathAnimation.fromValue = NSNumber(value: 0.0)
         pathAnimation.toValue = NSNumber(value:1.0)
         
         // Add Animation
         pathLayer.add(pathAnimation, forKey: "strokeEnd")*/
    }
    
    override func viewWillAppear(_ animated: Bool) {
        viewWillLoadedConstant = 0
        constraintViewHeaderTop.constant = viewWillLoadedConstant
        //HealthKitInterface()
        navv = self.navigationController
        self.storyView?.storiesCollectionView.reloadData()
        updateData()
        getNotificationData()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        loungeView?.removeObservers()
    }
    
    func getHeaderForHome() -> HomeHeaderView {
        return UINib(nibName: "HomeHeaderView", bundle: nil).instantiate(withOwner: self, options: nil)[0] as! HomeHeaderView
    }
    
    func getHeaderForStory() -> StoriesHeaderView {
        return UINib(nibName: "StoriesHeaderView", bundle: nil).instantiate(withOwner: self, options: nil)[0] as! StoriesHeaderView
    }
    
    func getHeaderForExplore() -> ExploreHeaderView {
        return UINib(nibName: "ExploreHeaderView", bundle: nil).instantiate(withOwner: self, options: nil)[0] as! ExploreHeaderView
    }
    
    func getHeaderForLounge() -> LoungeHeaderView {
        return UINib(nibName: "LoungeHeaderView", bundle: nil).instantiate(withOwner: self, options: nil)[0] as! LoungeHeaderView
    }
    func getNotificationData() {
        globalApis.getAllNotifications(page: 1, completion: { [weak self] new, old, newLastPage, newTotal, oldLastPage, oldTotal in
            guard let self = self else { return }
            self.unreadNotify = 0
            for item in new {
                if !item.is_read {
                    self.unreadNotify += 1
                }
            }
            self.newNotifications = new
            })
    }
    
    //override func viewDidAppear(_ animated: Bool) {
    //    HealthKitInterface()
    //    navv = self.navigationController
    //    self.storyView?.storiesCollectionView.reloadData()
    //    updateData()
    //   // tableViewFeed.refreshControl?.didMoveToSuperview()
    //}
    
    func setupCells() {
        spinner.frame = CGRect(x: CGFloat(0), y: CGFloat(0), width: tableViewFeed.bounds.width, height: CGFloat(44))
        tableViewFeed.register(UINib(nibName: DocumentVC.identifier, bundle: nil), forCellReuseIdentifier: DocumentVC.identifier)
        tableViewFeed.register(UINib(nibName: TextMediaPostTVC.identifier, bundle: nil), forCellReuseIdentifier: TextMediaPostTVC.identifier)
        tableViewFeed.register(UINib(nibName: PollPostTVC.identifier, bundle: nil), forCellReuseIdentifier: PollPostTVC.identifier)
        tableViewFeed.register(UINib(nibName: SharePostTVC.identifier, bundle: nil), forCellReuseIdentifier: SharePostTVC.identifier)
        tableViewFeed.register(UINib(nibName: SharePostTextMediaTVC.identifier, bundle: nil), forCellReuseIdentifier: SharePostTextMediaTVC.identifier)
        tableViewFeed.register(UINib(nibName: SharePostPollTVC.identifier, bundle: nil), forCellReuseIdentifier: SharePostPollTVC.identifier)
        tableViewFeed.register(UINib(nibName: FindExpertTVC.identifier, bundle: nil), forCellReuseIdentifier: FindExpertTVC.identifier)
        tableViewFeed.showActivityIndicator()
        if #available(iOS 15.0, *) {
            tableViewFeed.sectionHeaderTopPadding = 0.0
        } else {
            // Fallback on earlier versions
        }
        let refreshControl = UIRefreshControl()
        refreshControl.tintColor = UIColor(named: "5")
        refreshControl.attributedTitle = NSAttributedString(string: "Pull to refresh")
        refreshControl.addTarget(self,
                                 action: #selector(refresh(_:)),
                                 for: .valueChanged)
        tableViewFeed.refreshControl = refreshControl
        tableViewFeed.prefetchDataSource = self
    }
    
    @objc func refresh(_ sender: UIRefreshControl) {
        updateData()
    }
    
    func setupStories() {
        // view = IGHomeView(frame: UIScreen.main.bounds)
        self.headerView = getHeaderForHome()
        self.headerView?.updateData(vc: self)
        self.storyView = getHeaderForStory()
        //self.storyView?.updateData(stories: self.)
        self.storyView?.runTimer()
        self.exploreView = getHeaderForExplore()
        self.exploreView?.updateData(data: [],nav: self.navigationController ?? UINavigationController())
        self.exploreView?.callback = { [weak self] postType in
            guard let self = self else { return }
            self.selectedPostType = postType
            self.updateData()
        }
        self.loungeView = getHeaderForLounge()
        self.loungeView?.ViewAllBtnCallBack = {
            guard let vc = UIStoryboard(name: Storyboards.kLounge, bundle: nil).instantiateViewController(withIdentifier: LoungeVC.getStoryboardID()) as? LoungeVC else { return }
//            vc.isViewAll = true
            self.navigationController?.pushViewController(vc, animated: true)
        }
        self.loungeView?.joinBtnCallBack = { [weak self] obj in
            if kSharedAppDelegate?.viewToShow.isHidden == true {
                if obj.id == UserData.shared.id{
                    
                    let storyBoard = UIStoryboard(name: Storyboards.kLounge, bundle: nil)
                    let vc = storyBoard.instantiateViewController(withIdentifier: LoungeSendInvitationVC.getStoryboardID()) as! LoungeSendInvitationVC
                    
                    self?.navigationController?.present(vc, animated: true)
                }
                else{
                    
                    let storyBoard = UIStoryboard(name: Storyboards.kLounge, bundle: nil)
                    let optionsSheetVC = storyBoard.instantiateViewController(withIdentifier: AudioRoomVC.getStoryboardID()) as! AudioRoomVC
                    if let vc = optionsSheetVC as? AudioRoomVC{
                        vc.roomId = obj.roomId
                        vc.anonymousState = obj.anonymousState
                    }
                    let options = SheetOptions(
                        pullBarHeight: 50, presentingViewCornerRadius: 20, shouldExtendBackground: true, shrinkPresentingViewController: true, useInlineMode: false
                    )
                    
                    let sheetController = SheetViewController(controller: optionsSheetVC, sizes: [.marginFromTop(100)], options: options)
                    sheetController.allowGestureThroughOverlay = false
                    sheetController.overlayColor =  #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0.7475818452)
                    sheetController.minimumSpaceAbovePullBar = 0
                    sheetController.treatPullBarAsClear = false
                    sheetController.autoAdjustToKeyboard = false
                    sheetController.dismissOnOverlayTap = true
                    
                    
                    // Disable the ability to pull down to dismiss the modal
                    sheetController.dismissOnPull = true
                    // sheetController?.animateIn(to: self.parent?.view ?? UIView(), in: parent ?? UIViewController())
                    self?.navigationController?.present(sheetController, animated: false, completion: nil)
                }
            } else {
                CommonUtils.showToast(message: "You are already in lounge ")
            }
        }
        self.updateData()
        //self.loungeView?.callback = { postType in }
        self.tableViewFeed.reloadData()
    }
    
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        
        if(velocity.y>0) {
            //Code will work without the animation block.I am using animation block incase if you want to set any delay to it.
            UIView.animate(withDuration: 2.5, delay: 0, options: UIView.AnimationOptions(), animations: {
                // self.navigationController?.setNavigationBarHidden(true, animated: true)
                // self.navigationController?.setToolbarHidden(true, animated: true)
                
            }, completion: nil)
            
        } else {
            UIView.animate(withDuration: 2.5, delay: 0, options: UIView.AnimationOptions(), animations: {
                //  self.navigationController?.setNavigationBarHidden(false, animated: true)
                //  self.navigationController?.setToolbarHidden(false, animated: true)
                
            }, completion: nil)
        }
    }
    
    func updateData() {
        homeFeed = []
        currentPage = 1
        getHomeFeedTemp(page: 1)
        loungeView?.updateData(data: [],nav: self.navigationController ?? UINavigationController())
    }
    
    @IBAction private func buttonSearchTapped(_ sender: Any) {
        guard let vc = UIStoryboard(name: Storyboards.kHome, bundle: nil).instantiateViewController(withIdentifier: HomeSearchVC.getStoryboardID()) as? HomeSearchVC else { return }
        
        vc.callback = { index,user in
            if user?.is_company ?? false{
                globalApis.getCompanyProfile(id: String.getString(user?.company_id), completion: { data in
                    guard let vc = UIStoryboard(name: Storyboards.kPages, bundle: nil).instantiateViewController(withIdentifier: ViewPageVC.getStoryboardID()) as? ViewPageVC else { return }
                    vc.data = data
                    vc.pageId = data.id
                    self.navigationController?.pushViewController(vc, animated: true)
                })
            } else {
                globalApis.getProfile(id: String.getString(user?.id), completion: { data in
                    guard let vc = UIStoryboard(name: Storyboards.kHome, bundle: nil).instantiateViewController(withIdentifier: OtherUserProfileVC.getStoryboardID()) as? OtherUserProfileVC else { return }
                    vc.data = data
                    vc.id = data.id
                    vc.hasCameFrom = .viewProfile
                    self.navigationController?.pushViewController(vc, animated: true)
                    
                })
            }
        }
        
        vc.modalTransitionStyle = .crossDissolve
        vc.modalPresentationStyle = .overFullScreen
        self.navigationController?.present(vc, animated: true)
    }
    
    @IBAction func buttonMessageTapped(_ sender: Any) {
        guard let vc = UIStoryboard(name: Storyboards.kChat, bundle: nil).instantiateViewController(withIdentifier: MessagesVC.getStoryboardID()) as? MessagesVC else { return }
        //guard let vc = UIStoryboard(name: Storyboards.kMain, bundle: nil).instantiateViewController(withIdentifier: LocationViewController.getStoryboardID()) as? LocationViewController else { return }
        self.navigationController?.pushViewController(vc, animated: true)
    }
}

extension UITableView {
    func showActivityIndicator() {
        DispatchQueue.main.async {
            let activityView = UIActivityIndicatorView(style: .medium)
            self.backgroundView = activityView
            activityView.startAnimating()
        }
    }
    
    func hideActivityIndicator() {
        DispatchQueue.main.async {
            self.backgroundView = nil
        }
    }
}

//MARK: - Tableview func
extension HomeVC: UITableViewDelegate, UITableViewDataSource, UITableViewDataSourcePrefetching {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        switch section {
            //case 0:
            //return self.headerView
        case 0:
            return self.storyView
        case 1:
            return self.loungeView
        case 2:
            return self.exploreView
        default:
            return UIView()
        }
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 2:
            return homeFeed.count
        default:
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
        case 2:
            if homeFeed.indices.contains(indexPath.row) {
                let obj = homeFeed[indexPath.row]
                let cell = tableView.dequeueReusableCell(withIdentifier: TextMediaPostTVC.identifier, for: indexPath) as! TextMediaPostTVC
                cell.parent = self
                cell.isPostFromHome = true
                cell.configure(type: .homeFeed, on: self, data: obj)
                return cell
            } else {
                return UITableViewCell()
            }
        default: return UITableViewCell()
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.section {
        case 2:
            let cell = tableView.cellForRow(at: indexPath) as! TextMediaPostTVC
            cell.didSelectRow() { [weak self] in
                guard let self = self else { return }
                guard let vc = UIStoryboard(name: Storyboards.kHome, bundle: nil).instantiateViewController(withIdentifier: ViewPostVC.getStoryboardID()) as? ViewPostVC else { return }
                self.selectedPost = indexPath.row
                vc.data = homeFeed[indexPath.row]
                vc.modalPresentationStyle = .fullScreen
                UIApplication.topViewController?.present(vc, animated: true)
            }
        default: break
        }
    }
    
    func tableView(_ tableView: UITableView, prefetchRowsAt indexPaths: [IndexPath]) {
        for indexPath in indexPaths {
            if !homeFeed.isEmpty{
                self.homeFeed[indexPath.row].downloadData()
            }
        }
    }
    
    //func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
    //        DispatchQueue.main.async {
    //            let lastRowIndex = tableView.numberOfRows(inSection: 2) - 1
    //            if indexPath.section ==  2 && indexPath.row == lastRowIndex {
    //                self.spinner.startAnimating()
    //                self.tableViewFeed.tableFooterView = self.spinner
    //                self.tableViewFeed.tableFooterView?.isHidden = false
    //
    //            }
    //            else{
    //                self.spinner.stopAnimating()
    //                self.tableViewFeed.tableFooterView = nil
    //                self.tableViewFeed.tableFooterView?.isHidden = true
    //            }
    //        }
    //    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView == tableViewFeed{
            let yOffset = (scrollView.contentOffset.y)
            _ = scrollView.contentSize.height
            // let heightHeader = min(max(yOffset, 125), 800)
            
            if yOffset <= 0.0 {
                //viewHeader.isHidden = false
                constraintViewHeaderTop.constant = CGFloat(viewWillLoadedConstant)
            } else {
                if UIDevice().name == "iPhone SE (3rd generation)" {
                    constraintViewHeaderTop.constant = max(-yOffset,-95)
                } else {
                    constraintViewHeaderTop.constant = max(-yOffset,-70)
                }
                //viewHeader.isHidden = true
            }
            
            if (((scrollView.contentOffset.y + scrollView.frame.size.height + 50) > scrollView.contentSize.height && !isLoadingList)) {
                //  if (yOffset > contentHeight - scrollView.frame.height && !isLoadingList){
                if self.homeFeed.count < self.totalPost {
                    self.isLoadingList = true
                    self.currentPage = self.currentPage+1
                    self.getHomeFeedTemp(page: self.currentPage)
                }
            }
            //            if (((tableViewFeed.contentSize.height - tableViewFeed.frame.size.height) <= tableViewFeed.contentOffset.y && !isLoadingList)){
            //                if self.homeFeed.count < self.totalPost {
            //                    self.isLoadingList = true
            //                    self.currentPage = self.currentPage+1
            //                    self.getHomeFeed(page: self.currentPage)
            //                }
            //            }
        }
    }
}

// MARK: - Network Calls
extension HomeVC {
    
    func getStories() {
//        CommonUtils().isLoading(true)
        CommonUtils.showHudWithNoInteraction(show: true)
        let params: [String: Any] = [:]
        TANetworkManager.sharedInstance.requestApi(
            withServiceName: ServiceName.stories,
            requestMethod: .GET,
            requestParameters: params,
            withProgressHUD: false
        ) {
            [weak self] (result: Any?, error: Error?, errorType: ErrorType, statusCode: Int?) in
            guard let self = self else { return }
            if errorType == .requestSuccess {
                
                let dictResult = kSharedInstance.getDictionary(result)
                switch Int.getInt(statusCode) {
                case 200:
                    kBucketUrl = String.getString(dictResult["base_url"])
                    print(dictResult)
                    self.apiStories = []
                    //let da = try? IGMockLoader.loadAPIResponse(response: dictResult)
                    let data = try? IGMockLoader.loadAPIResponse(response: dictResult)
                    //let data = try? IGMockLoader.loadAPIResponseTest(response: dictResult)
//                    CommonUtils.showHudWithNoInteraction(show: false)
//                    CommonUtils().isLoading(false)
                    self.storyView?.updateData(stories: data, nav: self.navigationController)
                    self.storyView?.storiesCollectionView.reloadData()
                    self.tabBarImageDelegate?.shareImage(image: UserData.shared.profile_pic)
                    //self.downlodeImage(serviceurl: kBASEURL+String.getString(UserData.shared.profile_pic), placeHolder: #imageLiteral(resourceName: "profile_placeholder"), completion: { image in
                    //})
                default:
//                    CommonUtils.showHudWithNoInteraction(show: false)
//                    CommonUtils().isLoading(false)
                    showAlertMessage.alert(message: String.getString(dictResult["message"]))
                }
            } else if errorType == .noNetwork {
                showAlertMessage.alert(message: AlertMessage.kNoInternet)
            } else {
                showAlertMessage.alert(message: AlertMessage.kDefaultError)
            }
        }
    }
    
    func getRequest(page: Int) -> URLRequest {
        var url = ""
        let limit = 20
        if selectedPostType.isEmpty || selectedPostType == "" {
            url =  ServiceName.homePost+"?page=\(page)&limit=\(limit)"
        } else {
            url = ServiceName.homePost+"?page=\(page)" + "&postType=\(selectedPostType)&limit=\(limit)"
        }
        var request = URLRequest(url: URL(string: kBASEURL + url)!)
        request.httpMethod = "GET"
        //request.setValue("application/json", forHTTPHeaderField: "content-type")
        request.setValue(kSharedUserDefaults.getLoggedInAccessToken(), forHTTPHeaderField: "accessToken")
        return request
    }
    
    func getHomeFeedTemp(page: Int) {
//        CommonUtils().isLoading(true)
        CommonUtils.showHudWithNoInteraction(show: true)
        let params: [String: Any] = [:]
        _ = try! JSONSerialization.data(withJSONObject: params, options: .prettyPrinted)
        //URLSession.shared.dataTask(with: URL(string: kBASEURL+url)!)
        if #available(iOS 15.0, *) {
            Task {
                let (data, _) = try await session.data(for: getRequest(page: page))
                do {
//                    CommonUtils().isLoading(false)
//                    CommonUtils.showHudWithNoInteraction(show: false)
                    let json = try JSONSerialization.jsonObject(with: data, options: [])
                    self.updateData(dictResult: kSharedInstance.getDictionary(json))
                    //print(json)
                } catch {
                    self.tableViewFeed.hideActivityIndicator()
                    print("JSON error: \(error.localizedDescription)")
//                    CommonUtils().isLoading(false)
//                    CommonUtils.showHudWithNoInteraction(show: false)
                }
            }
        } else {
            let task = session.dataTask(with: getRequest(page: page)) { [weak self] data, response, error in
                guard let self = self else { return }
//                CommonUtils().isLoading(false)
//                CommonUtils.showHudWithNoInteraction(show: false)
                if error != nil || data == nil {
                    print("Client error!")
                    return
                }
                guard let response = response as? HTTPURLResponse, (200...299).contains(response.statusCode) else {
                    print("Server error!")
                    return
                }
                guard let mime = response.mimeType, mime == "application/json" else {
                    print("Wrong MIME type!")
                    return
                }
                do {
                    let json = try JSONSerialization.jsonObject(with: data!, options: [])
                    print(json)
                    self.updateData(dictResult: kSharedInstance.getDictionary(json))
                } catch {
                    self.tableViewFeed.hideActivityIndicator()
                    print("JSON error: \(error.localizedDescription)")
                }
            }
            task.resume()
        }
    }
    
    func updateData(dictResult: [String: Any]) {
        CommonUtils.showHudWithNoInteraction(show: true)
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            if self.homeFeed.isEmpty {
                self.tableViewFeed.reloadData()
                self.tableViewFeed.hideActivityIndicator()
            }
            kBucketUrl = String.getString(dictResult["base_url"])
            var indexPathes: [IndexPath] = []
            let data = kSharedInstance.getDictionary(dictResult["data"])
            print("data ==========", data)
            self.firstPage = Int.getInt(data["first_page"])
            self.lastPage = Int.getInt(data["last_page"])
            self.totalPost = Int.getInt(data["total"])
            let unreadCount = Int.getInt(data["unread_count"])
            kSharedInstance.getArray(data["data"]).forEach {
                let indexPath = IndexPath(row:self.homeFeed.count, section: 2)
                self.homeFeed.append(HomeFeedModel(data: kSharedInstance.getDictionary($0)))
                indexPathes.append(indexPath)
            }
            
            self.isLoadingList = false
            self.tableViewFeed.beginUpdates()
            self.tableViewFeed?.insertRows(at: indexPathes, with: .fade)
            self.tableViewFeed.endUpdates()
            self.tableViewFeed.refreshControl?.endRefreshing()
            self.tableViewFeed.tableFooterView = nil
            self.tableViewFeed.tableFooterView?.isHidden = true
            self.spinner.stopAnimating()
            
            self.tabBarImageDelegate?.updateNotificationIcon(status: unreadCount <= 0 ? false : true)
            if self.currentPage == 1 {
                self.getStories()
                self.storyView?.storiesCollectionView.reloadData()
            }
        }
        CommonUtils.showHudWithNoInteraction(show: false)
    }
    
    func getExploreOptions() {
        CommonUtils.showHudWithNoInteraction(show: true)
        let params:[String: Any] = [:]
        TANetworkManager.sharedInstance.requestApi(withServiceName: ServiceName.active_type_post,
                                                   requestMethod: .GET,
                                                   requestParameters: params, withProgressHUD: false)
        { [weak self] (result: Any?, error: Error?, errorType: ErrorType, statusCode: Int?) in
            guard let self = self else { return }
            
            if errorType == .requestSuccess {
                let dictResult = kSharedInstance.getDictionary(result)
                switch Int.getInt(statusCode) {
                case 200:
                    let data = kSharedInstance.getArray(dictResult["type_of_post"])
                    self.exploreView?.updateData(data: data.map{ExploreOptionsModel(data: kSharedInstance.getDictionary($0))}, nav: self.navigationController ?? UINavigationController())
                    self.exploreView?.exploreCollectionView.reloadData()
                default:
                    //CommonUtils.showHudWithNoInteraction(show: false)
                    //showAlertMessage.alert(message: String.getString(dictResult["message"]))
                    CommonUtils().toast(with: String.getString(dictResult["message"]))
                }
            } else if errorType == .noNetwork {
                showAlertMessage.alert(message: AlertMessage.kNoInternet)
            } else {
                CommonUtils().toast(with: AlertMessage.kDefaultError)
            }
        }
    }
}

extension HomeVC: UITabBarControllerDelegate, UITabBarDelegate {
    func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {}
    // UITabBarControllerDelegate
    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
        if !homeFeed.isEmpty {
            //self.tableViewFeed.scrollRectToVisible(CGRect(x: 0, y: 0, width: 1, height: 1), animated: true)
            DispatchQueue.main.async {
                let indexPath = IndexPath(row: NSNotFound, section: 0)
                self.tableViewFeed.scrollToRow(at: indexPath, at: .bottom, animated: true)
            }
        }
    }
}

extension UIImageView {
    func downloadImage(urlString: String, success: ((_ image: UIImage?) -> Void)? = nil, failure: ((String) -> Void)? = nil) {
        
        let imageCache = NSCache<NSString, UIImage>()
        
        DispatchQueue.main.async {[weak self] in
            self?.image = nil
        }
        
        if let image = imageCache.object(forKey: urlString as NSString) {
            DispatchQueue.main.async {[weak self] in
                self?.image = image
            }
            success?(image)
        } else {
            guard let url = URL(string: urlString) else {
                print("failed to create url")
                return
            }
            
            let request = URLRequest(url: url)
            let task = URLSession.shared.dataTask(with: request) {(data, response, error) in
                
                // response received, now switch back to main queue
                DispatchQueue.main.async {[weak self] in
                    if let error = error {
                        failure?(error.localizedDescription)
                    }
                    else if let data = data, let image = UIImage(data: data) {
                        imageCache.setObject(image, forKey: url.absoluteString as NSString)
                        self?.image = image
                        success?(image)
                    } else {
                        failure?("Image not available")
                    }
                }
            }
            
            task.resume()
        }
    }
}

class EnlargeBtn: UIButton {
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.transform = CGAffineTransform(scaleX: 0.90, y: 0.90)
    }
}

extension UIViewController {
    func downlodeImage(serviceurl:String , placeHolder: UIImage?, completion: @escaping (UIImage)->()) {
        let urlString = serviceurl
        guard let url = URL(string: urlString.replacingOccurrences(of:  " ", with: "%20")) else { return }
        
        //MARK:- Check image Store in Cache or not
        if let cachedImage = iimageCache.object(forKey: urlString.replacingOccurrences(of: " ", with: "%20") as NSString) {
            if  let image = cachedImage as? UIImage {
                
                completion(image)
                print("Find image on Cache : For Key" , urlString.replacingOccurrences(of: " ", with: "%20"))
                return
            }
        }
        
        print("Conecting to Host with Url:-> \(url)")
        URLSession.shared.dataTask(with: url, completionHandler: { (data, response, error) in
            if error != nil {
                print(error!)
                DispatchQueue.main.async {
                    completion(placeHolder!)
                    return
                }
            }
            if data == nil {
                DispatchQueue.main.async {
                    completion(placeHolder!)
                }
                return
            }
            DispatchQueue.main.async {
                if let image = UIImage(data: data!) {
                    iimageCache.removeAllObjects()
                    completion(image)
                    iimageCache.setObject(image, forKey: urlString.replacingOccurrences(of: " ", with: "%20") as NSString)
                }
            }
        }).resume()
    }
}
