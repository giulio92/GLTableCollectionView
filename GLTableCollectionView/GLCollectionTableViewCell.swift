//
//  GLCollectionTableViewCell.swift
//  GLTableCollectionView
//
//  Created by Giulio Lombardo on 24/11/16.
//  Copyright © 2016 Giulio Lombardo. All rights reserved.
//

import UIKit

class GLIndexedCollectionViewFlowLayout: UICollectionViewFlowLayout {
	var scrollPagination: Bool?

	override func awakeFromNib() {
		super.awakeFromNib()
	}

	override func targetContentOffset(forProposedContentOffset proposedContentOffset: CGPoint, withScrollingVelocity velocity: CGPoint) -> CGPoint {
		guard scrollPagination == true else {
			return CGPoint(x: proposedContentOffset.x, y: 0)
		}

		let collectionViewInsets: CGFloat = 10.0
		let proposedXCoordWithInsets = proposedContentOffset.x + collectionViewInsets

		var offsetCorrection: CGFloat = .greatestFiniteMagnitude

		for layoutAttributes in super.layoutAttributesForElements(in: CGRect(x: proposedContentOffset.x, y: 0, width: collectionView!.bounds.width, height: collectionView!.bounds.height))! {
			if abs(layoutAttributes.frame.origin.x - proposedXCoordWithInsets) < abs(offsetCorrection) {
				offsetCorrection = layoutAttributes.frame.origin.x - proposedXCoordWithInsets
			}
		}

		return CGPoint(x: proposedContentOffset.x + offsetCorrection, y: 0)
	}
}

class GLIndexedCollectionView: UICollectionView {
	/**
	
	The inner-`indexPath` of the GLIndexedCollectionView.

	You can use it to discriminate between all the possible
	GLIndexedCollectionViews inside UICollectionView's `dataSource` and
	`delegate` methods.
	
	This should be set and updated only through GLCollectionTableViewCell's
	`setCollectionViewDataSourceDelegate` func to avoid strange behaviors.

	*/
	var indexPath: IndexPath!
}

class GLCollectionTableViewCell: UITableViewCell {
	/**

	The UICollectionView inside a UITableViewCell itself.
	
	It's recommended to keep the variable `public` so it would be easier to
	access later in the code, for example in UITableView's `dataSource` and
	`delegate` methods. For light to mid-heavy implementations `weak` is also
	suggested.

	*/
	weak var collectionView: GLIndexedCollectionView!

	override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
		super.init(style: style, reuseIdentifier: reuseIdentifier)

		let collectionLayout: GLIndexedCollectionViewFlowLayout = GLIndexedCollectionViewFlowLayout()
		collectionLayout.scrollDirection = .horizontal
		collectionLayout.scrollPagination = true

		collectionView = GLIndexedCollectionView(frame: .zero, collectionViewLayout: collectionLayout)
		collectionView.register(UINib(nibName: "GLIndexedCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "collectionViewCellID")
		collectionView.backgroundColor = .white
		collectionView.showsHorizontalScrollIndicator = false
		collectionView.showsVerticalScrollIndicator = false
		collectionView.bounces = true
		collectionView.isDirectionalLockEnabled = true
		collectionView.isMultipleTouchEnabled = false

		if collectionLayout.scrollPagination == true {
			collectionView.isPagingEnabled = false
		}

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

		guard collectionView.frame != contentView.bounds else {
			return
		}

		collectionView.frame = contentView.bounds
	}

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

	/**
	
	Re-assigns `dataSource` and `delegate` classes back to the
	GLIndexedCollectionView inside GLCollectionTableViewCell.
	
	It's highly recommended to call this func in your [tableView(_:willDisplay:forRowAt:)](apple-reference-documentation://hs3G9NleF7)
	method of GLTableCollectionViewController so the UITableView will re-assign
	it automatically following the regular UITableViewCells reuse logic.
	
	This method will also check if the re-assignment is needed or not.

	- Parameter dataSource: The `dataSource` class for the
	GLIndexedCollectionView in the GLCollectionTableViewCell, it will be
	responsible for the usual UICollectionView `dataSource` methods.

	- Parameter delegate: The `delegate class` for the GLIndexedCollectionView
	in the GLCollectionTableViewCell, it will be responsible for the usual
	UICollectionView delegation methods.

	- Parameter indexPath: The inner-`indexPath` of the GLIndexedCollectionView,
	it's recommended to pass the same `indexPath` of the UITableViewCell to the
	GLIndexedCollectionView so they will share the same `indexPath.section`
	making easier to understand from which UITableViewCell the UICollectionView
	will come from.

	*/
	func setCollectionViewDataSourceDelegate(dataSource: UICollectionViewDataSource, delegate: UICollectionViewDelegate, indexPath: IndexPath) {
		collectionView.indexPath = indexPath
		
		if collectionView.dataSource == nil {
			collectionView.dataSource = dataSource
		}

		if collectionView.delegate == nil {
			collectionView.delegate = delegate
		}

		collectionView.reloadData()
	}
}
