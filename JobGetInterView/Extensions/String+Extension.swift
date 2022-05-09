//
//  String+Extension.swift
//  JobGetInterView
//
//  Created by Mittal  gajjar on 2022-05-06.
//

import Foundation
extension String {
    func utf8String() -> UnsafePointer <Int8>? {
        //return self.
        return NSString(string: self).utf8String
    }
}
