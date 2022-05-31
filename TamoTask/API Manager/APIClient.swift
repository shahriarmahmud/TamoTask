//
//  APIClient.swift
//  TamoTask
//
//  Created by Shahriar Mahmud on 4/7/20.
//  Copyright © 2020 Shahriar Mahmud. All rights reserved.
//

/**
 Cheet sheet
 https://codewithchris.com/alamofire/
 */

import Foundation
import Alamofire
import SwiftyJSON


public enum Result<T> {
    case success(T)
    case failure(ErrorResponse)
}

typealias CompletionHandler<T> = (Result<T>) -> ()
public typealias ErrorResponse = (Int, Data?, Error)


class APIClient {
    //static let shared = APIClient()
    private static var privateShared : APIClient?
    
    class var shared: APIClient {
        guard let uwShared = privateShared else {
            privateShared = APIClient()
            return privateShared!
        }
        return uwShared
    }
    
    class func destroy() {
        privateShared = nil
    }
    
    private init() {}
    
    deinit {
        DLog("deinit singleton")
    }
    
    func ttHeaders() -> HTTPHeaders {
        let header: HTTPHeaders = ["Content-Type" : "application/x-www-form-urlencoded", "Accept" : "application/json", "Authorization" : "Bearer "]
        return header
    }
    
    private let sessionManager: Session = {
        let configuration = URLSessionConfiguration.af.default
        /*
         This configuration is the same as URLSessionConfiguration.default,
         but also includes Alamofire's default headers.
         */
        configuration.timeoutIntervalForRequest = 60
        configuration.timeoutIntervalForResource = 120
        
        // Authorization header added in AFRequestInterceptor class
        let afInterceptor = AFRequestInterceptor(token: "")
        
        #if DEBUG
        return Session(configuration: configuration, interceptor: afInterceptor, eventMonitors: [AFRequestMonitor()])
        #else
        return Session(configuration: configuration, interceptor: afInterceptor)
        #endif
        
        
    }()
}

extension APIClient {
    /// Returns a specific Object or Error
    func objectAPICall<T: Decodable>(apiEndPoint: Endpoint, modelType: T.Type,
                                     completion: @escaping CompletionHandler<T>) {
        sessionManager.request(apiEndPoint.path, method: apiEndPoint.method, parameters: apiEndPoint.query, encoding: apiEndPoint.encoding, headers: ttHeaders())
            .validate(statusCode: 200..<300)
            .responseDecodable { (response: AFDataResponse<T>) in
                switch response.result {
                case .success(let value):
                    completion(Result.success(value))
                case .failure(let error):
                    DLog(error.localizedDescription)
                    guard let statusCode = response.response?.statusCode else {
                        let unKnownError = ErrorResponse(-999, response.data, error)
                        let error = error.localizedDescription
                        if error.contains("The Internet connection appears to be offline"){
                            DispatchQueue.main.async {
                                Helper.showAlert(msg: Constants.noInternet)
                            }
                        }
                        completion(Result.failure(unKnownError))
                        return
                    }
                    let mError = ErrorResponse(statusCode, response.data, error)
                    let json = JSON(response.data ?? Data())
                    let msg = json["error"]["message"].stringValue
                    Helper.showAlert(msg: msg)
                    completion(Result.failure(mError))
                }
        }
    }
    
    /// Returns array of specific Object or Error
    func arrayObjectAPICall<T: Decodable>(apiEndPoint: Endpoint, modelType: T.Type, completion: @escaping CompletionHandler<[T]>) {
        sessionManager.request(apiEndPoint.path, method: apiEndPoint.method, parameters: apiEndPoint.query, encoding: apiEndPoint.encoding)
            //.debugLog()
            .validate(statusCode: 200..<300)
            .responseDecodable { (response: AFDataResponse<[T]>) in
                switch response.result {
                case .success(let value):
                    completion(Result.success(value))
                case .failure(let error):
                    DLog(error.localizedDescription)
                    guard let statusCode = response.response?.statusCode else {
                        let unKnownError = ErrorResponse(-999, response.data, error)
                        completion(Result.failure(unKnownError))
                        return
                    }
                    let mError = ErrorResponse(statusCode, response.data, error)
                    let json = JSON(response.data ?? Data())
                    let msg = json["error"]["message"].stringValue
                    Helper.showAlert(msg: msg)
                    completion(Result.failure(mError))
                }
        }
    }
    
    /// Returns JSON or Error
    func makeAPICall(apiEndPoint: Endpoint, completion: @escaping CompletionHandler<Any>) {
        sessionManager.request(apiEndPoint.path, method: apiEndPoint.method, parameters: apiEndPoint.query, encoding: apiEndPoint.encoding, headers: ttHeaders())
            .validate(statusCode: 200..<300)
            .responseJSON { response in
                switch response.result {
                case .success(let value):
                    completion(Result.success(value))
                case .failure(let error):
                    DLog(error.localizedDescription)
                    guard let statusCode = response.response?.statusCode else {
                        let unKnownError = ErrorResponse(-999, response.data, error)
                        let error = error.localizedDescription
                        if error.contains("The Internet connection appears to be offline"){
                            DispatchQueue.main.async {
                                Helper.showAlert(msg: "No Internet Connection. Please check your internet connectivity")
                            }
                        }
                        completion(Result.failure(unKnownError))
                        return
                    }
                    let mError = ErrorResponse(statusCode, response.data, error)
                    let json = JSON(response.data ?? Data())
                    let msg = json["error"]["message"].stringValue
                    Helper.showAlert(msg: msg)
                    completion(Result.failure(mError))
                }
        }
    }
    
}

extension APIClient {
    func download(url: URL, optionalFileName name: String, progress: @escaping ((Double) -> Void), completion: @escaping ((Bool,URL?) -> Void)) {
        
        let destination: DownloadRequest.Destination = { (temporaryURL, response) in
            let directoryURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
            let fileName = response.suggestedFilename ?? name
            let file = directoryURL.appendingPathComponent(fileName, isDirectory: false)
            //DLog("Given file Path = \(file)")
            return (file, [.createIntermediateDirectories, .removePreviousFile])
        }
        
        //if session manager don't work user AF instead.
        //And use headers after .get, headers: additionalHeaders
        sessionManager.download(url, method: .get, to: destination)
            .downloadProgress { (dwnldProgress) in
                progress(dwnldProgress.fractionCompleted)
        }.response { (dwnldResponse) in
                if let givnUrl = dwnldResponse.fileURL {
                    //DLog("Given URL = \(givnUrl)")
                    completion(true, givnUrl)
                } else {
                    completion(false, nil)
                }
        }
    }
    
    /**
     private var additionalHeaders: [String:String]? {
         //get token from keychain
         guard let token = AccountHelper.accessToken else {return nil}
         return ["Authorization": "Token token=" + token]
     }
     */
    
}
