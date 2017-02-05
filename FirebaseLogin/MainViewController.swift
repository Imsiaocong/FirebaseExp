//
//  MainViewController.swift
//  FirebaseLogin
//
//  Created by Di Wang on 2017/1/23.
//  Copyright © 2017年 Di Wang. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth

class MainViewController: UIViewController, UITableViewDelegate, UITableViewDataSource  {
    
    var datas = ["Online Chat"]
    
    @IBOutlet weak var tableView: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.tableView.dataSource = self
        self.tableView.delegate = self
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
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return datas.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = "\(datas[indexPath.row])"
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let chose = datas[indexPath.row]
        self.performSegue(withIdentifier: "\(chose)", sender: self)
    }
    
    @IBAction func logoutAccountAction(_ sender: Any) {
        let auth = FIRAuth.auth()
        do {
            try auth?.signOut()
            self.dismiss(animated: true, completion: nil)
            print("Logged out!")
        }catch{
            print(error)
        }
    }

}
