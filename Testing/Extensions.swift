//
//  Extensions.swift
//  Testing
//
//  Created by 陈大师 on 2020/3/5.
//  Copyright © 2020 陈大师. All rights reserved.
//

import Foundation

extension Date {
    var milliStamp : CLongLong {
        let timeInterval: TimeInterval = self.timeIntervalSince1970
        return CLongLong(round(timeInterval*1000))
    }
    
    static func printRuntime(function: () -> Void) {
        let start = Date().milliStamp
        function()
        print("insertion used \(Date().milliStamp - start) ms")
    }
}
