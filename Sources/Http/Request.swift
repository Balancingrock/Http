// =====================================================================================================================
//
//  File:       Request.swift
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
// 1.2.3 - Keys from getInfo and postInfo lowercased before adding to info.
// 1.2.2 - Bugfix, getInfo now appears correctly in info.
// 1.2.1 - Removed warning in Xcode 11
// 1.2.0 - Added postInfo and info
// 1.1.1 - Renamed urlNameValuePairs to getInfo
// 1.1.0 - Added resourcePath, resourcePathParts and urlNameValuePairs
// 1.0.1 - Documentation update
// 1.0.0 - Removed older history
//
// =====================================================================================================================

import Foundation
import Ascii


/// This class encodes/decodes an HTTP request.

public final class Request: CustomStringConvertible {
    
    
    /// The available methods.
    
    public enum Method: String {
        
        
        /// A GET request
        
        case get = "GET"
        
        
        /// A HEAD request
        
        case head = "HEAD"
        
        
        /// A POST request
        
        case post = "POST"
        
        
        /// A PUT request
        
        case put = "PUT"
        
        
        /// A DELETE request
        
        case delete = "DELETE"
        
        
        /// A TRACE request
        
        case trace = "TRACE"
        
        
        /// A CONNECT request
        
        case connect = "CONNECT"
        
        
        /// If operations are added, be sure to include them in "allValues".
        
        public static let all: Array<Method> = [.get, .head, .post, .put, .delete, .trace, .connect]
    }

    
    /// This enum encodes the different kinds of header fields
    
    public enum Field: String {
        
        
        /// The ACCEPT header field
        
        case accept                 = "Accept"
        
        
        /// The ACCEPT CHARACTERSET header field
        
        case acceptCharset          = "Accept-Charset"
        
        
        /// The ACCEPT ENCODING header field
        
        case acceptEncoding         = "Accept-Encoding"
        
        
        /// The ACCEPT LANGUAGE header field
        
        case acceptLanguage         = "Accept-Language"
        
        
        /// The ACCEPT DATETIME header field
        
        case acceptDatetime         = "Accept-Datetime"
        
        
        /// The CACHE CONTROL header field
        
        case cacheControl           = "Cache-Control"
        
        
        /// The CONNECTION header field
        
        case connection             = "Connection"
        
        
        /// The COOKIE header field
        
        case cookie                 = "Cookie"
        
        
        /// The CONTENT LENGTH header field
        
        case contentLength          = "Content-Length"
        
        
        /// The CONTENT MD5 header field
       
        case contentMd5             = "Content-MD5"
        
        
        /// The CONTENT TYPE header field
        
        case contentType            = "Content-Type"
        
        
        /// The DATE header field
        
        case date                   = "Date"
        
        
        /// The EXPECT header field
        
        case expect                 = "Expect"
        
        
        /// The FROM header field
        
        case from                   = "From"
        
        
        /// The HOST header field
        
        case host                   = "Host"
        
        
        /// The IF MATCH header field
        
        case ifMatch                = "If-Match"
        
        
        /// The IF MODIFIED SINCE header field
        
        case ifModifiedSince        = "If-Modified-Since"
        
        
        /// The IF NONE MATCH header field
        
        case ifNoneMatch            = "If-None-Match"
        
        
        /// The IF RANGE header field
        
        case ifRange                = "If-Range"
        
        
        /// The IF UNMODIFIED RANGE header field
        
        case ifUnmodifiedRange      = "If-Unmodified-Since"
        
        
        /// The MAX FORWARDS header field
        
        case maxForwards            = "Max-Forwards"
        
        
        /// The ORIGIN header field
        
        case origin                 = "Origin"
        
        
        /// The PRAGMA header field
        
        case pragma                 = "Pragma"
        
        
        /// The PROXY AUTHORIZATION header field
        
        case proxyAuthorization     = "Proxy-Authorization"
        
        
        /// The RANGE header field
        
        case range                  = "Range"
        
        
        /// The REFERER header field
        
        case referer                = "Referer"
        
        
        /// The TE header field
        
        case te                     = "TE"
        
        
        /// The USER AGENT header field
        
        case userAgent              = "User-Agent"
        
        
        /// The UPGRADE header field
        
        case upgrade                = "Upgrade"
        
        
        /// The WARNING header field
        
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
    
    
    /// Creates a new request object from the given data if the data contains a complete header. Otherwise returns nil. Removes any data that was used to create the request.
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
    
    
    /// Create and return a copy from self
    
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
        
        let nameValuePairs = str.components(separatedBy: "&")
        
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
    
    
    /// Returns the original URL in the request or nil if none present

    public lazy var url: String? = {
    
        
        // The first line should in 3 parts: Operation, url and version
        
        let parts = self.lines[0].components(separatedBy: " ")
        
        if parts.count == 3 { return parts[1] }
        
        return nil
    }()
    
    
    /// Returns the resource path of the URL
    
    public lazy var resourcePath: String? = {
        if _resourcePath == nil {
            processRawUrl(url)
        }
        return _resourcePath
    }()

