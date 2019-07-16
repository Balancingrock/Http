// =====================================================================================================================
//
//  File:       Http.swift
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
// 0.0.5 - Added comments
// 0.0.2 - Added mime types
// 0.0.1 - Initial release, spun out from Swiftfire 0.10.8
// =====================================================================================================================

import Foundation


/// The normal line endings

public let CRLF = "\r\n"


/// The ending of the header

public let CRLFCRLF = "\r\n\r\n"


/// Often used mime type

public let mimeTypeHtml = "text/html"


/// If no mime type can be determined, the default mime type can be used.
///
/// - Note: intendend usage: let mime = mimeTypeForExtension("bla") ?? mimeTypeDefault

public let mimeTypeDefault = "application/octet-stream"


/// Returns the MIME type for the extension of the given URL.
///
/// - Parameter forUrl: The url for which to determine the mime type.
///
/// - Returns: The string representing the mime type, or nil if no match could be made.

public func mimeType(forUrl url: URL) -> String? {
    return mimeType(forExtension: url.pathExtension)
}


/// Returns the MIME type for the extension of the given file path.
///
/// - Parameter forPath: The file path for which to determine the mime type.
///
/// - Returns: The string representing the mime type, or nil if no match could be made.

public func mimeType(forPath: String) -> String? {
    return mimeType(forExtension: (forPath as NSString).pathExtension)
}


/// Returns the MIME type for the given file extension.
///
/// - Parameter forExtension: The file extension for which to determine the mime type.
///
/// - Returns: The string representing the mime type, or nil if no match could be made.

public func mimeType(forExtension: String) -> String? {
    return mimeMap[forExtension]
}


// Maps extensions to mime strings

