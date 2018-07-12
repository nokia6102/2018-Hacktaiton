import UIKit
import Firebase
import FirebaseDatabase

class QListViewController: UIViewController,UITableViewDelegate,UITableViewDataSource{
  
    var ref ,refQ ,refA,refCountResponse: DatabaseReference!
    var arrTable = [[String:Any]]()
    var arrQTable = [[String:Any]]()
    var tableOk = false
    var selectQ = 0
    var firstVC : QAViewController?
    var lid = 0
    var id = 0   //Question id
  @IBOutlet weak var lblTimestamp: UILabel!
  @IBOutlet weak var lblTitle: UILabel!
  @IBOutlet weak var lblDesc: UILabel!
    @IBOutlet weak var totalReponse: UILabel!
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
      ref = Database.database().reference(fromURL: "https://trainforswift-f4067.firebaseio.com")
      refQ = ref.child("Q")
      refA = ref.child("A")
      refCountResponse = ref.child("CounterResopne")
      
        readQList()
        readAList()
        
        
      
        //透明NavigationBar背景
        UINavigationBar.appearance().shadowImage = UIImage()
        UINavigationBar.appearance().setBackgroundImage(UIImage(), for: .default)
    }
  
  func readQList()
  {
    
    refQ.observe(.value, with: { (snapshot) in
      
      self.arrQTable.removeAll()
      for child in snapshot.children
      {
        let Value:DataSnapshot = child as! DataSnapshot
        
        let  myValue = Value.value!
        
        if let dictionary  = myValue as? [String : Any]
        {
          self.arrQTable.append(dictionary)
        }
      }
  
      print("Qall:\(self.arrQTable)")
      print("Qcount:\(self.arrQTable.count)")
      self.lblTitle.text = self.arrQTable[self.selectQ]["Title"] as? String
      self.lblDesc.text = self.arrQTable[self.selectQ]["Description"] as? String
      self.lblTimestamp.text = self.arrQTable[self.selectQ]["TimeStamp"] as? String

//      self.lid =  (self.arrQTable[self.selectQ]["lid"] as? Int)!
      self.id =  (self.arrQTable[self.selectQ]["Id"] as? Int)!
      
      print ("sQid:\(self.id)")
    })
    
  }
  
    func readAList()
    {
      
        refA.observe(.value, with: { (snapshot) in
          
            self.arrTable.removeAll()
            for child in snapshot.children
            {
                let Value:DataSnapshot = child as! DataSnapshot
                
                let  myValue = Value.value!
                
                if let dictionary  = myValue as? [String : Any]
                {
                    if dictionary["QNoId"] as! Int == self.id
                    {
                        self.arrTable.append(dictionary)
                    }
                }
            }
            self.tableOk = true
            self.tableView.reloadData()

          
            print("all:\(self.arrTable)")
            print("count:\(self.arrTable.count)")
            self.totalReponse.text = "回應 \(self.arrTable.count)"
            self.refCountResponse.child("\(self.id)").setValue([
              "\(self.id)":self.arrTable.count])
        })
      
    }
    
    
    @IBAction func unwindToQlistVC(segue:UIStoryboardSegue) { print ("回來Qlist VC") }
  
  
    @IBAction func tagRightButton(_ sender: Any)
    {
        print("按了")
        self.dismiss(animated: true, completion: nil)
    }
    
 
    

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrTable.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
       
        let cell = tableView.dequeueReusableCell(withIdentifier: "QACell", for: indexPath) as! QATableViewCell
        if (tableOk)
        {
            cell.lblDescription.text = arrTable[indexPath.row]["ResponseText"] as? String
        }
        return cell
    }
    
 
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
      
      
      if segue.identifier == "sgAVC"
      {
        let secondVC = segue.destination as! AViewController
        secondVC.preVC = self
//        secondVC.lid = self.lid
        secondVC.id = self.id
      
      }
      else
      {
        print ("other")
      }
     }
  
  
}
