//
//  ListViewController.swift
//  SampleAssesement
//
//  Created by Vinoth Ganapathy on 09/06/18.
//  Copyright © 2018 Gee Vee. All rights reserved.
//

import UIKit

class ListViewController: UIViewController {
    let kCellIdentifier = "CellIdentifier"
    var itemsArray = [TableViewModel]()
    let myActivityIndicator = UIActivityIndicatorView()
    var navigationTitleText: String = "" {
        didSet {
            self.title = navigationTitleText
        }
    }
    var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Get main screen bounds
    
        let barHeight: CGFloat = UIApplication.shared.statusBarFrame.size.height
        let displayWidth: CGFloat = self.view.frame.width
        let displayHeight: CGFloat = self.view.frame.height

        tableView = UITableView(frame: CGRect(x: 0, y: barHeight+44, width: displayWidth, height: displayHeight - barHeight+44), style: UITableViewStyle.plain)
//        tableView = UITableView.init(frame: UIScreen.main.bounds, style: .plain)
        tableView.estimatedRowHeight = 286
        tableView.dataSource = self
        tableView.backgroundColor = UIColor.init(red: 215/255, green: 215/255, blue: 215/255, alpha: 1.0)
        tableView.tableFooterView = UIView.init()
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.register(TableViewCell.classForCoder(), forCellReuseIdentifier: kCellIdentifier)
        tableView.translatesAutoresizingMaskIntoConstraints = false
         view.addSubview(tableView)
        
       
        let leading = NSLayoutConstraint(item: tableView,
                                         attribute: .leading,
                                         relatedBy: .equal,
                                         toItem: self.view,
                                         attribute: .leading,
                                         multiplier: 1.0,
                                         constant: 0.0)
        
        let trailing = NSLayoutConstraint(item: tableView,
                                          attribute: .trailing,
                                          relatedBy: .equal,
                                          toItem: self.view,
                                          attribute: .trailing,
                                          multiplier: 1.0,
                                          constant: 0.0)
        let top = NSLayoutConstraint(item: tableView,
                                     attribute: .top,
                                     relatedBy: .equal,
                                     toItem: self.view,
                                     attribute: .top,
                                     multiplier: 1.0,
                                     constant: 64.0)
        let bottom = NSLayoutConstraint(item: tableView,
                                        attribute: .bottom,
                                        relatedBy: .equal,
                                        toItem: self.view,
                                        attribute: .bottomMargin,
                                        multiplier: 1.0,
                                        constant: 0.0)
       self.view.addConstraint(top)
        self.view.addConstraint(bottom)
        self.view.addConstraint(leading)
        self.view.addConstraint(trailing)
        
        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        myActivityIndicator.center = self.view.center
        myActivityIndicator.hidesWhenStopped = true
        myActivityIndicator.activityIndicatorViewStyle = .whiteLarge
        self.view.addSubview(myActivityIndicator)
        myActivityIndicator.startAnimating()
        
        self.fetchDataFromJsonFile()
    }
    
    func fetchDataFromJsonFile() {
        let urlString = URL(string: Constants.URLStrings.WEB_SERVICE_URL_STRING)
        let urlRequest = URLRequest(url: urlString!)
        
        APIClient.client.fetchDataTask(urlRequest: urlRequest, completion:{ (successOrFailure,responseObject) in
            
            if let items = responseObject!["rows"] as? [[String:Any]] {
                
                for item in items{
                    let model = TableViewModel(dictionary: item as NSDictionary )
                    self.itemsArray.append(model)
                }
                DispatchQueue.main.async() {
                    self.navigationTitleText = responseObject!["title"] as! String
                    self.tableView.reloadData()
                    self.myActivityIndicator.stopAnimating()
                }
            }
            
        })
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
   

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
extension ListViewController : UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return  self.itemsArray.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: kCellIdentifier) as! TableViewCell?
        
        if cell == nil {
            cell = TableViewCell(style: UITableViewCellStyle.default, reuseIdentifier: kCellIdentifier)
        }
        
        let model = itemsArray[indexPath.row] as TableViewModel
        if let imgURLString = model.imageHref{
            let imageUrl = URL(string: imgURLString)
            cell?.imgView.image = UIImage(named: "no_Image")
            cell?.imgView.sd_setImage(with: imageUrl, placeholderImage: UIImage(named: "no_Image"), options:.fromCacheOnly, completed: nil)
            cell?.titleLabel.text = itemsArray[indexPath.row].title
            cell?.descriptionLabel.text = itemsArray[indexPath.row].description
            cell?.selectionStyle = .none
            return cell!
        }
        
        return UITableViewCell()
    }
}
