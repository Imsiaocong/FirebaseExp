//
//  ChatViewController.swift
//  FirebaseLogin
//
//  Created by Di Wang on 2017/1/25.
//  Copyright © 2017年 Di Wang. All rights reserved.
//
import UIKit

class ChatViewController: UIViewController , UITextFieldDelegate {
    
    
    var keyboardManager: AtuoKeyboardManager?
    
    lazy var chatTable : ChatTableView = {
        let v = ChatTableView()
        v.translatesAutoresizingMaskIntoConstraints = false
        v.separatorStyle = .none
        v.backgroundColor = UIColor(red:0.96, green:0.96, blue:0.96, alpha:1.00)
        v.estimatedRowHeight = 50
        v.rowHeight = UITableViewAutomaticDimension
        return v
    }()
    
    lazy var chatTool : ChatInputTool = {
        let v = ChatInputTool()
        v.translatesAutoresizingMaskIntoConstraints = false
        v.backgroundColor = UIColor.white
        return v
        
    }()
    
    var vd : [String : AnyObject] = [String : AnyObject]()
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        vd = ["chatTable" : chatTable , "chatTool" : chatTool]
        self.view.addSubview(chatTable)
        self.view.addSubview(chatTool)
        chatTool.inputTool.delegate = self
        self.view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "|[chatTable]|", options: [], metrics: nil, views: vd))
        self.view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "|[chatTool]|", options: [], metrics: nil, views: vd))
        self.view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-20-[chatTable][chatTool(50)]|", options: [], metrics: nil, views: vd))
        
        //默认数据
        chatTable.data = [
            ["content" : "你好" as AnyObject , "icon" : "katong" as AnyObject,"role" : "SOMEONE" as AnyObject] ,
            ["content" : "好" as AnyObject , "icon" : "mm" as AnyObject,"role" : "MINE" as AnyObject] ,
            ["content" : "你好" as AnyObject , "icon" : "katong" as AnyObject,"role" : "SOMEONE" as AnyObject] ,
            ["content" : "精品 - 纯代码 swift 聊天 微信 qq UITableView Chat<夜黑执事 出品>" as AnyObject , "icon" : "katong" as AnyObject,"role" : "SOMEONE" as AnyObject] ,
            ["content" : "精品 - 纯代码 swift 聊天 微信 qq UITableView Chat<夜黑执事 出品>精品 - 纯代码 swift 聊天 微信 qq UITableView Chat<夜黑执事 出品>" as AnyObject , "icon" : "mm" as AnyObject,"role" : "MINE" as AnyObject] ,
            ["content" : "你好" as AnyObject , "icon" : "mm" as AnyObject,"role" : "MINE" as AnyObject] ,
            ["content" : "精品 - 纯代码 swift 聊天 微信 qq UITableView Chat<夜黑执事 出品>" as AnyObject , "icon" : "katong" as AnyObject,"role" : "SOMEONE" as AnyObject] ,
            ["content" : "我都不知道自己在干什么" as AnyObject , "icon" : "katong" as AnyObject,"role" : "SOMEONE" as AnyObject] ,
        ]
        
        
        chatTool.senderTool.addTarget(self, action: #selector(renderTableView(_:)), for: .touchUpInside)
        
    }
    
    
    func renderTableView(_ sender : UIButton){
        
        if let txt = chatTool.inputTool.text {
            chatTable.data?.append(["content" : txt as AnyObject , "icon" : "mm" as AnyObject,"role" : "MINE" as AnyObject])
            chatTool.inputTool.text = ""
            
            Timer.scheduledTimer(timeInterval: 0.2, target: self, selector: #selector(scrollTab), userInfo: nil, repeats: false)
        }
        
    }
    
    func scrollTab(){
        chatTable.scrollToBottom()
    }
    
    
}

extension ChatViewController {
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        
        let input = self.chatTool.inputTool
        
        keyboardManager = AtuoKeyboardManager(translateView: self.view, inputView: input, ifNotRootViewDistance: UIScreen.main.bounds.height - 45 , inputVisiableHeight: 50)
        keyboardManager?.addObserver()
        return true
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        print("textField.text?.utf16.count  : \(chatTool.inputTool.text?.utf16.count )")
        
        chatTool.hasTxt = (chatTool.inputTool.text?.utf16.count)! >= 0
        
        return true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        return true
    }
}



