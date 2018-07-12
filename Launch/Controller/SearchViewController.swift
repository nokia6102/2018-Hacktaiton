//
//  SearchViewController.swift
//  Launch
//
//  Created by Leon Cheng on 2018/6/25.
//  Copyright © 2018年 com.USSwiftCoda. All rights reserved.
//

import UIKit

class SearchViewController: UIViewController {
  

    @IBOutlet weak var txtSearch: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
//Taget-Action
    @IBAction func onClick(_ sender: UIButton)
    {
        print ("Onclick")
//        //以storyboard ID初始化下一頁的畫面（如果找不到ID，會產生例外狀況：程式當掉！使用選擇性綁定也無效！）
//        let vc = self.storyboard!.instantiateViewController(withIdentifier: "MainViewController")
//        //顯示下一頁
//        //        show(vc, sender: nil)
//        present(vc, animated: true, completion: nil)
        
    }
    
    //當由轉換線進行換頁時，會呼叫此方法
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        if segue.identifier == "sgMain"
        {
            print ("sgMain")
            //從轉換線取得下一頁的執行實體（此時是UIViewController的視角），並進行SecondViewController的型別轉換
            let secondVC = segue.destination as! MainViewController
            //進行傳遞資訊到下一頁（填入下一頁的屬性值）<值型別傳遞>
//            secondVC.str = "hello"
         //   把自己這一頁的引用傳給下一頁<引用型別傳遞>
                        secondVC.upVC = self
        }
        else if segue.identifier == "segue2"
        {
            print("轉換到其他頁")
        }
    }
    
    }
    


