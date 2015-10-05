//
//  CharacteristicViewController.swift
//  
//
//  Created by Matheus Amancio Seixeiro on 9/9/15.
//
//


import UIKit
import HomeKit

class CharacteristicViewController: UIViewController, HMHomeManagerDelegate, HMAccessoryBrowserDelegate, HMAccessoryDelegate {
    
    var homeManager: HMHomeManager!
    var acessory : HMAccessory!
    var home: HMHome!
    var room: HMRoom!
    var characteristcs : [HMCharacteristic] = []
    var services : [HMService] = []


    @IBOutlet weak var nameBar: UINavigationItem!
    @IBOutlet weak var mySwitch: UISwitch!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        nameBar.title = acessory.name
        acessory.delegate = self

        findServicesForAccessory(acessory)
    }

    func findServicesForAccessory(acessorio: HMAccessory){
        print("procurando servicos desse acessorio")
        for service in acessorio.services {
            print(" Service name = \(service.name)")
            print(" Service type = \(service.serviceType)")
            print("procurando caracteristicas do serviço")
            if service.serviceType == HMServiceTypeSwitch{
                print("acheiii aquiii mano")

                self.findCharacteristicsOfService(service)
                break
            }
        }
        print("oooooo")
        print(services.count)

    }
    
    func findCharacteristicsOfService(service: HMService){
        for characteristic in service.characteristics {
            print("tipo de caracteristica = "+" \(characteristic.characteristicType)")
            print("value \(characteristic.value) : \(characteristic.metadata)")
            if characteristic.isReadable() == false {
                print("deu ruim Manooo")
            }
            characteristic.readValueWithCompletionHandler({ (error: NSError?) -> Void in
                
                if characteristic.metadata.format == HMCharacteristicMetadataFormatBool{
                    self.characteristcs.append(characteristic)
                    if characteristic.value as! Bool == true {
                        self.mySwitch.on = true
                    } else {
                        self.mySwitch.on = false
                    }
                }
                if characteristic.characteristicType == HMCharacteristicTypeBrightness{
                    var slider = UISlider(frame: CGRectMake(20, 260, 280, 20))
//                    slider.minimumValue = characteristic.value
                }
                
            })
            characteristic.enableNotification(true, completionHandler: { (error) -> Void in
                if error != nil {
                    print("Something went wrong when enabling notification for a chracteristic. \(error.localizedDescription)")
                }
            })


        }
        print(characteristcs.count)
    }

    func accessory(accessory: HMAccessory, service: HMService, didUpdateValueForCharacteristic characteristic: HMCharacteristic) {
        if characteristic.value as! Bool == true {
            self.mySwitch.on = true
        } else {
            self.mySwitch.on = false
        }

    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func changeSwitches(sender: AnyObject) {

        
        if mySwitch.on{
            print("on")
            characteristcs[0].writeValue(true, completionHandler: { (error: NSError?) -> Void in
                
            })
        } else{
            print("off")
            characteristcs[0].writeValue(false, completionHandler: { (error: NSError?) -> Void in
            })
        }
        
    }
    func accessoryBrowser(browser: HMAccessoryBrowser, didRemoveNewAccessory accessory: HMAccessory) {
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
