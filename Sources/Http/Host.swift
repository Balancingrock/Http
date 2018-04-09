// =====================================================================================================================
//
//  File:       Host.swift
//  Project:    Http
//
//  Version:    0.0.5
//
//  Author:     Marinus van der Lugt
//  Company:    http://balancingrock.nl
//  Website:    http://swiftfire.nl/
//  Blog:       http://swiftrien.blogspot.com
//  Git:        https://github.com/Balancingrock/Swiftfire
//
//  Copyright:  (c) 2017 Marinus van der Lugt, All rights reserved.
//
//  License:    Use or redistribute this code any way you like with the following two provision:
//
//  1) You ACCEPT this source code AS IS without any guarantees that it will work as intended. Any liability from its
//  use is YOURS.
//
//  2) You WILL NOT seek damages from the author or balancingrock.nl.
//
//  I also ask you to please leave this header with the source code.
//
//  I strongly believe that voluntarism is the way for societies to function optimally. Thus I have choosen to leave it
//  up to you to determine the price for this code. You pay me whatever you think this code is worth to you.
//
//   - You can send payment via paypal to: sales@balancingrock.nl
//   - Or wire bitcoins to: 1GacSREBxPy1yskLMc9de2nofNv2SNdwqH
//
//  I prefer the above two, but if these options don't suit you, you might also send me a gift from my amazon.co.uk
//  wishlist: http://www.amazon.co.uk/gp/registry/wishlist/34GNMPZKAQ0OO/ref=cm_sw_em_r_wsl_cE3Tub013CKN6_wb
//
//  If you like to pay in another way, please contact me at rien@balancingrock.nl
//
//  (It is always a good idea to visit the website/blog/google to ensure that you actually pay me and not some imposter)
//
//  For private and non-profit use the suggested price is the price of 1 good cup of coffee, say $4.
//  For commercial use the suggested price is the price of 1 good meal, say $20.
//
//  You are however encouraged to pay more ;-)
//
//  Prices/Quotes for support, modifications or enhancements can be obtained from: rien@balancingrock.nl
//
// =====================================================================================================================
// PLEASE let me know about bugs, improvements and feature requests. (rien@balancingrock.nl)
// =====================================================================================================================
//
// History
//
// 0.0.5 - Added comments and code streamlining.
// 0.0.1 - Initial release, spun out from Swiftfire 0.10.8
// =====================================================================================================================

import Foundation


/// A host is a combination of address and port.

public struct Host: Equatable, CustomStringConvertible {
    
    
    /// Implements the equatable protocol.
    
    public static func == (lhs: Host, rhs: Host) -> Bool {
        if lhs.address != rhs.address { return false }
        if lhs.port == nil {
            if rhs.port != nil { return false }
            return true
        } else {
            if rhs.port == nil { return false }
            return lhs.port! == rhs.port!
        }
    }

    
    /// The address of this host.
    
    public let address: String
    
    
    /// The port number of this host.
    
    public let port: String?
    
    
    /// Implements the CustomStringConvertible
    
    public var description: String { return address + (port == nil ? "" : ":\(port!)") }
    
    
    /// Creates a new host.
    ///
    /// - Parameters:
    ///   - address: A string with the address of the host.
    ///   - port: A string with the port number on which the host must be contacted.
    
    public init(address: String, port: String?) {
        self.address = address
        self.port = port
    }
}
