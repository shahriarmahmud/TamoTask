//
//  UIImageView+Helper.swift
//  TamoTask
//
//  Created by Shahriar Mahmud on 2/27/21.
//

import Foundation
import UIKit

extension UIImageView {
    func downloaded(from url: URL, contentMode mode: UIView.ContentMode = .scaleAspectFit) {
        contentMode = mode
        URLSession.shared.dataTask(with: url) { data, response, error in
            if data?.count == 0 {
                DispatchQueue.main.async() { [weak self] in
                    self?.image = Helper.getProfileImage()
                }
                return
            }else{
                guard
                    let httpURLResponse = response as? HTTPURLResponse, httpURLResponse.statusCode == 200,
                    let mimeType = response?.mimeType, mimeType.hasPrefix("image"),
                    let data = data, error == nil,
                    let image = UIImage(data: data)
                else {
                    DispatchQueue.main.async() { [weak self] in
                        self?.image = Helper.getProfileImage()
                    }
                    return
                }
                DispatchQueue.main.async() { [weak self] in
                    self?.image = image
                }
            }
            
        }.resume()
    }
    func downloaded(from link: String, contentMode mode: UIView.ContentMode = .scaleAspectFit) {
        guard let url = URL(string: link) else { return }
        downloaded(from: url, contentMode: mode)
    }
}
