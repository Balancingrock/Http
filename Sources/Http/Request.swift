// =====================================================================================================================
//
//  File:       Request.swift
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
// 0.2.0 - Migrated to Swift 5
// 0.0.5 - Improved documentation
// 0.0.4 - Rewrote the initializer
//         Renamed payload to body
// 0.0.3 - Renamed 'Operation' to 'Method'
// 0.0.1 - Initial release, spun out from Swiftfire 0.10.8
// =====================================================================================================================

import Foundation
import Ascii


/// This class encodes/decodes an HTTP request.

public final class Request: CustomStringConvertible {
    
    
    /// The available methods.
    
    public enum Method: String {
        case get = "GET"
        case head = "HEAD"
        case post = "POST"
        case put = "PUT"
        case delete = "DELETE"
        case trace = "TRACE"
        case connect = "CONNECT"
        
        // If operations are added, be sure to include them in "allValues".
        
        public static let all: Array<Method> = [.get, .head, .post, .put, .delete, .trace, .connect]
    }

    
    /// This enum encodes the different kinds of header fields
    
    public enum Field: String {
        
        case accept                 = "Accept"
        case acceptCharset          = "Accept-Charset"
        case acceptEncoding         = "Accept-Encoding"
        case acceptLanguage         = "Accept-Language"
        case acceptDatetime         = "Accept-Datetime"
        case cacheControl           = "Cache-Control"
        case connection             = "Connection"
        case cookie                 = "Cookie"
        case contentLength          = "Content-Length"
        case contentMd5             = "Content-MD5"
        case contentType            = "Content-Type"
        case date                   = "Date"
        case expect                 = "Expect"
        case from                   = "From"
        case host                   = "Host"
        case ifMatch                = "If-Match"
        case ifModifiedSince        = "If-Modified-Since"
        case ifNoneMatch            = "If-None-Match"
        case ifRange                = "If-Range"
        case ifUnmodifiedRange      = "If-Unmodified-Since"
        case maxForwards            = "Max-Forwards"
        case origin                 = "Origin"
        case pragma                 = "Pragma"
        case proxyAuthorization     = "Proxy-Authorization"
        case range                  = "Range"
        case referer                = "Referer"
        case te                     = "TE"
        case userAgent              = "User-Agent"
        case upgrade                = "Upgrade"
        case warning                = "Warning"
        
        
        /// Checks if the line starts with this field and returns the value part if it does.
        ///
        /// - Parameter line: The string to be examined.
        ///
        /// - Returns: nil if the requested field is not present, otherwise the string after the ':' sign of the request field, without leading or trailing blanks
        
        public func value(from line: String) -> String? {
            
            
            // Split the string in request and value
            
            var subStrings = line.components(separatedBy: ":")
            
            
            // The count of the array must be 2 or more, otherwise there is something wrong
            
            if subStrings.count < 2 { return nil }
            
            
            // The first string should be equal to the request field raw value
            
            if subStrings[0].caseInsensitiveCompare(self.rawValue) != ComparisonResult.orderedSame { return nil }
            
            
            // Remove the raw field value
            
            subStrings.removeFirst()
            
            
            // Assemble the rest of the string value again
            
            var strValue = ""
            
            for (i, str) in subStrings.enumerated() {
                strValue += str
                if i < (subStrings.count - 1) { strValue += ":" }
            }
            
            
            // Strip leading and trailing blanks
            
            return strValue.trimmingCharacters(in: NSCharacterSet.whitespaces)
        }
    }

    
    /// The end-of-line sequence
    
    public static let endOfLineSequence = Data([Ascii._CR, Ascii._LF])
    
    
    /// The end-of-header sequence
    
    public static let endOfHeaderSequence = Data([Ascii._CR, Ascii._LF, Ascii._CR, Ascii._LF])
    
    
    /// The lines in the header
    
    public let lines: [String]
    
    
    /// The unprocessed lines, initially this is the same as 'lines' but as the header is decoded the processed lines are removed from this array.
    
