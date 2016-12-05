//
//  GLCollectionTableViewCell.swift
//  GLTableCollectionView
//
//  Created by Giulio Lombardo on 24/11/16.
//  Copyright © 2016 Giulio Lombardo. All rights reserved.
//

import UIKit

class GLIndexedCollectionViewFlowLayout: UICollectionViewFlowLayout {
	override func awakeFromNib() {
		super.awakeFromNib()
	}
}

class GLIndexedCollectionView: UICollectionView {
	var indexPath: IndexPath!
}

class GLCollectionTableViewCell: UITableViewCell {
	var collectionView: GLIndexedCollectionView!

	override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
		super.init(style: style, reuseIdentifier: reuseIdentifier)

		let collectionLayout: GLIndexedCollectionViewFlowLayout = GLIndexedCollectionViewFlowLayout()
		collectionLayout.scrollDirection = .horizontal

		collectionView = GLIndexedCollectionView(frame: .zero, collectionViewLayout: collectionLayout)
		collectionView.register(UINib.init(nibName: "GLIndexedCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "collectionViewCellID")
		collectionView.backgroundColor = .white
		collectionView.showsHorizontalScrollIndicator = false
		collectionView.showsVerticalScrollIndicator = false
		collectionView.bounces = true
		collectionView.isDirectionalLockEnabled = true
		collectionView.isMultipleTouchEnabled = false
		collectionView.isPagingEnabled = false
		collectionView.isOpaque = true

		contentView.addSubview(collectionView)
	}
	
	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

	override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

	override func layoutSubviews() {
		super.layoutSubviews()

		collectionView.frame = contentView.bounds
	}

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

	func setCollectionViewDataSourceDelegate(dataSource: UICollectionViewDataSource, delegate:UICollectionViewDelegate, indexPath: IndexPath) {
		collectionView.dataSource = dataSource
		collectionView.delegate = delegate
		collectionView.indexPath = indexPath

		collectionView.reloadData()
	}
}
