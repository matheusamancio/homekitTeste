//
//  AlertExtension.swift
//  HomeKitTest1.1
//
//  Created by Matheus Amancio Seixeiro on 9/3/15.
//  Copyright (c) 2015 Matheus Amancio Seixeiro. All rights reserved.
//

import Foundation
import UIKit
extension UIAlertController{
    

    

    
    class func showAlertControllOnHostController(hostViewController: UIViewController, title: String, message: String){
        
        let controller = UIAlertController(title: title, message: message, preferredStyle: .Alert)
        
        controller.addAction(UIAlertAction(title: "OK", style: .Default, handler: nil))
        
        hostViewController.presentViewController(controller, animated: true, completion: nil)
        
        
        
    }
    
    
    class func addAlert(hostViewController: UIViewController, title: String, message: String, bloco: (texto: String) -> Void){
        var SomeTextField: UITextField?
        
        let controller = UIAlertController(title: title, message: message, preferredStyle: .Alert)
        
        controller.addAction(UIAlertAction(title:"OK", style: .Default){ (alert) -> Void in
            if count(SomeTextField!.text) == 0{
              self.showAlertControllOnHostController(hostViewController, title: "home name", message: "coloca o nome ai mano")
                return
            }
            bloco(texto: SomeTextField!.text)
            })
        
        controller.addAction(UIAlertAction(title: "Cancel", style: .Cancel, handler: nil))
        controller.addTextFieldWithConfigurationHandler { (textField) -> Void in
            SomeTextField = textField
            SomeTextField!.placeholder = "põe o nome ae"
        }
        hostViewController.presentViewController(controller, animated: true, completion: nil)
    }
    
    
    
    
}
