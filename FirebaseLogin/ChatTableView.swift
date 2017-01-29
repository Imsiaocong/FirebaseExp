//
//  ChatTableView.swift
//  FirebaseLogin
//
//  Created by Di Wang on 2017/1/25.
//  Copyright © 2017年 Di Wang. All rights reserved.
//

import UIKit

extension UIFont {
    static var FontStyleNormal: UIFont {
        return UIFont.systemFont(ofSize: 18)
    }
    
    static var FontTextStyleSubheadline: UIFont {
        return UIFont.preferredFont(forTextStyle: UIFontTextStyle.subheadline)
    }
}

enum Role{
    case sender
    case receive
}

class ChatViewData: NSObject {
    var content: String = ""
    var icon: String = ""
    var role: Role = Role.sender
    
    init(content: String, icon: String, role: Role) {
        self.content = content
        self.icon = icon
        self.role = role
    }
}

class ChatTableView: UITableView, UITableViewDataSource, UITableViewDelegate {
    
    var data: [[String: AnyObject]]? {
        didSet {
            print("didSet is : \(data)")
            guard let d = data, d.count > 0 else {
                return
            }
            self.reloadData()
        }
    }
    
    override init(frame: CGRect, style: UITableViewStyle) {
        super.init(frame: frame, style: style)
        followInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        followInit()
    }
    
    func followInit(){
        self.register(ChatViewCell.self, forCellReuseIdentifier: "ChatCell")
        self.dataSource = self
        self.delegate = self
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        return data?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        let cell = tableView.dequeueReusableCell(withIdentifier: "ChatCell", for: indexPath) as! ChatViewCell
        if let d = data {
            let dc = d[indexPath.row] as [String: AnyObject]
            let content = dc["content"] as? String ?? ""
            let icon = dc["icon"] as? String ?? ""
            let role = (dc["role"] as? String ?? "") == "MINE" ? Role.sender : Role.receive
            cell.data = ChatViewData(content: content, icon: icon, role: role)
        }
        return cell
    }
    
}

class ChatViewCell: UITableViewCell {
    var data: ChatViewData? {
        didSet {
            self.backgroundColor = UIColor.clear
            self.headerImgView.removeFromSuperview()
            self.contentLbl.removeFromSuperview()
            self.bubbleImgView.removeFromSuperview()
            self.contentView.addSubview(self.headerImgView)
            self.contentView.addSubview(self.bubbleImgView)
            self.bubbleImgView.addSubview(self.contentLbl)
            
            
            self.headerImgView.image = UIImage(named: data?.icon ?? "Default")
            self.bubbleImgView.image = data?.role == Role.sender ? UIImage(named: "chatto_bg_normal") : UIImage(named: "chatfrom_bg_normal")
            self.contentLbl.text = data?.content
            self.contentLbl.font = UIFont.FontStyleNormal
            self.contentLbl.textAlignment = data?.role == Role.sender ? NSTextAlignment.right : NSTextAlignment.left
            
            let vd = ["headerImgView": self.headerImgView, "content": self.contentLbl, "bubble": self.bubbleImgView] as [String : Any]
            let header_constraint_H_Format = data?.role == Role.sender ? "[headerImgView(50)]-5-|" : "|-5-[headerImgView(50)]"
            let header_constraint_V_Format = data?.role == Role.sender ? "V:|-5-[headerImgView(50)]" : "V:|-5-[headerImgView(50)]"
            let bubble_constraint_H_Format = data?.role == Role.sender ? "|-(>=5)-[bubble]-10-[headerImgView]" : "[headerImgView]-10-[bubble]-(>=5)-|"
            let bubble_constraint_V_Format = data?.role == Role.sender ? "V:|-5-[bubble(>=50)]-5-|" : "V:|-5-[bubble(>=50)]-5-|"
            let content_constraint_H_Format = data?.role == Role.sender ? "|-10-[content]-18-|" : "|-18-[content]-10-|"
            let content_constraint_V_Format = data?.role == Role.sender ? "V:|-10-[content]-14-|" : "V:|-10-[content]-14-|"
            
            
            let header_constraint_H = NSLayoutConstraint.constraints(withVisualFormat: header_constraint_H_Format, options: [], metrics: nil, views: vd)
            let header_constraint_V = NSLayoutConstraint.constraints(withVisualFormat: header_constraint_V_Format, options: [], metrics: nil, views: vd)
            
            let bubble_constraint_H = NSLayoutConstraint.constraints(withVisualFormat: bubble_constraint_H_Format, options: [], metrics: nil, views: vd)
            let bubble_constraint_V = NSLayoutConstraint.constraints(withVisualFormat: bubble_constraint_V_Format, options: [], metrics: nil, views: vd)
            
            let content_constraint_H = NSLayoutConstraint.constraints(withVisualFormat: content_constraint_H_Format, options: [], metrics: nil, views: vd)
            let content_constraint_V = NSLayoutConstraint.constraints(withVisualFormat: content_constraint_V_Format, options: [], metrics: nil, views: vd)
            
            self.contentView.addConstraints(header_constraint_H)
            self.contentView.addConstraints(header_constraint_V)
            self.contentView.addConstraints(bubble_constraint_H)
            self.contentView.addConstraints(bubble_constraint_V)
            self.contentView.addConstraints(content_constraint_H)
            self.contentView.addConstraints(content_constraint_V)
        }
    }
    
    lazy var headerImgView: UIImageView = {
        let v = UIImageView()
        v.translatesAutoresizingMaskIntoConstraints = false
        v.layer.cornerRadius = 25
        v.layer.masksToBounds = true
        return v
    }()
    
    lazy var contentLbl: UILabel = {
        let v = UILabel()
        v.translatesAutoresizingMaskIntoConstraints = false
        v.layer.cornerRadius = 25
        v.layer.masksToBounds = true
        return v
    }()
    
    lazy var bubbleImgView: UIImageView = {
       let v = UIImageView()
        v.translatesAutoresizingMaskIntoConstraints = false
        return v
    }()
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        followInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        followInit()
    }
    
    func followInit() {
        self.selectionStyle = .none
    }
}
