// =====================================================================================================================
//
//  File:       Host.swift
//  Project:    Http
//
//  Version:    1.2.4
//
//  Author:     Marinus van der Lugt
//  Company:    http://balancingrock.nl
//  Website:    http://swiftfire.nl/projects/http/http.html
//  Git:        https://github.com/Balancingrock/Http
//
//  Copyright:  (c) 2017..2019 Marinus van der Lugt, All rights reserved.
//
//  License:    MIT, see LICENSE file
//
//  And because I need to make a living:
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
// 1.2.4 - Updated LICENSE
// 1.0.1 - Documentation update
// 1.0.0 - Removed older history
//
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
    
    
    /// Creates a new host structure.
    ///
    /// - Parameters:
    ///   - address: A string with the address of the host.
    ///   - port: A string with the port number on which the host must be contacted.
    
    public init(address: String, port: String?) {
        self.address = address
        self.port = port
    }
}

