// =====================================================================================================================
//
//  File:       Cookie.swift
//  Project:    Http
//
//  Version:    1.0.1
//
//  Author:     Marinus van der Lugt
//  Company:    http://balancingrock.nl
//  Website:    http://swiftfire.nl/projects/http/http.html
//  Git:        https://github.com/Balancingrock/Http
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
// 1.0.1 - Documentation update
// 1.0.0 - Removed older history
//
// =====================================================================================================================

import Foundation


/// An HTTP Cookie.
///
/// There are two types of cookies: Those in HTTP requests and those in HTTP Responses.
/// The request cookies consist of a name and value only. The response cookies can have attributes.

public final class Cookie: CustomStringConvertible {
    
    
    /// An array of cookies
    
    public typealias Cookies = Array<Cookie>

    
    // Used when no cookies are present
    
    private static let noCookies = Cookies()

    
    /// The kind of timout for cookies.
    
    public enum Timeout {
        
        
        /// The cookie expires after this date.
        
        case expiry(Date)
        
        
        /// The cookie expires after this many seconds.
        
        case maxAge(Int)
    }
    
    
    /// The name of the cookie
    
    public let name: String
    
    
    /// The value of the cookie
    
    public let value: String
    
    
    /// Expiration date of the cookie
    
    public let timeout: Timeout?
    
    
    /// The path for which the cookie is valid
    
    public let path: String?
    
    
    /// The domain for which the cookie is valid
    
    public let domain: String?
    
    
    /// If true, then the cookie may only be transferred securely
    
    public let secure: Bool?
    
    
    /// If true, then the cookie may only be used by the HTTP protocol
    
    public let httpOnly: Bool?
    
    
    /// Creates a new cookie object.
    ///
    /// - Note: The name and value parameters are not checked on validity. Be sure to use only valid characters in the strings.
    ///
    /// - Parameters:
    ///   - name: The name of the cookie.
    ///   - value: The value of the cookie.
    ///   - expiration: (Optional) An expiration date.
    ///   - path: (Optional) A path that specifies where the cookie must be used.
    ///   - domain: (Optional) A domain for which the cookie may be used.
    ///   - secure: (Optional) A flag that will limit the cookie to secure connections.
    ///   - httpOnly: (Optional) A flag that limits the cookie to HTTP only.
    
    public init(name: String, value: String, timeout: Timeout? = nil, path: String? = nil, domain: String? = nil, secure: Bool? = nil, httpOnly: Bool? = nil) {

        self.name = name
        self.value = value
        
        self.timeout = timeout
        self.path = path
        self.domain = domain
        
        self.secure = secure
        self.httpOnly = httpOnly
    }
        
    
    /// Returns the cookies in the given line, if any. Used to deserialize the cookies from an HTTP request.
    ///
    /// - Parameter string: The line that may contain cookies. Should be formed as per [RFC6265](https://tools.ietf.org/html/rfc6265)

    public static func factory(string: String?) -> Cookies {
        
        
        // Ensure the string is present
        
        guard let string = string else { return noCookies }
        
        
        // Create the character set of characters that split the string into substrings
        
        let separatorSet: CharacterSet = CharacterSet(charactersIn: ":;=")
        
        
        // Create the substrings
        
        var subs: [String] = string.replacingOccurrences(of: " ", with: "").components(separatedBy: separatorSet)
        
        
        // There must be at least 3 substrings
        
        if subs.count < 3 { return noCookies }
        
        
        // The first substring must be "Cookie"
        
        if subs[0].caseInsensitiveCompare("Cookie") == ComparisonResult.orderedSame {
            
            
            // Remove the cookie text
            
            subs.removeFirst()
        
        
            // Now a sequence of key/value pairs should follow
        
            var arr: [Cookie] = []
        
            while subs.count >= 2 {
            
            
                // The next substring is the name of the cookie
            
                let name = subs.removeFirst()
            
            
                // Next is the value
                
                let value = subs.removeFirst()

                
                // Add a new cookie to the result
                
                arr.append(Cookie(name: name, value: value))
            }
        
            return arr
            
        } else {
            
            return noCookies
        }
    }
    

    /// The CustomStringConvertible protocol
    
    public var description: String { return cookieCreationCode }
    
    
    /// Returns the string used to create the cookie on a client.
    
    public var cookieCreationCode: String {
        var str = "Set-Cookie: \(name)=\(value)"
        switch timeout {
        case nil: break
        case .expiry(let date)?: str += "; Expires=\(date)"
        case .maxAge(let age)?:  str += "; Max-Age=\(age)"
        }
        if let path = path { str += "; Path=\(path)" }
        if let domain = domain { str += "; Domain=\(domain)" }
        if let secure = secure, secure == true { str += "; Secure" }
        if let httpOnly = httpOnly, httpOnly == true { str += "; HttpOnly" }
        return str
    }
    
    
    /// - Returns: An expired "copy" of self.
    
    public func expired() -> Cookie {
        let invalidDate = Date().addingTimeInterval(TimeInterval(-24*60*60))
        return Cookie(name: name, value: "", timeout: .expiry(invalidDate))
    }
}
