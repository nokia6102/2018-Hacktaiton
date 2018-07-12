import UIKit
import youtube_ios_player_helper
import Firebase
import FirebaseDatabase

class PlayerController: UIViewController,UITableViewDelegate,UITableViewDataSource,YTPlayerViewDelegate{
  
    enum ccStyle: Int {
        case cc = 1, url
    }
    
    @IBOutlet weak var progressMovie: UIProgressView!
    @IBOutlet weak var playerView: YTPlayerView!
    @IBOutlet weak var btnPlay: UIButton!
    @IBOutlet weak var durtionTime: UILabel!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var durntionTime: UILabel!
   
    @IBOutlet weak var playerTitle: UILabel!
    
  @IBOutlet weak var subTimeMark: UILabel!
  @IBOutlet weak var btnAnswer: UIButton!
  
//    weak var firstVC:UIViewController!
    weak var firstVC:MainViewController?
    var tableOk = false
    var bufferOk = true
    var ref,refQCount : DatabaseReference!
    private var arrTable = [[String:Any]]()
    var playvideCode = "3AaTfGSfBmw"
    var selectVideo = 0
//    var cc = "0"
    var ccFlag = false
    var openwebFlag = false
                                        //   加uiview中文放                     字幕                  放完不放連結 //                                            一用就會出現youtube水印
    
    override func viewWillAppear(_ animated: Bool) {
        print ("in:")
        if UIDeviceOrientationIsLandscape(UIDevice.current.orientation){
            print("橫")
            let playerVars: [AnyHashable: Any]  = [ "playsinline": 0 ,"cc_load_policy":1 ,"rel":0,"showinfo":1,"modestbranding":1 , "autoplay":1 ]
        
            
            print ("trustfer selectVide : \(self.selectVideo)")
            let playCode = self.firstVC?.arrTable[selectVideo]["videocode"] as! String
//            ccFlag = (self.firstVC?.arrTable[selectVideo]["cc"] as! String ) ==  "\(ccStyle.cc.rawValue)"
//            openwebFlag = (self.firstVC?.arrTable[selectVideo]["cc"] as! String ) == "\(ccStyle.url.rawValue)"
            playerTitle.text = self.firstVC?.arrTable[selectVideo]["title"] as? String
            let lid = self.firstVC?.arrTable[selectVideo]["lid"] as! String
            self.playerView.load(withVideoId: playCode,playerVars: playerVars)

        }else{
            print("直")
        }
      
      readCounter()
    }
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
//        Database.database().isPersistenceEnabled = true
        
        let playerVars: [AnyHashable: Any]  = [ "playsinline": 1 ,"cc_load_policy":1 ,"rel":0,"showinfo":1,"modestbranding":1 , "autoplay":1 ]

       
        print ("trustfer selectVide : \(self.selectVideo)")
        let playCode = self.firstVC?.arrTable[selectVideo]["videocode"] as! String
        ccFlag = (self.firstVC?.arrTable[selectVideo]["cc"] as! String ) == "1"
        openwebFlag = (self.firstVC?.arrTable[selectVideo]["cc"] as! String ) == "2"
        
        playerTitle.text = self.firstVC?.arrTable[selectVideo]["title"] as? String
        let lid = self.firstVC?.arrTable[selectVideo]["lid"] as! String
      
      
        self.playerView.load(withVideoId: playCode,playerVars: playerVars)
        
        let refBase = "\(FirebaseDatabase.Database.database().reference())"
        ref = Database.database().reference(fromURL: "\(refBase)/SubTitle").child(lid)
        refQCount = Database.database().reference(fromURL: "\(refBase)/Counter")
        
//        ref = Database.database().reference(fromURL: "https://trainforswift-f4067.firebaseio.com/SubTitle").child(lid)
//        refQCount = Database.database().reference(fromURL: "https://trainforswift-f4067.firebaseio.com/Counter")
      
