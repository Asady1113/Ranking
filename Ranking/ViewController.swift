//
//  ViewController.swift
//  Ranking
//
//  Created by 浅田智哉 on 2021/05/31.
//

import UIKit
import NCMB
import KRProgressHUD


class ViewController: UIViewController,UITableViewDataSource {
    
    @IBOutlet var rankTableView : UITableView!
    
    var players = [Player]()
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        rankTableView.dataSource = self
      
        makeButton()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        loadData()
    }

    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return players.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell")!
        
        let nameLabel = cell.viewWithTag(1) as! UILabel
        let heightLabel = cell.viewWithTag(2) as! UILabel
        
        
        nameLabel.text = players[indexPath.row].name
        heightLabel.text = String(players[indexPath.row].height)
        
        
        return cell
    }
    
    
    
    //ボタンの生成
    func makeButton() {
        let plusButton = UIButton()
        // 必ずfalseにする（理由は後述）
        plusButton.translatesAutoresizingMaskIntoConstraints = false
        // tintColorを黒にする
        plusButton.tintColor = .black
        // グレーっぽくする
        plusButton.backgroundColor = UIColor.gray
        // 正円にする
        plusButton.layer.cornerRadius = 25
        // plustButtonのImageをplus（+）に設定する
        plusButton.setImage(UIImage(systemName: "plus"), for: .normal)
        // ViewにplusButtonを設置する（必ず制約を設定する前に記述する）
        self.view.addSubview(plusButton)

        // 以下のコードから制約を設定している
        // plustButtonの下端をViewの下端から-50pt（=上に50pt）
        plusButton.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: -100).isActive = true
        // plustButtonの右端をViewの右端から-30pt（=左に30pt）
        plusButton.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -30).isActive = true
        // plustButtonの幅を50にする
        plusButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
        // plusButtonの高さを50にする
        plusButton.widthAnchor.constraint(equalToConstant: 50).isActive = true
        
        // タップされたときのaction
        plusButton.addTarget(self,
                       action: #selector(ViewController.buttonTapped),
                       for: .touchUpInside)
    }
    
    
    @objc func buttonTapped() {
        self.performSegue(withIdentifier: "toAdd", sender: nil)
        
    }
    

    
    
    //データ読み込み
    func loadData() {
        let query = NCMBQuery(className: "Player")
        
        query?.findObjectsInBackground({ (result, error) in
            if error != nil {
                KRProgressHUD.showError()
            } else {
                self.players = [Player]()
                
                for loadObject in result as! [NCMBObject] {
                    let name = loadObject.object(forKey: "name") as! String
                    let height = loadObject.object(forKey: "height") as! Int
                    
                    let player = Player(name: name, height: height)
                    
                    self.players.append(player)
                }
               
                self.rankTableView.reloadData()
            }
        })
    }
    
    
    
    //並べ替えボタン
    @IBAction func changeNumber() {
        
        for a in 0...players.count - 1 {
          for i in 0...(players.count - 1) - a {
            
            //最後の番号でない時（最後の番号だとi+1でクラッシュする）
            if i != players.count - 1 {
                change(n: i)
            }
          }
        }
        
        rankTableView.reloadData()
    }
    
    
    
    func change(n: Int) {
        //もしi番目よりもi+1番目が大きければ、入れ替える
          if players[n].height < players[n + 1].height {

            let player1 = players[n]
            let player2 = players[n+1]

            players[n] = player2
            players[n+1] = player1
           }
    }
    
    
}

