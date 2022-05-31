//
//  String+Helper.swift
//  TamoTask
//
//  Created by Shahriar Mahmud on 1/13/21.
//  Copyright © 2021 Shahriar Mahmud. All rights reserved.
//

import Foundation
import UIKit

extension String {
    var isValidEmail: Bool {
        return NSPredicate(format: "SELF MATCHES %@", "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}").evaluate(with: self)
    }
}