fileprivate let mimeMap: Dictionary<String, String> = [
    "323" : "text/h323",
    "acx" : "application/internet-property-stream",
    "ai" : "application/postscript",
    "aif" : "audio/x-aiff",
    "aifc" : "audio/x-aiff",
    "aiff" : "audio/x-aiff",
    "asf" : "video/x-ms-asf",
    "asr" : "video/x-ms-asf",
    "asx" : "video/x-ms-asf",
    "au" : "audio/basic",
    "avi" : "video/x-msvideo",
    "axs" : "application/olescript",
    "bas" : "text/plain",
    "bcpio" : "application/x-bcpio",
    "bin" : "application/octet-stream",
    "bmp" : "image/bmp",
    "c" : "text/plain",
    "cat" : "application/vnd.ms-pkiseccat",
    "cdf" : "application/x-cdf",
    "cer" : "application/x-x509-ca-cert",
    "class" : "application/octet-stream",
    "clp" : "application/x-msclip",
    "cmx" : "image/x-cmx",
    "cod" : "image/cis-cod",
    "cpio" : "application/x-cpio",
    "crd" : "application/x-mscardfile",
    "crl" : "application/pkix-crl",
    "crt" : "application/x-x509-ca-cert",
    "csh" : "application/x-csh",
    "css" : "text/css",
    "dcr" : "application/x-director",
    "der" : "application/x-x509-ca-cert",
    "dir" : "application/x-director",
    "dll" : "application/x-msdownload",
    "dms" : "application/octet-stream",
    "doc" : "application/msword",
    "dot" : "application/msword",
    "dvi" : "application/x-dvi",
    "dxr" : "application/x-director",
    "eps" : "application/postscript",
    "etx" : "text/x-setext",
    "evy" : "application/envoy",
    "exe" : "application/octet-stream",
    "fif" : "application/fractals",
    "flr" : "x-world/x-vrml",
    "gif" : "image/gif",
    "gtar" : "application/x-gtar",
    "gz" : "application/x-gzip",
    "h" : "text/plain",
    "hdf" : "application/x-hdf",
    "hlp" : "application/winhlp",
    "hqx" : "application/mac-binhex40",
    "hta" : "application/hta",
    "htc" : "text/x-component",
    "htm" : "text/html",
    "html" : "text/html",
    "htt" : "text/webviewhtml",
    "ico" : "image/x-icon",
    "ief" : "image/ief",
    "iii" : "application/x-iphone",
    "ins" : "application/x-internet-signup",
    "isp" : "application/x-internet-signup",
    "jfif" : "image/pipeg",
    "jpe" : "image/jpeg",
    "jpeg" : "image/jpeg",
    "jpg" : "image/jpeg",
    "js" : "application/x-javascript",
    "latex" : "application/x-latex",
    "lha" : "application/octet-stream",
    "lsf" : "video/x-la-asf",
    "lsx" : "video/x-la-asf",
    "lzh" : "application/octet-stream",
    "m13" : "application/x-msmediaview",
    "m14" : "application/x-msmediaview",
    "m3u" : "audio/x-mpegurl",
    "man" : "application/x-troff-man",
    "mdb" : "application/x-msaccess",
    "me" : "application/x-troff-me",
    "mht" : "message/rfc822",
    "mhtml" : "message/rfc822",
    "mid" : "audio/mid",
    "mny" : "application/x-msmoney",
    "mov" : "video/quicktime",
    "movie" : "video/x-sgi-movie",
    "mp2" : "video/mpeg",
    "mp3" : "audio/mpeg",
    "mpa" : "video/mpeg",
    "mpe" : "video/mpeg",
    "mpeg" : "video/mpeg",
    "mpg" : "video/mpeg",
    "mpp" : "application/vnd.ms-project",
    "mpv2" : "video/mpeg",
    "ms" : "application/x-troff-ms",
    "msg" : "application/vnd.ms-outlook",
    "mvb" : "application/x-msmediaview",
    "nc" : "application/x-netcdf",
    "nws" : "message/rfc822",
    "oda" : "application/oda",
    "p10" : "application/pkcs10",
    "p12" : "application/x-pkcs12",
    "p7b" : "application/x-pkcs7-certificates",
    "p7c" : "application/x-pkcs7-mime",
    "p7m" : "application/x-pkcs7-mime",
    "p7r" : "application/x-pkcs7-certreqresp",
    "p7s" : "application/x-pkcs7-signature",
    "pbm" : "image/x-portable-bitmap",
    "pdf" : "application/pdf",
    "pfx" : "application/x-pkcs12",
    "pgm" : "image/x-portable-graymap",
    "pko" : "application/ynd.ms-pkipko",
    "pma" : "application/x-perfmon",
    "pmc" : "application/x-perfmon",
    "pml" : "application/x-perfmon",
    "pmr" : "application/x-perfmon",
    "pmw" : "application/x-perfmon",
    "pnm" : "image/x-portable-anymap",
    "pot" : "application/vnd.ms-powerpoint",
    "ppm" : "image/x-portable-pixmap",
    "pps" : "application/vnd.ms-powerpoint",
    "ppt" : "application/vnd.ms-powerpoint",
    "prf" : "application/pics-rules",
    "ps" : "application/postscript",
    "pub" : "application/x-mspublisher",
    "qt" : "video/quicktime",
    "ra" : "audio/x-pn-realaudio",
    "ram" : "audio/x-pn-realaudio",
    "ras" : "image/x-cmu-raster",
    "rgb" : "image/x-rgb",
    "rmi" : "audio/mid",
    "roff" : "application/x-troff",
    "rtf" : "application/rtf",
    "rtx" : "text/richtext",
    "scd" : "application/x-msschedule",
    "sct" : "text/scriptlet",
    "setpay" : "application/set-payment-initiation",
    "setreg" : "application/set-registration-initiation",
    "sh" : "application/x-sh",
    "shar" : "application/x-shar",
    "sit" : "application/x-stuffit",
    "snd" : "audio/basic",
    "spc" : "application/x-pkcs7-certificates",
    "spl" : "application/futuresplash",
    "src" : "application/x-wais-source",
    "sst" : "application/vnd.ms-pkicertstore",
    "stl" : "application/vnd.ms-pkistl",
    "stm" : "text/html",
    "sv4cpio" : "application/x-sv4cpio",
    "sv4crc" : "application/x-sv4crc",
    "svg" : "image/svg+xml",
    "swf" : "application/x-shockwave-flash",
    "t" : "application/x-troff",
    "tar" : "application/x-tar",
    "tcl" : "application/x-tcl",
    "tex" : "application/x-tex",
    "texi" : "application/x-texinfo",
    "texinfo" : "application/x-texinfo",
    "tgz" : "application/x-compressed",
    "tif" : "image/tiff",
    "tiff" : "image/tiff",
    "tr" : "application/x-troff",
    "trm" : "application/x-msterminal",
    "tsv" : "text/tab-separated-values",
    "txt" : "text/plain",
    "uls" : "text/iuls",
    "ustar" : "application/x-ustar",
    "vcf" : "text/x-vcard",
    "vrml" : "x-world/x-vrml",
    "wav" : "audio/x-wav",
    "wcm" : "application/vnd.ms-works",
    "wdb" : "application/vnd.ms-works",
    "wks" : "application/vnd.ms-works",
    "wmf" : "application/x-msmetafile",
    "wps" : "application/vnd.ms-works",
    "wri" : "application/x-mswrite",
    "wrl" : "x-world/x-vrml",
    "wrz" : "x-world/x-vrml",
    "xaf" : "x-world/x-vrml",
    "xbm" : "image/x-xbitmap",
    "xla" : "application/vnd.ms-excel",
    "xlc" : "application/vnd.ms-excel",
    "xlm" : "application/vnd.ms-excel",
    "xls" : "application/vnd.ms-excel",
    "xlt" : "application/vnd.ms-excel",
    "xlw" : "application/vnd.ms-excel",
    "xof" : "x-world/x-vrml",
    "xpm" : "image/x-xpixmap",
    "xwd" : "image/x-xwindowdump",
    "z" : "application/x-compress",
    "zip" : "application/zip"]
