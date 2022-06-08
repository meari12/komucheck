//
//  MainViewController.swift
//  gyomucheck
//
//  Created by Meri Sato on 2022/06/01.
//

import UIKit
import RealmSwift

class MainViewController: UIViewController {
    
    @IBOutlet var tableView: UITableView!
    
    let realm = try! Realm()
    
    var kiroku = [Kiroku]()
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpViews()
        getKoumokuData()
        getTimerData()
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        getKoumokuData()
        getTimerData()
    }
    
    // Viewの初期設定を行うメソッド
    func setUpViews() {
        tableView.delegate = self
        tableView.dataSource = self
        
    }
    
    // Realmからデータを取得してテーブルビューを再リロードするメソッド
    //保存済みのツイートを取得する
    func getKoumokuData(){
        kiroku = Array(realm.objects(Kiroku.self)).reversed()  // Realm DBから保存されてるツイートを全取得
        tableView.reloadData() // テーブルビューをリロード
    }
    
    func getTimerData(){
        kiroku = Array(realm.objects(Kiroku.self)).reversed()  // Realm DBから保存されてるツイートを全取得
        tableView.reloadData() // テーブルビューをリロード
    }
    
    
}

extension MainViewController: UITableViewDelegate, UITableViewDataSource {
    
    // cellの個数を指定する
    // TableViewが何個のCellを表示するのか設定するデリゲートメソッド
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let kirokuData = realm.objects(Kiroku.self)
        return kirokuData.count //記録の数だけセルを作る
        
    }
    
    // Cellの中身を指定する
    // Cellの中身を設定するデリゲートメソッド
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        let kirokuData = realm.objects(Kiroku.self)
        (cell.viewWithTag(1) as? UILabel)!.text = kirokuData[indexPath.row].subject
        //kirokuData[indexPath.row]=セルの上から何番目か
        (cell.viewWithTag(2) as? UILabel)!.text = kirokuData[indexPath.row].duration
        //(cell.viewWithTag(3) as? UILabel)!.text = kirokuData[indexPath.row].recordData
        
        return cell
    }
    
    //セルの編集許可
       func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool
       {
           return true
       }

       //スワイプしたセルを削除　
       func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
           if editingStyle == UITableViewCell.EditingStyle.delete {
               kiroku.remove(at: indexPath.row)
               tableView.deleteRows(at: [indexPath as IndexPath], with: UITableView.RowAnimation.automatic)
           }
       }
    
    
    
}




// Cellのサイズを設定するデリゲートメソッド
func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    // TODO: ②-④Cellの高さを指定する
    return 40
}


/*
 // MARK: - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
 // Get the new view controller using segue.destination.
 // Pass the selected object to the new view controller.
 }
 */