    fileprivate var _resourcePath: String?
    
    
    /// Returns the path parts of the resource path part of the URL
    
    public lazy var resourcePathParts: Array<String> = {
        if _resourcePathParts == nil {
            processRawUrl(url)
        }
        return _resourcePathParts ?? []
    }()
    
    fileprivate var _resourcePathParts: Array<String>?
    
    
    /// Returns the name/value parts in the raw URL (if any). Also note that getInfo is present (and empty) even for requests that do not contain this type of data.
    ///
    /// Note: The method should be GET, but this is _not_ checked.
    
    public private(set) lazy var getInfo: Dictionary<String, String> = {
        if _urlNameValuePairs == nil {
            processRawUrl(url)
        }
        return _urlNameValuePairs ?? [:]
    }()
    
    fileprivate var _urlNameValuePairs: Dictionary<String, String>?
    
    
    /// Returns the path parts of the requested URL
    
    fileprivate func processRawUrl(_ rawurl: String?) {
        
        
        // If there is no url then return an empty array
        
        guard let rawurl = url else { return }
        
        
        // If there is no questionmark, it is a simple resource url
        
        if rawurl.contains("?") {
            
            
            // Split the path into two parts, before and after the questionmark
            
            var parts = rawurl.components(separatedBy: "?")
            
            
            // Set the path and its parts
            
            _resourcePath = String(parts[0])
            _resourcePathParts = parts[0].split(separator: "/").map({ String($0) })

            
            // Get the name/value pairs (if possible)
            
            if parts.count > 1 {
            
                
                // Reassemble the name/value pairs
                
                parts.removeFirst()
                var nameValuePairsStr = parts.removeFirst()
                parts.forEach( { nameValuePairsStr.append("?" + $0) } )

                
                // Extract the name/value pairs
            
                _urlNameValuePairs = [:]
            
                var nameValuePairs = nameValuePairsStr.components(separatedBy: "&")
            
                while nameValuePairs.count > 0 {
                    var nameValue = nameValuePairs.removeFirst().components(separatedBy: "=")
                    switch nameValue.count {
                    case 0: break // error, don't do anything
                    case 1: _urlNameValuePairs![nameValue[0]] = ""
                    case 2: _urlNameValuePairs![nameValue[0]] = nameValue[1]
                    default:
                        let name = nameValue.removeFirst()
                        _urlNameValuePairs![name] = nameValue.joined(separator: "=")
                    }
                }
                
            } else {

                // There are no name/value pairs
                
                _urlNameValuePairs = [:]
            }

        } else {
            
            _resourcePath = rawurl
            _resourcePathParts = rawurl.split(separator: "/").map({ String($0) })
            _urlNameValuePairs = [:]
        }
    }
    
    
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
    
    
    /// Returns the name/value pairs in the body for application/x-www-form-urlencoding encoded forms in a POST method. Note that postInfo is present (and empty) even for requests that do not contain this type of data.
    ///
    /// Note: There are no checks performed prior to the extraction attempt. If important, the user should perform these tests. Specifically it is assumed that:
    ///
    /// a) All body data has been received and is present in _body_
    ///
    /// b) The method is _POST_
    ///
    /// c) The encoding is _application/x-www-form-urlencoding_
    
    public private(set) lazy var postInfo: Dictionary<String, String> = {
        
        
        // Check for data
        
        guard let strData = body, !strData.isEmpty, let str = String.init(data: strData, encoding: String.Encoding.utf8) else {
            return [:]
        }
        
        
        // Split into multiple name/value pairs
        
        var postInfo: Dictionary<String, String> = [:]
        
        var nameValuePairs = str.components(separatedBy: "&")
        
        while nameValuePairs.count > 0 {
            let nvPair = nameValuePairs.removeFirst()
            var nameValue = nvPair.components(separatedBy: "=")
            switch nameValue.count {
            case 0: break // error, don't do anything
            case 1: postInfo[nameValue[0]] = ""
            case 2: postInfo[nameValue[0]] = nameValue[1].removingPercentEncoding?.replacingOccurrences(of: "+", with: " ")
            default:
                let name = nameValue.removeFirst()
                postInfo[name] = nameValue.joined(separator: "=")
            }
        }
        
        return postInfo
    }()
    
    
    /// A convenience dictionary that contains both getInfo and postInfo. If duplicate keys are present, the getInfo key's will take priority. Refer to getInfo and postInfo for the constraints on these dictionary (which also apply to this dictionary).
    ///
    /// It is possible to add data to this directory, but this data will not be copied to either getInfo nor postInfo nor any other original request field.
    
    public lazy var info: Dictionary<String, String> = {
        var dict: Dictionary<String, String> = [:]
        postInfo.forEach({ ( entry: (key: String, value: String)) in
            dict[entry.key.lowercased()] = entry.value
        })
        getInfo.forEach({ ( entry: (key: String, value: String)) in
            dict[entry.key.lowercased()] = entry.value
        })
        return dict
    }()
}
