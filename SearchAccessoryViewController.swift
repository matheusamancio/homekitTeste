//
//  SearchAccessoryViewController.swift
//  
//
//  Created by Matheus Amancio Seixeiro on 9/8/15.
//
//

import UIKit
import HomeKit

class SearchAccessoryViewController:  UIViewController, HMAccessoryBrowserDelegate, HMHomeManagerDelegate, UITableViewDelegate, UITableViewDataSource {
    
    
    
    @IBOutlet weak var tableview: UITableView!
    
    var homeManager: HMHomeManager!
    var acessories : [HMAccessory] = []
    var home: HMHome!
    var room: HMRoom!
    lazy var acessoryBrowser: HMAccessoryBrowser = {
        let browser = HMAccessoryBrowser()
        browser.delegate = self
        return browser
        }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let strongSelf = self
        strongSelf.home = home
        strongSelf.room = room
        
        strongSelf.acessoryBrowser.startSearchingForNewAccessories()

        
    }
    override func viewDidDisappear(animated: Bool) {
        self.acessoryBrowser.stopSearchingForNewAccessories()
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        print(acessories.count)
        return acessories.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell{
        let cell = tableview.dequeueReusableCellWithIdentifier("cellop", forIndexPath: indexPath) 
        let acessory = acessories[indexPath.row]
        cell.textLabel?.text = acessory.name
        return cell
    }


    
    func accessoryBrowser(browser: HMAccessoryBrowser, didFindNewAccessory accessory: HMAccessory){
        print(acessories.count)

        print(accessory)
        acessories.append(accessory)
        print("array = \(acessories)")
        tableview.reloadData()
        
    }

    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let accessorio = acessories[indexPath.row]
        print(home)
        home.addAccessory(accessorio, completionHandler: { (error: NSError?) -> Void in
            if error != nil{
                print(" falhou ")
                print("error = \(error)")
            } else{
                print("adicionou o acessorio a casa")
                UIAlertController.showAlertControllOnHostController(self, title: "UUUUHAAA", message: "Adicoinado mano")
                self.home.assignAccessory(accessorio, toRoom: self.room, completionHandler: { (error:NSError?) -> Void in
                    if error != nil {
                        print("nao adiocionou acessorio no quarto")
                        print("erro = \(error)")

                    } else {
                        print(" uuuuha ")
                    }
                })
            }

        })
    

        
    }
    func accessoryBrowser(browser: HMAccessoryBrowser, didRemoveNewAccessory accessory: HMAccessory) {
        tableview.reloadData()
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
