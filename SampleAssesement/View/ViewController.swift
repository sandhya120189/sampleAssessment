//
//  ViewController.swift
//  SampleAssesement
//
//  Created by Vinoth Ganapathy on 07/06/18.
//  Copyright © 2018 Gee Vee. All rights reserved.
//

import UIKit
import SDWebImage

class ViewController: UIViewController{
    var itemsArray = [TableViewModel]()
 
    let cellIdentifier:String = "cell"
    @IBOutlet var tableView: UITableView!
    var navigationTitleText: String = "" {
        didSet {
            self.title = navigationTitleText
        }
    }
    
    let myActivityIndicator = UIActivityIndicatorView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.estimatedRowHeight = 200
        tableView.rowHeight = UITableViewAutomaticDimension
       tableView.register(UINib(nibName: "CustomTableViewCell", bundle: nil), forCellReuseIdentifier: cellIdentifier)
        
       
        // Do any additional setup after loading the view, typically from a nib.
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        myActivityIndicator.center = self.view.center
        myActivityIndicator.hidesWhenStopped = true
        myActivityIndicator.activityIndicatorViewStyle = .gray
        self.view.addSubview(myActivityIndicator)
        myActivityIndicator.startAnimating()
        
         self.fetchDataFromJsonFile()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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


}
extension ViewController : UITableViewDataSource, UITableViewDelegate{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return  self.itemsArray.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if let cell  =  tableView.dequeueReusableCell(withIdentifier: self.cellIdentifier) as? CustomTableViewCell
        {
            let model = itemsArray[indexPath.row] as TableViewModel
            if let imgURLString = model.imageHref{
                let imageUrl = URL(string: imgURLString)
                cell.imgView.sd_setImage(with: imageUrl, completed: nil)
                cell.titleLabel.text = itemsArray[indexPath.row].title
                cell.descriptionLabel.text = itemsArray[indexPath.row].description
                return cell
            }
            
            
        }
        return UITableViewCell()
    }
        
}
