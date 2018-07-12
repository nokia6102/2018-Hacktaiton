import UIKit
import Firebase

class TQViewController: UIViewController,UITextViewDelegate,UIPickerViewDelegate,UIPickerViewDataSource {
  
  
  @IBOutlet weak var txtInputQ:UITextView!
  @IBOutlet weak var pickView: UIPickerView!
  
    var pressSave = false
    var ref ,refQ, refLesson ,refCounter : DatabaseReference!
    var arrTable = [[String:Any]]()
  var nextQcount = 0
    var pickerOK = false
    var selectedValue:String = ""
    var selectL = 0
    override func viewDidLoad() {
        super.viewDidLoad()
     
      ref = Database.database().reference(fromURL: "https://trainforswift-f4067.firebaseio.com")
      refQ = ref.child("Q")
      refLesson = ref.child("Lesson")
      refCounter = ref.child("Counter")
      
      readCounter()
      readLessionList()
      setDoneOnKeyboard()
      pressSave = true
      txtInputQ.textColor = UIColor.lightGray
      txtInputQ.delegate = self
  }

  @IBAction func unwindToTQVC(segue:UIStoryboardSegue) { print ("回來QTVC") }
 
  func readCounter()
  {
    refCounter.observe(.value, with: { (snapshot) in
      
      let postDict = snapshot.value as? [String : AnyObject] ?? [:]

      print ("postDict: \(postDict)")
      self.nextQcount = postDict["Qcount"] as! Int + 1
    })
    
  }
  
  func readLessionList()
  {
    
    refLesson.observe(.value, with: { (snapshot) in
      
      self.arrTable.removeAll()
      for child in snapshot.children
      {
        let Value:DataSnapshot = child as! DataSnapshot
        
        let  myValue = Value.value!
        
        if let dictionary  = myValue as? [String : Any]
        {
          self.arrTable.append(dictionary)
        }
      }
      self.pickerOK = true
      self.pickView.reloadAllComponents()

      print("all:\(self.arrTable)")
      print("count:\(self.arrTable.count)")
      
      
    })
    
  }
  
  
  
  //MARK: UITextViewDelegate實作區
  func textViewDidBeginEditing(_ textView: UITextView)
  {
    if textView.textColor == UIColor.lightGray {
      textView.text = nil
      textView.textColor = UIColor.black
      textView.textAlignment = .left
    }
  }
  
  func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
       selectedValue = arrTable[pickView.selectedRow(inComponent: 0)]["title"] as! String
       selectL = row
  }
  
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return  arrTable.count
    }
  
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
      
      selectedValue = arrTable[pickView.selectedRow(inComponent: 0)]["title"] as! String

        return arrTable[row]["title"] as? String
    }
  
  func setDoneOnKeyboard() {
    let keyboardToolbar = UIToolbar()
    keyboardToolbar.sizeToFit()
    let flexBarButton = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
    let doneBarButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(self.dismissKeyboard))
    keyboardToolbar.items = [flexBarButton, doneBarButton,flexBarButton]
    self.txtInputQ.inputAccessoryView = keyboardToolbar
  }
  
  @IBAction func closeButton(_ sender: Any)
  {
    print("按提出問題的close")
      
          pressSave = false
          _ = navigationController?.popViewController(animated: true)   //回上一層
    
  }

  
@IBAction  func dismissKeyboard() {
  print ("縮了鍵盤")
  view.endEditing(true)
  }

  
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    
    if pressSave
    {
       let refQlist = refQ.childByAutoId()
      print ("*nextQcount:\(nextQcount)")
      let postInfo = ["Category" : "D1",
                      "uid": "輸入者",
                      "Description":txtInputQ.text!,
                      "lid": selectL + 1,
                      "Id" : nextQcount ,
                      "Title": selectedValue,
                      "TimeStamp": ServerValue.timestamp() ] as [String : Any]
      
      refQlist.setValue(postInfo)
    
      let putInfo = [ "Qcount" : nextQcount ]
      refCounter.setValue(putInfo)
      }
  dismissKeyboard()
  }

}
