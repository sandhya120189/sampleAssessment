//
//  TableViewController.swift
//  SampleAssesement
//
//  Created by Vinoth Ganapathy on 09/06/18.
//  Copyright © 2018 Gee Vee. All rights reserved.
//

import UIKit

class TableViewController: UITableViewController {
    
    
    let cellIdentifier:String = "cell"
    var navigationTitleText: String = "" {
        didSet {
            self.title = navigationTitleText
        }
    }
    
    let myActivityIndicator = UIActivityIndicatorView()
    
    var listViewModel: ListViewModel = ListViewModel()
    lazy var refreshCntrl: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(TableViewController.handleRefresh(_:)), for: UIControlEvents.valueChanged)
        refreshControl.tintColor = UIColor.red
        
        return refreshControl
    }()
   
    override func viewDidLoad() {
        super.viewDidLoad()
         self.callDataDownloadTask()
        
        tableView.estimatedRowHeight = 286
        tableView.backgroundColor = UIColor.init(red: 215/255, green: 215/255, blue: 215/255, alpha: 1.0)
        tableView.tableFooterView = UIView.init()
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.register(TableViewCell.classForCoder(), forCellReuseIdentifier: cellIdentifier)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        
        self.tableView.addSubview(self.refreshCntrl)
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        myActivityIndicator.center = self.view.center
        myActivityIndicator.hidesWhenStopped = true
        myActivityIndicator.activityIndicatorViewStyle = .whiteLarge
        self.view.addSubview(myActivityIndicator)
        myActivityIndicator.startAnimating()
            
       
    }
//    func fetchDataFromJsonFile() {
//        let urlString = URL(string: Constants.URLStrings.WEB_SERVICE_URL_STRING)
//        let urlRequest = URLRequest(url: urlString!)
//        
//        APIClient.client.fetchDataTask(urlRequest: urlRequest, completion:{ (successOrFailure,responseObject) in
//            
//            if let items = responseObject!["rows"] as? [[String:Any]] {
//                
//                for item in items{
//                    let model = TableViewModel(dictionary: item as NSDictionary )
//                    self.itemsArray.append(model)
//                }
//                DispatchQueue.main.async() {
//                    self.navigationTitleText = responseObject!["title"] as! String
//                    self.tableView.reloadData()
//                    self.myActivityIndicator.stopAnimating()
//                }
//            }
//            
//        })
//        
//    }
    func callDataDownloadTask (){
        let urlString = URL(string: Constants.URLStrings.WEB_SERVICE_URL_STRING)
        let urlRequest = URLRequest(url: urlString!)
        listViewModel.fetchJsonAndSaving(urlRequest: urlRequest, completion: {(successOrFailure,responseObject) in
            
            if successOrFailure{
                DispatchQueue.main.async() {
                    self.navigationTitleText = responseObject!["title"] as! String
                    self.tableView.reloadData()
                    self.myActivityIndicator.stopAnimating()
                }
            }
            
        })
    }

    @objc func handleRefresh(_ refreshControl: UIRefreshControl) {
        
       self.callDataDownloadTask()
        refreshControl.endRefreshing()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        //return self.itemsArray.count
        return listViewModel.numberOfRowsInSection()
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier) as! TableViewCell?
        
        if cell == nil {
            cell = TableViewCell(style: UITableViewCellStyle.default, reuseIdentifier: cellIdentifier)
        }
        
        let model = listViewModel.itemsArray[indexPath.row] as TableViewModel
        if let imgURLString = model.imageHref{
            let imageUrl = URL(string: imgURLString)
            cell?.imgView.image = UIImage(named: "no_Image")
            cell?.imgView.sd_setImage(with: imageUrl, placeholderImage: UIImage(named: "no_Image"), options:.fromCacheOnly, completed: nil)
            cell?.titleLabel.text = listViewModel.itemsArray[indexPath.row].title
            cell?.descriptionLabel.text = listViewModel.itemsArray[indexPath.row].description
            cell?.selectionStyle = .none
            return cell!
        }
        
        return UITableViewCell()
    }
}
    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */


