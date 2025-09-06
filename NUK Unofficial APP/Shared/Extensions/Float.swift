//
//  Float.swift
//  NUK Unofficial APP
//
//  Created by Hao-Quan Liu on 2022/8/11.
//

import Foundation

extension Float {
    var clean: String {
       return self.truncatingRemainder(dividingBy: 1) == 0 ? String(format: "%.0f", self) : String(self)
    }
}
