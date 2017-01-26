//
//  ChatTableView.swift
//  FirebaseLogin
//
//  Created by Di Wang on 2017/1/25.
//  Copyright © 2017年 Di Wang. All rights reserved.
//

import UIKit

class ChatViewData: NSObject {
    var content: String = ""
    var icon: String = ""
    
    init(content: String, icon: String) {
        self.content = content
        self.icon = icon
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
        return nil
    }
    
}

class ChatViewCell: UITableViewCell {
    
}
