//
//  TableViewCell.swift
//  SampleAssesement
//
//  Created by Vinoth Ganapathy on 09/06/18.
//  Copyright © 2018 Gee Vee. All rights reserved.
//

import UIKit
import Masonry
class TableViewCell: UITableViewCell {

    var didSetupConstraints = false
    var imageSize: CGSize!
    
    let titleLabel: UILabel = {
        let titleLabel = UILabel()
        titleLabel.numberOfLines = 0
        titleLabel.lineBreakMode = .byClipping
        titleLabel.font = UIFont(name: "AvenirNext-Bold", size: 28.0)
        titleLabel.textAlignment = .center
        titleLabel.textColor = UIColor.black
        return titleLabel
    }()
    
    let descriptionLabel: UILabel = {
        let descriptionLabel = UILabel()
        descriptionLabel.numberOfLines = 0
        descriptionLabel.font = UIFont.systemFont(ofSize: 16)
        descriptionLabel.lineBreakMode = .byClipping
        descriptionLabel.textColor = .black
        return descriptionLabel
    }()
    
    let imgView: UIImageView = {
        let imgView = UIImageView()
        imgView.image = UIImage(named: "no_Image")
        imgView.sizeToFit()
        imgView.contentMode = .scaleAspectFit
        
        return imgView
    }()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
       
    }
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
//        contentView.backgroundColor = .lightGray
        contentView.addSubview(imgView)
        contentView.addSubview(titleLabel)
        contentView.addSubview(descriptionLabel)
        imageSize = CGSize(width: 100, height: 100)
        self.setNeedsUpdateConstraints()
        
        
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func updateConstraints() {
    
        
        if (!didSetupConstraints) {
            imgView.mas_makeConstraints({ make in

//                make?.width.equalTo()(UIScreen.main.bounds.size.width)
                make?.top.equalTo()(10)
                make?.left.equalTo()(0)
                make?.right.equalTo()(0)
//                make?.bottom.equalTo()(titleLabel.mas_top)
                
            })
            
            titleLabel.mas_makeConstraints({ make in
//                make?.width.equalTo()(self.frame.size.width)
                make?.top.equalTo()(imgView.mas_bottom)?.offset()(0)
                make?.left.equalTo()(0)
                make?.right.equalTo()(0)

            })
            
            descriptionLabel.mas_makeConstraints({ make in
                //                make?.width.equalTo()(self.frame.size.width)
                make?.top.equalTo()(titleLabel.mas_bottom)?.offset()(10)
                make?.left.equalTo()(0)
                make?.right.equalTo()(0)
                make?.bottom.equalTo()(-10)
                
            })
            
            
            didSetupConstraints = true
        }
        
        super.updateConstraints()
    }


    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
