import UIKit
import Firebase
import FirebaseDatabase


class QAViewController: UIViewController,UITableViewDelegate,UITableViewDataSource{
    
    var aDic : [[String:Any]] = []
    var responesDic : [String:Any] = [:]
    var ref,refQ,refCounterResponse,refQcount : DatabaseReference!
    var tableOk = false
    var selectQ : Int = 0
    var seleL : Int = 0
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        let refBase = "\(FirebaseDatabase.Database.database().reference())"
        ref = Database.database().reference(fromURL: refBase)
        refQ = ref.child("Q")
        refQcount = ref.child("Counter")
        refCounterResponse = ref.child("CounterResopne")
        readCounter()
        readQAList()
        readResList()
        
        print(aDic)
        
        //透明NavigationBar背景
        UINavigationBar.appearance().shadowImage = UIImage()
        UINavigationBar.appearance().setBackgroundImage(UIImage(), for: .default)
        
        
    }
    
    
    
    
    
    func readCounter()
    {
        refQcount.observe(.value, with: { (snapshot) in
            
            let postDict = snapshot.value as? [String : AnyObject] ?? [:]
            
            print ("postDict: \(postDict)")
            let pNum = postDict["Qcount"] as! Int
            print ("pNum \(pNum)")
            let p = "問答列表(\(pNum))"
            self.navigationItem.title = p
        })
        
    }
    
    func readQAList()
    {
        
        refQ.observe(.value, with: { (snapshot) in
            
            self.aDic.removeAll()
            print ("=====")
            for child in snapshot.children
            {
                let Value:DataSnapshot = child as! DataSnapshot
                
                let  myValue = Value.value!
                
                if let dictionary  = myValue as? [String : Any]
                {
                    self.aDic.append(dictionary)
                }
            }
            self.tableView.reloadData()
        })
        
    }
    
    
    func readResList()
    {
        
        refCounterResponse.observe(.value, with: { (snapshot) in
            
            
            print ("child: \(snapshot.children)")
            for child in snapshot.children
            {
                let Value:DataSnapshot = child as! DataSnapshot
                
                let  myValue = Value.value!
                print ("myValue: \(myValue)")
                if let dictionary  = myValue as? [String : Any]
                {
                    // 上方三個分別列印：
                    // 未強轉之前的所有key:LazyMapCollection<Dictionary<String, Any>, String>(_base: ["name": "CoderSun", "age": 18, "height": 180, "gender": "男"], _transform: (Function))
                    // 強轉之後的所有key:["name", "age", "height", "gender"]
                    // ["CoderSun", 18, 180, "男"]
                    
                    //* Array 用意為 解出LazyMapCollection為Array才能用值，不然為還有一層Dictionary
                    print("強轉之後的所有key:\(Array(dictionary.keys)[0])")    //取第一個，注意不要用.first不然會有代Optional還要解包或做其他處理在此麻煩
                    print(Array(dictionary.values)[0])
                    
                    self.responesDic["\(Array(dictionary.keys)[0])"] = Array(dictionary.values)[0]
                }
            }
            
            
            print ("res dic: \(self.responesDic)")
            self.tableOk = true
            self.tableView.reloadData()
            
        })
        
    }
    
    @IBAction func unwindToPlayerQAVC(segue:UIStoryboardSegue) { print ("回來QAVC") }
    
    
    
    @IBAction func tagRightButton(_ sender: Any)
    {
        print("按了")
        self.dismiss(animated: true, completion: nil)
    }
    
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        print ("aDic:\(aDic)")
        
        selectQ = indexPath.row
        
        //    selectQ = aDic[indexPath.row]["lid"] as! Int
        print ("sQ:\(selectQ)")
        performSegue(withIdentifier: "sgQlist", sender: self)
        
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return aDic.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "QACell", for: indexPath) as! QATableViewCell
        cell.lblTitle.text = aDic[indexPath.row]["Title"] as? String
        cell.lblDescription.text = aDic[indexPath.row]["Description"] as? String
        let sJdraw = "講座 \(aDic[indexPath.row]["lid"] ?? "0")"
        
        let qNum = aDic[indexPath.row]["Id"] as! Int    //得到問題的id流水號
        let key =  String(qNum)                         //把id轉成key(字串)
        //查responseDic 字典，沒有(nil)則為0則回應
        cell.lblResponse.text = sJdraw +  " ／ \(responesDic[key] ?? 0)" + " 回應"
        
        return cell
    }
    
    
    
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        print("轉換到其他頁")
        
        if segue.identifier == "sgQlist"
        {
            print ("發動sgQlist")
            let nextVC = segue.destination as! QListViewController
            nextVC.firstVC = self
            print ("s1:\(self.selectQ)")
            nextVC.selectQ = self.selectQ
        }
        
    }
    
    
}
