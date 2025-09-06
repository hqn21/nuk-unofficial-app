//
//  String.swift
//  NUK Unofficial APP
//
//  Created by Hao-Quan Liu on 2022/7/15.
//

import Foundation

extension String {
    static func parseBIG5(data: Data) -> Self? {
        let big5Encoding = CFStringEncodings.big5_HKSCS_1999.rawValue
        let convertEncodingBig5 = CFStringConvertEncodingToNSStringEncoding(CFStringEncoding(big5Encoding))
        return String(data: data, encoding: String.Encoding(rawValue: convertEncodingBig5))
    }
    
    func utf8DecodedString()-> String {
        let data = self.data(using: .utf8)
        let message = String(data: data!, encoding: .nonLossyASCII) ?? ""
        return message
    }
        
    func utf8EncodedString()-> String {
        let messageData = self.data(using: .nonLossyASCII)
        let text = String(data: messageData!, encoding: .utf8) ?? ""
        return text
    }

    var length: Int {
        return count
    }

    subscript (i: Int) -> String {
        return self[i ..< i + 1]
    }

    func substring(fromIndex: Int) -> String {
        return self[min(fromIndex, length) ..< length]
    }

    func substring(toIndex: Int) -> String {
        return self[0 ..< max(0, toIndex)]
    }

    subscript (r: Range<Int>) -> String {
        let range = Range(uncheckedBounds: (lower: max(0, min(length, r.lowerBound)),
                                            upper: min(length, max(0, r.upperBound))))
        let start = index(startIndex, offsetBy: range.lowerBound)
        let end = index(start, offsetBy: range.upperBound - range.lowerBound)
        return String(self[start ..< end])
    }
}
