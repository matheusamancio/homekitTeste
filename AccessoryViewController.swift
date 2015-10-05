//
//  AccessoryViewController.swift
//  
//
//  Created by Matheus Amancio Seixeiro on 9/8/15.
//
//

import UIKit
import HomeKit


class AccessoryViewController: UIViewController, HMAccessoryBrowserDelegate, UITableViewDataSource, UITableViewDelegate, HMHomeManagerDelegate {

    
    let switchServiceGroupName = "panela"
    var switchServiceGroup: HMServiceGroup?
    var homeManager: HMHomeManager!
    var home: HMHome!
    var room: HMRoom!
    lazy var acessoryBrowser: HMAccessoryBrowser = {
        let browser = HMAccessoryBrowser()
        browser.delegate = self
        return browser
        }()


    @IBOutlet weak var nameBar: UINavigationItem!
    
    @IBOutlet weak var tableview: UITableView!
    
    override func viewWillAppear(animated: Bool) {
        tableview.reloadData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        nameBar.title = room.name
        findOrCreateSwitchServiceGroup()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        return room.accessories.count

    }

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell{
        let cell = tableview.dequeueReusableCellWithIdentifier("theCell", forIndexPath: indexPath) 
        let accessory = room.accessories[indexPath.row] 
        cell.textLabel?.text = accessory.name
        return cell
    }
    
    
    func findOrCreateSwitchServiceGroup(){
        if let groups = home.serviceGroups{
            for serviceGroup in groups as! [HMServiceGroup]{
                if serviceGroup.name == switchServiceGroupName{
                    switchServiceGroup = serviceGroup
                }
            }
        }
        if switchServiceGroup == nil{
            print("criando o grupo muleque")
            home.addServiceGroupWithName(self.switchServiceGroupName, completionHandler: { (group: HMServiceGroup?, error: NSError?) -> Void in
                if error != nil{
                    print("falha na hora de criar o grupo")
                } else {
                    print("criado com sucesso")
                    self.switchServiceGroup = group
                    self.discoveryServicesInServiceGroup(group)
                }
                
            })
        }
        
    }
    
    func discoveryServicesInServiceGroup(serviceGroup: HMServiceGroup){
        
        addAllSwitchesToServiceGroup(serviceGroup, completionHandler: {
            [weak self](error: NSError!) in
            
            if error != nil{
                print("Failed to add the switch to the service group")
            } else {
                self!.enumerateServicesInServiceGroup(serviceGroup)
            }
            
            })
        
        enumerateServicesInServiceGroup(serviceGroup)
        
    }
    
    func enumerateServicesInServiceGroup(serviceGroup: HMServiceGroup){
        print("descobrindo todos os serviços desse grupo")
        if let services = serviceGroup.services{
            for service in services as! [HMService]{
                print(service.name)
            }
            }
    }
    
    func addAllSwitchesToServiceGroup(serviceGroup: HMServiceGroup,
        completionHandler: ((NSError!) -> Void)?){
        if let accessories = room.accessories{
            for accessory in accessories as! [HMAccessory]{
                if let services = accessory.services{
                    for service in services as! [HMService]{
                        if (service.name as NSString).rangeOfString("switch",
                            options: .CaseInsensitiveSearch).location != NSNotFound{
                                print("encontrado o servico de switch, adicionado no grupo")
                                serviceGroup.addService(service, completionHandler: completionHandler)
                        }
                    }
                }
            }
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "acessory"{
            
            let controller = segue.destinationViewController
                as! SearchAccessoryViewController
            controller.homeManager = homeManager
            controller.home = home
            controller.room = room
        }

        if segue.identifier == "characteristic"{
            let controller = segue.destinationViewController as! CharacteristicViewController
            controller.homeManager = homeManager
            controller.home = home
            controller.room = room
            let myAccessory = room.accessories[tableview.indexPathForSelectedRow!.row] 
            controller.acessory = myAccessory
            
        }
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
