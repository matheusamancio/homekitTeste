//
//  AcessoryBrowserViewController.swift
//  
//
//  Created by Matheus Amancio Seixeiro on 9/3/15.
//
//

import UIKit
import HomeKit

class AcessoryBrowserViewController: UIViewController, HMHomeManagerDelegate, HMAccessoryBrowserDelegate {
    
    var homeManager: HMHomeManager!
    var acessories = [HMAccessory]()
    var home: HMHome!
    var room: HMRoom!
    
    lazy var acessoryBrowser: HMAccessoryBrowser = {
        let browser = HMAccessoryBrowser()
        browser.delegate = self
        return browser
    }()
    
    var homeName = "Minha Casa"
    
    let roomName = "bedroom 1"
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        homeManager = HMHomeManager()
        homeManager.delegate = self
    }
    
    func homeManagerDidUpdateHomes(manager: HMHomeManager) {
        manager.addHomeWithName(homeName, completionHandler: { (home: HMHome!, error: NSError!) -> Void in
            if error != nil {
                print("nao adicionou a casa")
            } else{
//                let strongSelf = self!
//                strongSelf.home = home
                println("adicionou")
                println("adicionando quarto pra casa...")
                home.addRoomWithName(self.roomName, completionHandler: { (room: HMRoom!, error: NSError!) -> Void in
                    if error != nil{
                        print("failed to add a room")
                    } else{
                        self.acessoryBrowser.startSearchingForNewAccessories()
                    }
                })
            }
        })
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    // uha

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
