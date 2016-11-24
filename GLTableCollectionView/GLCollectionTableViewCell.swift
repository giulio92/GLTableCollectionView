//
//  GLCollectionTableViewCell.swift
//  GLTableCollectionView
//
//  Created by Giulio Lombardo on 24/11/16.
//  Copyright © 2016 Giulio Lombardo. All rights reserved.
//

import UIKit

class GLIndexedCollectionView: UICollectionView {
	var indexPath: IndexPath!
}

class GLCollectionTableViewCell: UITableViewCell {
	@IBOutlet weak var collectionView: GLIndexedCollectionView!
	var collectionViewOffset: CGFloat = 0.0

	override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

	func setCollectionViewDataSourceDelegate(dataSource: UICollectionViewDataSource, delegate:UICollectionViewDelegate, indexPath: IndexPath) {
		collectionView.dataSource = dataSource
		collectionView.delegate = delegate
		collectionView.setContentOffset(self.collectionView.contentOffset, animated: false)

		collectionView.indexPath = indexPath
		collectionView.reloadData()
	}
}
