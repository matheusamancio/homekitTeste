//
//  CharactesristicExtension.swift
//  HomeKitTest1.1
//
//  Created by Matheus Amancio Seixeiro on 9/9/15.
//  Copyright (c) 2015 Matheus Amancio Seixeiro. All rights reserved.
//

import Foundation
import UIKit
import HomeKit

extension HMCharacteristic{
    
    func containsProperty(paramProperty: String) -> Bool{
        if let propeties = self.properties{
            for property in properties {
                if property == paramProperty{
                    return true
                }
            }
        }
        return false
    }
    
    func isReadable() -> Bool{
        return containsProperty(HMCharacteristicPropertyReadable)
    }
    
    func isWritable() -> Bool{
        return containsProperty(HMCharacteristicPropertyWritable)
    }
    
}
