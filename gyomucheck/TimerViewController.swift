//
//  TimerViewController.swift
//  gyomucheck
//
//  Created by Meri Sato on 2022/05/23.
//

import UIKit
import RealmSwift


class TimerViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    
    let realm = try! Realm()
    
    var startTime: TimeInterval? = nil
    var timer = Timer()
    
    @IBOutlet weak var timerLabel: UILabel!
    var switch_flg:Bool = true
    
    @IBOutlet weak var startButton: UIButton!
    @IBOutlet weak var resetButton: UIButton!
    @IBOutlet weak var saveButton: UIButton!
    @IBOutlet weak var dateLabel: UILabel!
    
    //スタート・ストップを切り替える
    @IBAction func startButtonAction(_ sender: Any){
        
        if (switch_flg){
            switch_flg = false
            timer.invalidate()
            self.startTime = Date.timeIntervalSinceReferenceDate
            self.timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(timerCounter), userInfo: nil, repeats: true)
            startButton.setTitle("ストップ", for: .normal)
        } else {
            switch_flg = true
            timer.invalidate()
            startButton.setTitle("スタート", for: .normal)
        }
        
    }
    
    
    //タイマーカウンターの時間・分・秒の設定
    @objc func timerCounter() {
        
        guard let startTime = self.startTime else { return }
        let time = Date.timeIntervalSinceReferenceDate - startTime
        let hour = Int(time / 3600)
        let min = Int(time / 60) % 60
        let sec = Int(time) % 60
        self.timerLabel.text = String(format: "%02d:%02d:%02d", hour, min, sec)
    }
    
    @IBAction func resetButtonAction(_ sender: Any){
        self.startTime = nil
        self.timerLabel.text = "00:00:00"
        
    }
    
    @IBOutlet weak var textField: UITextField!
    
    var pickerView: UIPickerView = UIPickerView()
    let list = ["授業準備", "教材研究", "学習評価や成績処理", "学校行事の準備・運営", "学校徴収金の徴収・管理", "課題のある児童生徒・家庭への対応", "会議の事前準備・事後処理", "その他"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //ボタンを丸くする
        startButton.layer.cornerRadius = 60 //角を丸くする
        let borderColor = UIColor(red: 0/255, green: 60/255, blue: 148/255, alpha: 1.0).cgColor
        startButton.layer.borderColor = borderColor //枠線の色
        startButton.layer.borderWidth = 1.0 //枠線の太さ
        
        resetButton.layer.cornerRadius = 50
        resetButton.layer.borderColor = borderColor
        resetButton.layer.borderWidth = 1.0
        
        saveButton.layer.cornerRadius = 50
        saveButton.layer.borderColor = borderColor
        saveButton.layer.borderWidth = 1.0
        
        pickerView.delegate = self
        pickerView.dataSource = self
        let toolbar = UIToolbar(frame: CGRectMake(0, 0, 0, 35))
        let doneItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(TimerViewController.done))
        toolbar.setItems([doneItem], animated: true)
        
        self.textField.inputView = pickerView
        self.textField.inputAccessoryView = toolbar
        self.textField.placeholder = "選択してください"
        
        
    }
    
    
    
    
    //UIPickerViewの列の数
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    //UIPickerViewの行数、要素の全般
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return list.count
    }
    
    //UIPickerViewに表示する配列（各タイトル）
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return list[row]
    }
    
    //ドラムロール選択時
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        self.textField.text = list[row]
        
    }
    
    
    func cancel() {
        self.textField.text = ""
        self.textField.endEditing(true)
    }
    
    @objc func done() {
        self.textField.endEditing(true)
    }
    //座標を指定する
    func CGRectMake(_ x: CGFloat, _ y: CGFloat, _ width: CGFloat, _ height: CGFloat) -> CGRect {
        return CGRect(x: x, y: y, width: width, height: height)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
        
    }
    
    // 保存ボタンを押したときのアクション
    @IBAction func saveButtonAction() {
        guard let _ = textField.text else { return }
        self.dismiss(animated: true)
        
        
        if let text = textField.text, !text.isEmpty {
            //保存が無事に終わったら、アラートを表示してユーザーに完了したことを知らせる
            save()
            let alert = UIAlertController(
                title: "保存完了",
                message: "保存したデータは、一覧に表示されます。",
                preferredStyle: .alert
            )
            alert.addAction(UIAlertAction(
                title: "OK",
                style: .default,
                handler: nil
            ))
            //アラートを表示する
            present(alert, animated: true, completion: nil)
            
        } else {
            let alert = UIAlertController(
                title: "エラー",
                message: "項目が入力されていません",
                preferredStyle: .alert
            )
            alert.addAction(UIAlertAction(
                title: "入力し直す",
                style: .default,
                handler: nil
            ))
            //アラートを表示する
            present(alert, animated: true, completion: nil)
            return
        }
    }
    
    // 項目名・時間・日付を保存するメソッド
    func save() {
        guard let koumokuText = textField.text else { return }
        let kiroku = Kiroku()
        kiroku.subject = koumokuText
        guard let timerText = timerLabel.text else { return }
        kiroku.duration = timerText
        
        //セクションに保存した日付が表示されるようにする
        let now = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "ja_JP")
        dateFormatter.dateFormat = "yyyy/M/d"
        let dateString = dateFormatter.string(from: now)
        
        dateFormatter.dateFormat = DateFormatter.dateFormat(fromTemplate: "EEEEE", options: 0, locale:  Locale.current)
        let dayOfTheWeek = dateFormatter.string(from: now)
        
        let nowDateString = dateString + " (" + dayOfTheWeek + ")"
        kiroku.recordDateString = nowDateString
        
        let oldKirokuArray = Array(realm.objects(Kiroku.self)).filter { k in
            k.recordDateString == nowDateString
        }.filter { k in
            k.subject == koumokuText
        }
        
        //Realmに保存する
        try! realm.write(){
            realm.add(kiroku)}
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        //Labelに日付を表示
        dateLabel.text = recordData()
    }
    
    //今日の日付を取得
    func recordData() -> String{
        let now = Date()
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy年M月d日"
        formatter.locale = Locale(identifier: "ja_JP")
        return formatter.string(from: now as Date)
    }
    
    
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
}

