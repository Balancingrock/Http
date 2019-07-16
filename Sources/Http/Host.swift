// =====================================================================================================================
//
//  File:       Host.swift
//  Project:    Http
//
//  Version:    0.2.1
//
//  Author:     Marinus van der Lugt
//  Company:    http://balancingrock.nl
//  Website:    http://swiftfire.nl/
//  Git:        https://github.com/Balancingrock/Swiftfire
//
//  Copyright:  (c) 2017..2019 Marinus van der Lugt, All rights reserved.
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
//  Like you, I need to make a living:
//
//   - You can send payment (you choose the amount) via paypal to: sales@balancingrock.nl
//   - Or wire bitcoins to: 1GacSREBxPy1yskLMc9de2nofNv2SNdwqH
//
//  If you like to pay in another way, please contact me at rien@balancingrock.nl
//
//  Prices/Quotes for support, modifications or enhancements can be obtained from: rien@balancingrock.nl
//
// =====================================================================================================================
// PLEASE let me know about bugs, improvements and feature requests. (rien@balancingrock.nl)
// =====================================================================================================================
//
// History
//
// 0.2.1 - Updated header
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

