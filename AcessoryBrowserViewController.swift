//
//  AcessoryBrowserViewController.swift
//  
//
//  Created by Matheus Amancio Seixeiro on 9/3/15.
//
//

import UIKit
import HomeKit

class AcessoryBrowserViewController: UIViewController, HMHomeManagerDelegate,UITableViewDelegate,UITableViewDataSource,HMAccessoryBrowserDelegate {
    
    var homeManager: HMHomeManager!
    var acessories = [HMAccessory]()
    var home: HMHome!
    var room: HMRoom!
    
    @IBOutlet weak var tableview: UITableView!
    
    lazy var acessoryBrowser: HMAccessoryBrowser = {
        let browser = HMAccessoryBrowser()
        browser.delegate = self
        return browser
    }()
    
    var homeName = "Minha Casa 11"
    
    let roomName = "bedroom 1"
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        homeManager = HMHomeManager()
        homeManager.delegate = self
    }
    
    func homeManagerDidUpdateHomes(manager: HMHomeManager) {
        manager.addHomeWithName(homeName, completionHandler: { (home: HMHome?, error: NSError?) -> Void in
            if error != nil {
                print("nao adicionou a casa")
            } else {
                let strongSelf = self
                strongSelf.home = home
                print("Successfully added a home")
                print("Adding a room to the home...")
                home.addRoomWithName(strongSelf.roomName, completionHandler: {
                    (room: HMRoom?, error: NSError?) in
                    
                    if error != nil{
                        print("Failed to add a room...")
                    } else {
                        strongSelf.room = room
                        print("Successfully added a room.")
                        print("Discovering accessories now...")
                        strongSelf.acessoryBrowser.startSearchingForNewAccessories()
                    }
                })
            }
        })
    }
    
    func accessoryBrowser(browser: HMAccessoryBrowser, didFindNewAccessory accessory: HMAccessory){
        print("encontrou accessorio", terminator: "")
        print("adicionando ele na casa")
        print("qual o nome dele: ")
        print("\(accessory)")


        home.addAccessory(accessory, completionHandler: { (error: NSError?) -> Void in
            if error != nil{
                print(" falhou ")
                print("error = \(error)")
            } else{
                print("adicionou o acessorio a casa")
                self.home.assignAccessory(accessory, toRoom: self.room, completionHandler: { (error:NSError?) -> Void in
                    if error != nil {
                        print("nao adiocionou acessorio no quarto")
                        print("erro = \(error)")
                    } else {
                        print(" uuuuha ")
                        self.findServicesForAccessory(accessory)
                    }
                })
            }
        })
    }
    
    func findServicesForAccessory(acessorio: HMAccessory){
        print("procurando servicos desse acessorio")
        for service in acessorio.services {
            print(" Service name = \(service.name)")
            print(" Service type = \(service.serviceType)")
            
            print("procurando caracteristicas do serviço")
            self.findCharacteristicsOfService(service)
        }
    }
    
    func findCharacteristicsOfService(service: HMService){
        for characteristic in service.characteristics {
            print("tipo de caracteristica = "+" \(characteristic.characteristicType)")
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func accessoryBrowser(browser: HMAccessoryBrowser, didRemoveNewAccessory accessory: HMAccessory) {
        print("accessorio removido")
    }
    
     func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return acessories.count
    }
    
     func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = self.tableview.dequeueReusableCellWithIdentifier("cellz") as! UITableViewCell
        let accessory = acessories[indexPath.row] as HMAccessory
        cell.textLabel?.text = accessory.name
        return cell
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
