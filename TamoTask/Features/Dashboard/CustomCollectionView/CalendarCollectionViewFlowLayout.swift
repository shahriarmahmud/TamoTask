//
//  CalendarCollectionViewFlowLayout.swift
//  TamoTask
//
//  Created by Shahriar Mahmud on 2/25/21.
//

import UIKit

class CalendarCollectionViewFlowLayout : UICollectionViewFlowLayout, UICollectionViewDelegateFlowLayout {
    
    var itemsPerRow: CGFloat = 7
    var didSelectItemAt: ((_ collectionView: UICollectionView, _ indexPath: IndexPath)-> Void)?
    var didDeSelectItemAt: ((_ collectionView: UICollectionView, _ indexPath: IndexPath)-> Void)?
    
    override init() {
        super.init()
        
        self.configLayout()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        
        self.configLayout()
    }
    
    func configLayout() {
        itemSize = CGSize(width: 50, height: 70)
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        let availableWidth = collectionView.frame.width
        let widthPerItem = availableWidth / itemsPerRow
        
        return CGSize(width: widthPerItem, height: widthPerItem)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        DLog("table item selected")
        didSelectItemAt?(collectionView, indexPath)
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        DLog("table item deselected")
        didDeSelectItemAt?(collectionView, indexPath)
    }
}
