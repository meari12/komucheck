//
//  MainViewController.swift
//  gyomucheck
//
//  Created by Meri Sato on 2022/06/01.
//

import UIKit
import RealmSwift

class MainViewController: UIViewController{
    
    @IBOutlet var tableView: UITableView!
    
    let realm = try! Realm()
    
    var kiroku = [Kiroku]()
    var kirokuDic = [String : [Kiroku]]()
    
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
    //保存済みのデータを取得する
    func getKoumokuData(){
        kiroku = Array(realm.objects(Kiroku.self)).reversed()
        // Realm DBから保存されてるツイートを全取得
        
        kirokuDic = [:]
        for k in kiroku {
            if kirokuDic.keys.contains(k.recordDateString) {
                // ディクショナリーの鍵に日付が含まれてたら、kを追加
                kirokuDic[k.recordDateString]?.append(k)
            } else {
                // ディクショナリーの鍵に日付が含まれてなかったら配列を初期化
                kirokuDic[k.recordDateString] = [k]
            }
            
        }
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
        let array = Array(kirokuDic.keys)
        let key = array[section]
        return kirokuDic[key]?.count ?? 0
        
    }
    //セクションの数
    func numberOfSections(in tableView: UITableView) -> Int {
        return kirokuDic.keys.count
    }
    
    //セクションのタイトル
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        let array = Array(kirokuDic.keys)
        let key = array[section]
        return key
    }
    
    // Cellの中身を指定する
    // Cellの中身を設定するデリゲートメソッド
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        let key = Array(kirokuDic.keys)[indexPath.section] // 0
        let kiroku = kirokuDic[key]?[indexPath.row]
        
        (cell.viewWithTag(1) as? UILabel)!.text = kiroku?.subject
        //kirokuData[indexPath.row]=セルの上から何番目か
        (cell.viewWithTag(2) as? UILabel)!.text = kiroku?.duration
        return cell
    }
    
    
    //セルの編集許可
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool
    {
        return true
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
