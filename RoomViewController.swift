//
//  AddViewController.swift
//  
//
//  Created by Matheus Amancio Seixeiro on 8/31/15.
//
//

import UIKit
import HomeKit



class RoomViewController: UIViewController, HMHomeDelegate, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var nameBar: UINavigationItem!
    @IBOutlet weak var tableView: UITableView!
    
    var homeManager: HMHomeManager!
    var home: HMHome!{
        didSet{
            home.delegate = self
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        nameBar.title = home.name
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        return home.rooms.count
    }
 
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell{
        
        var cell = self.tableView.dequeueReusableCellWithIdentifier("CellRoom", forIndexPath: indexPath) as! UITableViewCell
        
        let room = home.rooms[indexPath.row] as! HMRoom
        cell.textLabel!.text = room.name
        
        return cell
    }

    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        switch editingStyle{
        case .Delete:
            let room = home.rooms[indexPath.row] as! HMRoom
            home.removeRoom(room, completionHandler: { (error: NSError!) -> Void in
                if error != nil{
                    UIAlertController.showAlertControllOnHostController(self, title: "error", message: "deu ruim mano= \(error)")
                } else {
                    tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Automatic)
                }
            })
        default:
            return
        }
    }
    
    func home(home: HMHome, didAddRoom room: HMRoom!) {
        
    }
    
    func home(home: HMHome, didRemoveRoom room: HMRoom!) {
        
    }

    @IBAction func addRoomToHome(sender: AnyObject) {
        UIAlertController.addAlert(self, title: "Room Name", message: "Coloca o quarto ai mano") { (texto) -> Void in
            self.home.addRoomWithName(texto, completionHandler: { (room: HMRoom!, error: NSError!) -> Void in
                if error != nil{
                    UIAlertController.showAlertControllOnHostController(self, title: "Error", message: "\(error)")
                }
                self.tableView.reloadData()

            })
        }
    }

    
}