    public private(set) var unprocessedLines: [String]
    
    
    /// The number of bytes in the header (including the CRLFCRLF)
    
    public let headerLength: Int
    
    
    /// The body (if there is any)
    
    public var body: Data!
    
    
    // - Note: The headerLength is not used internally, its just a place to keep this information handy - if necessary.
    
    private init(lines: [String], headerLength: Int) {
        self.lines = lines
        self.unprocessedLines = lines
        if lines.count > 1 {
            self.unprocessedLines.removeFirst()
        }
        self.headerLength = headerLength
    }
    
    
    /// Deserialises a new Request from the given data if the data contains a complete header. Otherwise returns nil. Removes any data that was used to create the request.
    ///
    /// The body will contain the available data, but may be incomplete if the data is insufficient. Compare the contentLength with the body.count to verify if the body is complete or not.
    ///
    /// - Parameter data: The HTTP request encoded as an UTF8 string.
    ///
    /// - Returns: If an HTTP Request header was found it will be stripped from the input data including any body data that may be present. If no HTTP request header was found it will be returned unaltered.
    
    public convenience init?(_ data: inout Data) {
        
        
        // Check if the header is complete by searching for the end of the CRLFCRLF sequence
        
        guard let endOfHeaderRange = data.range(of: Request.endOfHeaderSequence) else { return nil }
        
        
        // Convert the header to lines
        
        let headerRange = Range(uncheckedBounds: (lower: 0, upper: endOfHeaderRange.lowerBound))
        guard let headerString = String(data: data.subdata(in: headerRange), encoding: String.Encoding.utf8) else {
            return nil
        }
        let headerLines = headerString.components(separatedBy: CRLF)
        
        
        // Set the headerlength
        
        let length = endOfHeaderRange.upperBound
        
        
        // Create header
        
        self.init(lines: headerLines, headerLength: length)
        
        
        // Create body
        
        let bodyLength = self.contentLength
        let requestLength = headerLength + bodyLength
        if requestLength > data.count {
            let bodyRange = Range(uncheckedBounds: (lower: headerLength, upper: data.count))
            body = data.subdata(in: bodyRange)
            data.removeAll(keepingCapacity: true)
        } else {
            let bodyRange = Range(uncheckedBounds: (lower: headerLength, upper: headerLength + contentLength))
            body = data.subdata(in: bodyRange)
            data.removeSubrange(Range(uncheckedBounds: (lower: 0, upper: headerLength + contentLength)))
        }
    }
    
    
    // Create and return a copy from self
    
    public var copy: Request {
        let cp = Request(lines: self.lines, headerLength: self.headerLength)
        cp.body = self.body
        // Don't copy the lazy variables, they will be recreated when necessary.
        return cp
    }
    
    
    /// - Returns: The header as a Data object containing the lines as an UTF8 encoded string separated by CRLF en closed by a CRLFCRLF sequence. Nil if the lines could not be encoded as an UTF8 coding.
    
    public func asData() -> Data? {
        var str = ""
        for line in lines {
            str += line + CRLF
        }
        str += CRLF
        return str.data(using: String.Encoding.utf8)
    }
    
    
    /// Returns all the lines in the header.
    
    public var description: String {
        return lines.reduce("") { $0 + "\($1)\n" }
    }
        
    
    /// Decodes form data from the given string
    
    public static func decodeUrlEncodedFormData(_ str: String) -> Dictionary<String, String>? {
        
        var dict: Dictionary<String, String> = [:]
        
        var nameValuePairs = str.components(separatedBy: "&")
        
        while nameValuePairs.count > 0 {
            var nameValue = nameValuePairs[0].components(separatedBy: "=")
            switch nameValue.count {
            case 0: break // error, don't do anything
            case 1: dict[nameValue[0]] = ""
            case 2: dict[nameValue[0]] = nameValue[1]
            default:
                let name = nameValue.removeFirst()
                dict[name] = nameValue.joined(separator: "=")
            }
        }
        
        
        // Add the get dictionary to the service info
        
        if dict.count > 0 { return dict } else { return nil }
    }
    
    
    /// Returns the method or nil if none present
    
