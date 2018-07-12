import UIKit
import Firebase


class AViewController: UIViewController,UITextViewDelegate {

  var preVC : QListViewController?
  
  var ref,refA : DatabaseReference!
  @IBOutlet weak var txtName: UITextField!
  @IBOutlet weak var lblTimeStamp: UILabel!
  @IBOutlet weak var lblTitle: UILabel!
  @IBOutlet weak var lblDesc: UILabel!
  @IBOutlet weak var txtResponse: UITextView!
  var lid:Int?
  var id:Int?
  var pressSave = false
    override func viewDidLoad() {
        super.viewDidLoad()
      pressSave = true
      txtName.text =  "some body"
      lblTimeStamp.text = preVC?.lblTimestamp.text
      lblTitle.text = preVC?.lblTitle.text
      lblDesc.text = preVC?.lblDesc.text
      self.id = preVC?.id
      print ("*Qid :\(String(describing: self.id))")
      ref = Database.database().reference(fromURL: "https://trainforswift-f4067.firebaseio.com")
      refA = ref.child("A")
      txtResponse.text = "請輸入"
      txtResponse.textColor = UIColor.lightGray
      txtResponse.delegate = self
      
   }

  @IBAction func closeButton(_ sender: Any)
  {
    print("按了close")
    pressSave = false
    //    self.dismiss(animated: true, completion: nil)         //退掉整個navgation Controller
    _ = navigationController?.popViewController(animated: true)   //回上一層
  
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
  
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
      
      if pressSave
      {
        let refADic = refA.childByAutoId()
        
        //QNoId ,lid  to Any 不會報黃色
        let postInfo = [
                        "ResponseUserName": txtName.text!,
                        "ResponseText":txtResponse.text!,
                        "QNoId" : self.id as Any,
                        "Id" : self.lid as Any ,
                        "Title": lblTitle.text!,
                        "TimeStamp": ServerValue.timestamp() ] as [String : Any]
        
        refADic.setValue(postInfo)
      }
  
  }
  

}