        self.playerView.delegate = self
       
   
        if openwebFlag
        {
            readDic()
        }
        else if ccFlag
        {
            readDic()
        }
        else
        {
            let endDic : Dictionary = ["totalStartTime": Float(self.playerView.duration()+1), "number": 1, "startTime": "00:00:03,670", "stopTime": "00:00:11,929", "text": "* 無字幕 *"
                ] as [String : Any]
            
            self.arrTable.append(endDic)
        }
    }
    
  func readCounter()
  {
    refQCount.observe(.value, with: { (snapshot) in
      
      let postDict = snapshot.value as? [String : AnyObject] ?? [:]
      
      print ("postDict: \(postDict)")
      let pNum = postDict["Qcount"] as! Int
      
      
      print ("pNum \(pNum)")
      
      let p = "問答 (\(pNum))"
      self.btnAnswer.setTitle( p, for: .normal)
    })
    
  }
  
    
    func readDic()
    {
        
        ref.observe(.value, with: { (snapshot) in
            
            self.arrTable.removeAll()
            for child in snapshot.children
            {
                let Value:DataSnapshot = child as! DataSnapshot
                
                let  myValue = Value.value!
                
                if var dictionary  = myValue as? [String : Any]
                {
                    print(dictionary["number"] ?? "x")
                    let sourceTime = dictionary["startTime"] as! String
//                    print("s:\(sourceTime)")
                    let index = sourceTime.index(sourceTime.startIndex, offsetBy: 8)
                    let time  =  sourceTime.substring(to: index)
//                    print ("t:\(time)")
                    let partsTime = time.components(separatedBy: ":")
//                    print("p:\(partsTime)")
                    let totalTime = Int(partsTime[0])! * 3600 + Int(partsTime[1])! * 60 + Int(partsTime[2])!
                    print ("t:\(totalTime)")
                    dictionary["totalStartTime"] = Float(totalTime)
                    self.arrTable.append(dictionary)
                }
            }
            
            if self.ccFlag {
            let endDic : Dictionary = ["totalStartTime": Float(self.playerView.duration()), "number": 1, "startTime": "00:00:03,670", "stopTime": "00:00:11,929", "text": "* 字幕結尾 *"
            ] as [String : Any]
            self.arrTable.append(endDic)
            }
            
            print("all:\(self.arrTable)")
            print("count:\(self.arrTable.count)")
            self.tableView.reloadData()
            self.tableOk = true
            
         
            
            //選擇在第一行
            let selIndexPath = IndexPath(row: 0 , section: 0)
            self.tableView.selectRow(at: selIndexPath, animated: true, scrollPosition: .middle)
//             self.playerView.load(withVideoId: self.playvideCode,playerVars:  ["playsinline": 0])
         
        })
     
    }

        
    @IBAction func tapPlay(_ sender: UIButton)
    {
        playerView.playVideo()
    }
    

    @IBAction func unwindToPlayerVC(segue:UIStoryboardSegue) { print ("回來") }
    
    //Mark:- YTPLayerViewDelegate
    func playerView(_ playerView: YTPlayerView, didPlayTime playTime: Float) {
   
        let nowPlay:Float = Float(playTime)
        let totoal :Float = Float(self.playerView.duration())
        let progress:Float = Float(nowPlay / totoal)
        print ("prgress:\(nowPlay)/\(totoal)=\(progress)")
        progressMovie.progress = Float(progress)
        
        if (tableOk && ccFlag)
        {
            let lastNumberOfSections = self.tableView.numberOfRows(inSection: 0)
            print ("lst:\(lastNumberOfSections)")
        
            let selectedIndexPath = tableView.indexPathForSelectedRow!.row
    
            print ("sel:\(selectedIndexPath)")
          
            if selectedIndexPath < lastNumberOfSections - 1
            {
                print ("自動slip:\(selectedIndexPath)")
                let currTime = arrTable[selectedIndexPath]["totalStartTime"] as! Float
                let nextTime = arrTable[selectedIndexPath+1]["totalStartTime"] as! Float
                print ("nextTime:\(nextTime)")
                
             
                if playTime >= nextTime
                {
                    if (playTime - nextTime) <= (nextTime-currTime)
                        {
                    let indexPath = IndexPath(row: selectedIndexPath+1 , section: 0)
                    self.tableView.selectRow(at: indexPath, animated: true, scrollPosition: .middle)
                    self.tableView.scrollToRow(at: indexPath, at: UITableViewScrollPosition.middle, animated: true)
                    }
                    else
                    {
                        let indexPath = IndexPath(row: selectedIndexPath , section: 0)
                        self.tableView.selectRow(at: indexPath, animated: true, scrollPosition: .middle)
                        self.tableView.scrollToRow(at: indexPath, at: UITableViewScrollPosition.middle, animated: false)
                    }
                }
            }
        }
     
    }
    
    func playerViewDidBecomeReady(_ playerView: YTPlayerView) {
         self.playerView.playVideo()
         let Mintues = Int(self.playerView.duration() / 60)
         let Hours = Int(Mintues / 60)
         let elepaseTime = String(format: "視頻: %02d:%02d 分鐘", Hours, Mintues)
         print ("tt:\(elepaseTime)")
        subTimeMark.text = elepaseTime
    }
    
    func playerView(_ playerView: YTPlayerView, didChangeTo state: YTPlayerState) {
        switch state {
        case .buffering:
            bufferOk = false
        case .playing:
            bufferOk = true
        default:
             break
        }
        
    }
   
    //Mark:- tableView Delegate
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrTable.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PlayerCell", for: indexPath) as! PlayerTableViewCell
        cell.lblSubtitle.text = arrTable[indexPath.row]["text"] as? String
        return cell
    }
    
    func open(scheme: String) {
        if let url = URL(string: scheme) {
            if #available(iOS 10, *) {
                UIApplication.shared.open(url, options: [:],
                                          completionHandler: {
                                            (success) in
                                            print("Open \(scheme): \(success)")
                })
            } else {
                let success = UIApplication.shared.openURL(url)
                print("Open \(scheme): \(success)")
            }
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
      print ("buffer OK:\(bufferOk)")
        if tableOk && bufferOk
        {
            
            if ccFlag
            {
                let lastNumberOfSections = self.tableView.numberOfRows(inSection: 0)
                
                print ("i:\(indexPath.row) ,lstN:\(lastNumberOfSections)")
                if indexPath.row >= lastNumberOfSections - 2
                {
                    self.playerView.pauseVideo()
                    return
                }
                
                let toTime : Float = arrTable[indexPath.row]["totalStartTime"] as! Float
                playerView.seek(toSeconds: toTime, allowSeekAhead: true)
                let indexPath = IndexPath(row: indexPath.row , section: 0)
                self.tableView.scrollToRow(at: indexPath, at: UITableViewScrollPosition.middle, animated: true)
            }
            else if openwebFlag
            {
                let openurl : String = arrTable[indexPath.row]["text"] as! String
//                guard let url = URL(string: openurl) else {
//                    return //be safe
//                }
                open(scheme: openurl)
            }
     }
    
    
    
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
    
}
}
