//
//  AddViewController.swift
//  Ranking
//
//  Created by 浅田智哉 on 2021/05/31.
//

import UIKit
import NCMB
import KRProgressHUD

class AddViewController: UIViewController {
    
    @IBOutlet var nameTextFiled : UITextField!
    @IBOutlet var heightTextField : UITextField!

    override func viewDidLoad() {
        super.viewDidLoad()

        
    }
    

    
    @IBAction func add() {
        let object = NCMBObject(className: "Player")
        
        object?.setObject(nameTextFiled.text, forKey: "name")
        
        let height = Int(heightTextField.text!)
        object?.setObject(height, forKey: "height")
        
        object?.saveInBackground({ (error) in
            if error != nil {
                KRProgressHUD.showError()
            } else {
                self.dismiss(animated: true, completion: nil)
            }
        })
    }
    

}
