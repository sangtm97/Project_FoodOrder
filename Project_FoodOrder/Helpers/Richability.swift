//
//  Richability.swift
//  Project_FoodOrder
//
//  Created by DeepTM on 21/05/2022.
//

import Foundation
import SystemConfiguration
 
public class Reachability {
 
class func HasConnection() -> Bool {
 
    var zeroAddress = sockaddr_in()
    zeroAddress.sin_len = UInt8(MemoryLayout.size(ofValue: zeroAddress))
    zeroAddress.sin_family = sa_family_t(AF_INET)
 
    let defaultRouteReachability = withUnsafePointer(to: &zeroAddress, {
        $0.withMemoryRebound(to: sockaddr.self, capacity: 1, {
            zeroAddress in
            SCNetworkReachabilityCreateWithAddress(nil, zeroAddress)
        })
    })
 
    var flags: SCNetworkReachabilityFlags = SCNetworkReachabilityFlags(rawValue: 0)
 
    if SCNetworkReachabilityGetFlags(defaultRouteReachability!, &flags) == false{
        return false
    }
 
    let isReachable = (flags.rawValue & UInt32(kSCNetworkFlagsReachable)) != 0
    let needsConnection = (flags.rawValue & UInt32(kSCNetworkFlagsConnectionRequired)) != 0
 
    return (isReachable && !needsConnection) ? true : false
}
 
}
