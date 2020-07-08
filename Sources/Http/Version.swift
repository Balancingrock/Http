// =====================================================================================================================
//
//  File:       HttpVersion.swift
//  Project:    Http
//
//  Version:    1.2.4
//
//  Author:     Marinus van der Lugt
//  Company:    http://balancingrock.nl
//  Website:    http://swiftfire.nl/projects/http/http.html
//  Git:        https://github.com/Balancingrock/Http
//
//  Copyright:  (c) 2017-2020 Marinus van der Lugt, All rights reserved.
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


/// This enum encodes the different versions of the HTTP protocol

public enum Version: String {

    
    /// HTTP protocol version 1.0
    
    case http1_0 = "HTTP/1.0"
    
    
    /// HTTP protocol version 1.1
    
    case http1_1 = "HTTP/1.1"
    
    
    /// HTTP protocol version 1.x
    
    case http1_x = "HTTP/1.x"
    
    
    /// If operations are added, be sure to include them in "all".
    
    public static let all: Array<Version> = [.http1_0, .http1_1, .http1_x]
}
