
import UIKit
import Reachability
import PKHUD

class ViewController: UIViewController
    {
    let reachability = Reachability()!
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        NotificationCenter.default.addObserver(self,selector: #selector(self.reachabilityChanged(note:)), name: .reachabilityChanged, object: reachability)
        do{
            try reachability.startNotifier()
        }catch{
            print("could not start reachability notifier")
        }
        
    }
   
        @IBAction func unwindToMainMenu(segue:UIStoryboardSegue) { print ("回來第一個Menu") }
    
    func reachabilityChanged(note: Notification) {
        
        let reachability = note.object as! Reachability
        
        switch reachability.connection {
        case .wifi:
            print("Reachable via WiFi")
            PKHUD.sharedHUD.hide(afterDelay: 1.0) { success in
                // Completion Handler
            }
        case .cellular:
            print("Reachable via Cellular")
            PKHUD.sharedHUD.hide(afterDelay: 1.0) { success in
                // Completion Handler
            }
        case .none:
            print("Network not reachable")
            PKHUD.sharedHUD.contentView = PKHUDTextView(text: "無網路連接，請檢查網路")
            PKHUD.sharedHUD.show()
            Timer.scheduledTimer(withTimeInterval: 5.0, repeats: false){
                (timer) in
                PKHUD.sharedHUD.hide()
            }
            
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}

