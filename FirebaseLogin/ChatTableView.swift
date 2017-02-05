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
            
            //2.设置约束
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

//额外功能 输入框

class ChatInputTool : UIView {
    
    
    var hasTxt : Bool? {
        didSet {
            senderTool.isEnabled = hasTxt ?? false
            senderTool.backgroundColor = (hasTxt ?? false) ? UIColor(red:0.53, green:0.85, blue:0.41, alpha:1.00) : UIColor(red:0.40, green:0.40, blue:0.40, alpha:1.00)
        }
    }
    
    var inputTool : UITextField = {
        let v = UITextField()
        v.translatesAutoresizingMaskIntoConstraints = false
        v.layer.cornerRadius = 4
        v.layer.borderColor = UIColor.lightGray.cgColor
        v.layer.borderWidth = 1
        v.font = UIFont.FontTextStyleSubheadline
        v.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: 20))
        v.leftViewMode = .always
        return v
    }()
    
    var senderTool : UIButton = {
        let v = UIButton()
        v.translatesAutoresizingMaskIntoConstraints = false
        v.backgroundColor = UIColor(red:0.40, green:0.40, blue:0.40, alpha:1.00)
        v.layer.cornerRadius = 4
        v.layer.masksToBounds = true
        v.setTitle("发送", for: UIControlState())
        v.titleLabel?.font = UIFont.FontTextStyleSubheadline
        v.titleLabel?.textAlignment = .center
        v.isEnabled = false
        return v
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        followInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        followInit()
    }
    var vd : [String : AnyObject] = [String : AnyObject]()
    func followInit(){
        self.addSubview(inputTool)
        self.addSubview(senderTool)
        vd = ["inputTool" : inputTool , "senderTool" : senderTool]
        self.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "|-10-[inputTool]-20-[senderTool(70)]-10-|", options: [], metrics: nil, views: vd))
        self.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-[inputTool]-|", options: [], metrics: nil, views: vd))
        self.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-[senderTool]-|", options: [], metrics: nil, views: vd))
        
    }
}

extension UITableView {
    // 输入文字自动滚动至底部
    func scrollToBottom (_ handler : (()->())? = nil) {
        let sections = self.numberOfSections
        let rows = self.numberOfRows(inSection: sections - 1)
        let sections_rows = IndexPath(row: rows - 1, section: sections - 1)
        self.scrollToRow(at: sections_rows, at: .bottom, animated: true)
        
        if let d = handler {
            d()
        }
    }
    
}

class AtuoKeyboardManager: NSObject {
    
    var view: UIView
    var inputView: UIView
    var ifNotRootViewDistance : CGFloat
    var cover: UIView?
    var inputVisiableHeight : CGFloat
    
    init(translateView: UIView, inputView: UIView , ifNotRootViewDistance : CGFloat = 0 , inputVisiableHeight : CGFloat = 0) {
        self.view = translateView
        self.inputView = inputView
        self.ifNotRootViewDistance = ifNotRootViewDistance
        self.inputVisiableHeight = inputVisiableHeight
        super.init()
    }
    
    func addObserver() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardShow(_:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardHide(_:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    
    func removeObserver() {
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    
    
    func keyboardShow(_ notification: Notification) {
        let userInfo = notification.userInfo! as NSDictionary
        let keyboardHeight = (userInfo.object(forKey: UIKeyboardFrameEndUserInfoKey) as AnyObject).cgRectValue.size.height 
        let duration: TimeInterval = (userInfo.object(forKey: UIKeyboardAnimationCurveUserInfoKey) as AnyObject).doubleValue ?? 0
        let options = UIViewAnimationOptions()
        let delta = keyboardHeight - (BasicValue.screenHeight - self.inputView.frame.maxY) + ifNotRootViewDistance
        if delta > 0 {
            UIView.animate(withDuration: duration, delay: 0, options:options, animations: { [weak self] _ in
                if let strongSelf = self {
                    strongSelf.view.transform = CGAffineTransform(translationX: 0, y: -delta - BasicValue.offSet)
                }
            }) { _ in
            }
            
        }
        addCover()
        
    }
    func keyboardHide(_ notification: Notification) {
        let userInfo = notification.userInfo! as NSDictionary
        let duration: TimeInterval = (userInfo.object(forKey: UIKeyboardAnimationCurveUserInfoKey) as AnyObject).doubleValue ?? 0
        let options = UIViewAnimationOptions()
        UIView.animate(withDuration: duration, delay: 0, options: options, animations: { [weak self] _ in
            if let strongSelf = self {
                strongSelf.view.transform = CGAffineTransform.identity
            }
        }){ _ in
        }
        self.removeObserver()
        
    }
    
    func addCover() {
        cover = UIView(frame: CGRect(x: 0, y: 0, width: self.view.bounds.width, height: self.view.bounds.height - inputVisiableHeight))
        self.view.addSubview(cover!)
        let tap = UITapGestureRecognizer(target: self, action: #selector(coverTapped))
        cover!.addGestureRecognizer(tap)
    }
    
    func removeCover() {
        cover?.removeFromSuperview()
        cover = nil
    }
    
    func coverTapped() {
        self.view.endEditing(true)
        removeCover()
    }
    
    struct BasicValue {
        
        static var offSet: CGFloat = 1.0
        static let screenHeight = UIScreen.main.bounds.size.height
    }
    
}
