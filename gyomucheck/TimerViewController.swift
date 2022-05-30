//
//  TimerViewController.swift
//  gyomucheck
//
//  Created by Meri Sato on 2022/05/23.
//

import UIKit


class TimerViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    
    
    
    var startTime: TimeInterval? = nil
    var timer = Timer()
    //一時停止の際の時間を格納する
    var pauseTime:Float = 0
    
    @IBOutlet weak var timerLabel: UILabel!
    var switch_flg:Bool = true
    
    @IBOutlet weak var startButton: UIButton!
    @IBOutlet weak var resetButton: UIButton!
    @IBOutlet weak var saveButton: UIButton!
    
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
            
        }
    
    
        //表示列
        func numberOfComponents(in pickerView: UIPickerView) -> Int {
            return 1
        }
    
        func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
            return list.count
        }

        func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
            return list[row]
        }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        self.textField.placeholder = "選択してください"
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
    
    

}

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

