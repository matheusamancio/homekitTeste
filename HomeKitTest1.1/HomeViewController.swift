//
//  ViewController.swift
//  HomeKitTest1.1
//
//  Created by Matheus Amancio Seixeiro on 8/28/15.
//  Copyright (c) 2015 Matheus Amancio Seixeiro. All rights reserved.
//

import UIKit
import HomeKit





class HomeViewController: UIViewController, HMHomeManagerDelegate, UITableViewDelegate,UITableViewDataSource {
    
    @IBOutlet weak var editButton: UIBarButtonItem!
    // variaveis da Casa
    
    lazy var homeManager: HMHomeManager = {
        let manager = HMHomeManager()
        manager.delegate = self
        return manager
        }()

    
   
    
    @IBOutlet weak var tableView: UITableView!
    
    
    override func viewWillAppear(animated: Bool) {
        tableView.reloadData()

    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.


    }

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        
        let numberOfRowns = homeManager.homes.count
        editButton.enabled = (numberOfRowns > 0)
        
        if numberOfRowns == 0{
            Done()
        }
        
        return numberOfRowns
    }

    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell{
        
        var cell = self.tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath) as! UITableViewCell
        let home = homeManager.homes[indexPath.row] as! HMHome
        cell.textLabel?.text = home.name
        
        
    return cell
    }
    
    func homeManagerDidUpdateHomes(manager: HMHomeManager) {
        tableView.reloadData()
    }
    
//    override func prepareForSegue(segue: UIStoryboardSegue,
//        sender: AnyObject!) {
//            
//            if segue.identifier == "segueIdentifier"{
//                
//                let controller = segue.destinationViewController
//                    as! AddViewController
//                controller.homeManager = homeManager
//                
//            }
//            
//            super.prepareForSegue(segue, sender: sender)
//            
//    }
    

    
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        
        switch editingStyle {
        case .Delete:
            let home = homeManager.homes[indexPath.row] as! HMHome
            homeManager.removeHome(home, completionHandler: { [weak self] (error: NSError!) in
                let strongself = self!
                
                if error != nil{
                    UIAlertController.showAlertControllOnHostController(strongself, title: "Error", message: "An error occurred = \(error)")
                    
                    
                } else{
                    tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
                    
                }
                })
        default:
            return
        }
        

        
    }
    
    
    @IBAction func Edit(sender: AnyObject) {
        if editButton.title == "Edit"{
            isEditingMode()
        } else{
            Done()
        }

    }
    
    func isEditingMode(){
        editButton.title = "Done"
        self.tableView.setEditing(true, animated: true)
        self.navigationItem.rightBarButtonItem?.enabled = false
    }
    
    func Done(){
        editButton.title = "Edit"
        self.tableView.setEditing(false, animated: true)
        self.navigationItem.rightBarButtonItem?.enabled = true
    }
    
    @IBAction func addHome(sender: AnyObject) {
        UIAlertController.addAlert(self, title: "Nova Casa", message: "coloca uma casa") { (texto) -> Void in
            self.homeManager.addHomeWithName(texto, completionHandler: {[weak self] (home: HMHome!, error: NSError!) -> Void in
                
                if error != nil {
                    UIAlertController.showAlertControllOnHostController(self!, title: "ERRO", message: "\(error)")
                }
                self!.tableView.reloadData()


                })

        }
        
        
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if segue.identifier == "homeIdentifier"{
            
            let controller = segue.destinationViewController
                as! RoomViewController
            controller.homeManager = homeManager
            
            let home = homeManager.homes[tableView.indexPathForSelectedRow()!.row]
                as! HMHome
            
            controller.home = home
        }
        
        super.prepareForSegue(segue, sender: sender)

    }
    


}

