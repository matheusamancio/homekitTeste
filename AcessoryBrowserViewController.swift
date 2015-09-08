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
    
    @IBOutlet weak var nameNav: UINavigationItem!
    
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
    
    func accessoryBrowser(browser: HMAccessoryBrowser, didFindNewAccessory accessory: HMAccessory!){
        print("encontrou accessorio")
        println("adicionando ele na casa")
        home.addAccessory(accessory, completionHandler: { (error: NSError!) -> Void in
            if error != nil{
                println(" falhou ")
                println("error = \(error)")
            } else{
                println("adicionou o acessorio a casa")
                self.home.assignAccessory(accessory, toRoom: self.room, completionHandler: { (error:NSError!) -> Void in
                    if error != nil {
                        println("nao adiocionou acessorio no quarto")
                        println("erro = \(error)")
                    } else {
                        println(" uuuuha ")
                        self.findServicesForAccessory(accessory)
                    }
                })
            }
        })
    }
    
    func findServicesForAccessory(acessorio: HMAccessory){
        println("procurando servicos desse acessorio")
        for service in acessorio.services as! [HMService]{
            println(" Service name = \(service.name)")
            println(" Service type = \(service.serviceType)")
            
            println("procurando caracteristicas do serviço")
            self.findCharacteristicsOfService(service)
        }
    }
    
    func findCharacteristicsOfService(servico: HMService){
        for characteristic in servico.characteristics as! [HMCharacteristic]{
            println("tipo de caracteristica = "+" \(characteristic.characteristicType)")
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func accessoryBrowser(browser: HMAccessoryBrowser, didRemoveNewAccessory accessory: HMAccessory!) {
        println("accessorio removido")
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
