//
//  AFRequestMonitor.swift
//  TamoTask
//
//  Created by Shahriar Mahmud on 4/7/20.
//  Copyright © 2020 Shahriar Mahmud. All rights reserved.
//

/**
 https://stackoverflow.com/questions/26736428/how-can-i-log-each-request-response-using-alamofire
 https://github.com/Alamofire/Alamofire/issues/2724
 */

import Foundation
import Alamofire

final class AFRequestMonitor: EventMonitor {
    func requestDidResume(_ request: Request) {
        let allHeaders = request.request.flatMap { $0.allHTTPHeaderFields.map { $0.description } } ?? "None"
        let headers = """
        ⚡️⚡️⚡️⚡️ Request Started: \(request)
        ⚡️⚡️⚡️⚡️ Headers: \(allHeaders)
        """
        print(headers)


        let body = request.request.flatMap { $0.httpBody.map { String(decoding: $0, as: UTF8.self) } } ?? "None"
        let message = """
        ⚡️⚡️⚡️⚡️ Body Data: \(body)\n
        """
        print(message)
    }
  
    func request<Value>(_ request: DataRequest, didParseResponse response: AFDataResponse<Value>) {
        debugPrint("⚡️⚡️⚡️⚡️ ================ RESPONSE =================== ⚡️⚡️⚡️⚡️")
        debugPrint(response)
        debugPrint("⚡️⚡️⚡️⚡️ ================ RESPONSE END =============== ⚡️⚡️⚡️⚡️")
//        let body = request.data.map { String(decoding: $0, as: UTF8.self) } ?? "No body."
//        print("[Body]: \(body)")
    }
}
