//
//  ViewController.swift
//  HorizontallyCollectionViewExample
//
//  Created by TH on 11/16/18.
//  Copyright © 2018 TH. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UICollectionViewDataSource {
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    private let _itemsPerRow = 5
    private let _itemsPerColumn = 4
    private let _itemsPerPage = 5 * 4
    
    private lazy var _data: [Product] = {
        var colors = [
            UIColor(red: 1, green: 0, blue: 0, alpha: 1),
            UIColor(red: 0, green: 1, blue: 0, alpha: 1),
            UIColor(red: 0, green: 0, blue: 1, alpha: 1),
            UIColor(red: 1, green: 1, blue: 0, alpha: 1),
            UIColor(red: 0, green: 1, blue: 1, alpha: 1),
            UIColor(red: 1, green: 0, blue: 1, alpha: 1),
            UIColor(red: 0.5, green: 0.2, blue: 0.3, alpha: 1),
            UIColor(red: 0.2, green: 0.5, blue: 0, alpha: 1),
            UIColor(red: 1, green: 0.3, blue: 0, alpha: 1),
            ]
        var data = [Product]()
        for i in 0..<25 {
            let product = Product()
            product.name = "\(i)"
            product.color = colors[i % colors.count]
            data.append(product)
        }
        return data
    }()
    
    private lazy var _virtualCount: Int = {
        let count = _data.count
        let totalPages = Int(ceil(Double(count) / Double(_itemsPerPage)))
        return Int(totalPages) * _itemsPerPage
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        _updateLayout()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        self.collectionView.isPagingEnabled = true
        _updateLayout()
    }
    
    private func _updateLayout() {
        if !self.isViewLoaded { return }
        guard let flowLayout = self.collectionView.collectionViewLayout as? UICollectionViewFlowLayout else { return }
        let spacing: CGFloat = 4
        flowLayout.minimumLineSpacing = spacing
        flowLayout.minimumInteritemSpacing = spacing
        
        let size = self.collectionView.frame.size
        let hTotalSpacing = CGFloat(_itemsPerRow - 1) * spacing
        let vTotalSpacing = CGFloat(_itemsPerColumn - 1) * spacing
        
        let itemWidth = (size.width - hTotalSpacing) / CGFloat(_itemsPerRow)
        let itemHeight = (size.height - vTotalSpacing) / CGFloat(_itemsPerColumn)
        
        flowLayout.itemSize = CGSize(width: itemWidth, height: itemHeight)
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return _virtualCount
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if let index = _tryGetDataIndex(indexPath: indexPath) {
            let product = _data[index]
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! ProductCollectionViewCell
            cell.containerView.backgroundColor = product.color
            cell.titleLabel.text = product.name
            return cell
        }
        else {
            return collectionView.dequeueReusableCell(withReuseIdentifier: "Cell-Holder", for: indexPath)
        }
    }
    
    private func _tryGetDataIndex(indexPath: IndexPath)-> Int? {
        let index = indexPath.row;
        let page = index / _itemsPerPage
        let indexInPage = index - page * _itemsPerPage;
        let row = indexInPage % _itemsPerColumn;
        let column = indexInPage / _itemsPerColumn;
        
        let dataIndex = row * _itemsPerRow + column + page * _itemsPerPage
        if dataIndex >= _data.count {
            return nil
        }
        return dataIndex
    }
}