    public lazy var method: Method? = {
        for t in Method.all {
            let methodRange = self.lines[0].range(of: t.rawValue, options: NSString.CompareOptions(), range: nil, locale: nil)
            if let range = methodRange {
                if range.lowerBound == self.lines[0].startIndex { return t }
            }
        }
        return nil
    }()
    
    
    /// Returns the URL or nil if none present

    public lazy var url: String? = {
    
        
        // The first line should in 3 parts: Operation, url and version
        
        let parts = self.lines[0].components(separatedBy: " ")
        
        if parts.count == 3 { return parts[1] }
        
        return nil
    }()
    
    
    /// Returns the version of the http header or nil if it cannot be found
    
    public lazy var version: Version? = {
        
        
        // The first line should in 3 parts: Operation, url and version

        let parts = self.lines[0].components(separatedBy: " ")
        
        if parts.count == 3 {
            
            
            // The last part should be equal to the raw value of a HttpVersion enum
            
            for version in Version.all {
                
                if let range = parts[2].range(
                    of: version.rawValue,
                    options: NSString.CompareOptions.caseInsensitive,
                    range: nil,
                    locale: nil) {
                    
                    if range.lowerBound == self.lines[0].startIndex { return version }
                }
            }
        }

        return nil
    }()
    
    
    /// Returns the content type (mime type) of the request
    
    public lazy var contentType: String? = {
        
        for (index, line) in self.unprocessedLines.enumerated() {
            
            if let str = Request.Field.contentType.value(from: line) {
                
                self.unprocessedLines.remove(at: index)
                
                return str
            }
        }
        
        return nil
    }()
    
    
    /// Return the length of the body content or 0 if no length field is found
    
    public lazy var contentLength: Int = {
        
        for (index, line) in self.unprocessedLines.enumerated() {
            
            if let str = Request.Field.contentLength.value(from: line) {

                self.unprocessedLines.remove(at: index)
                
                if let val = Int(str) { return val }
            }
        }
        
        return 0
    }()
    
    
    /// Returns true if the connection must be kept alive, false otherwise.
    /// - Note: Defaults to 'false' if the Connection field is not present.
    
    public lazy var connectionKeepAlive: Bool = {
        
        for (index, line) in self.unprocessedLines.enumerated() {
            
            if let str = Request.Field.connection.value(from: line) {
                
                self.unprocessedLines.remove(at: index)
                
                if str.caseInsensitiveCompare("keep-alive") == ComparisonResult.orderedSame {
                    return true;
                } else {
                    return false;
                }
            }
        }
        
        return false
    }()
    
    
    /// Returns the host in the header, note that HTTP 1.0 requests do not have a host field.
    
    public lazy var host: Host? = {
       
        for (index, line) in self.unprocessedLines.enumerated() {
            
            if let val = Request.Field.host.value(from: line) {
                                
                let values = val.components(separatedBy: ":")
                
                if values.count == 0 { return nil }
                
                if values.count == 1 {
                    self.unprocessedLines.remove(at: index)
                    return Host(address: values[0], port: nil)
                }
                
                if values.count == 2 {
                    self.unprocessedLines.remove(at: index)
                    return Host(address: values[0], port: values[1])
                }
                
                return nil
            }
        }

        return nil
    }()
    
    
    /// Returns all cookies present in the header.
    
    public lazy var cookies: Array<Cookie> = {
        
        var arr: Array<Cookie> = []
        
        for (index, line) in self.unprocessedLines.enumerated() {
            
            let cookies = Cookie.factory(string: line)
            
            if cookies.count > 0 {
                self.unprocessedLines.remove(at: index)
                arr.append(contentsOf: cookies)
            }
        }
        
        return arr
    }()
}
