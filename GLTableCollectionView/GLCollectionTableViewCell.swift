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

		// To make paginated scrolling work fine this CGFloat below must be
		// equal to the value set in the insetForSectionAt method
		// UICollectionView's UICollectionViewDelegate Flow Layout.
		let collectionViewInsets: CGFloat = 10.0

		// Since UICollectionViewFlowLayout proposedContentOffset coordinates
		// won't take count of any UICollectionView UIEdgeInsets values we need
		// to fix it by adding collectionViewInsets to .x coordinate.
		//
		// Note: This will cover horizonal scrolling and pagination, if you need
		// vertical pagination replace the .x coordinate with .y and update
		// collectionViewInsets value with the approriate one.
		let proposedXCoordWithInsets = proposedContentOffset.x + collectionViewInsets

		// We start by creating a variable and we assign a very high CGFloat to
		// it, a big number here is needed to cover very large
		// UICollectionViewContentSize cases.
		var offsetCorrection: CGFloat = .greatestFiniteMagnitude

		// Now we loop through all the different layout attributes of the
		// UICollectionViewCells contained between the .x value of the
		// proposedContentOffset and collectionView's width looking for the cell
		// which needs the least offsetCorrection.
		for layoutAttributes in super.layoutAttributesForElements(in: CGRect(x: proposedContentOffset.x, y: 0, width: collectionView!.bounds.width, height: collectionView!.bounds.height))! {
			// Since layoutAttributesForElements may contain all sort of layout
			// attributes we need to check if it belongs to a
			// UICollectionViewCell, otherwise logic won't work.
			if layoutAttributes.representedElementCategory == .cell {
				if abs(layoutAttributes.frame.origin.x - proposedXCoordWithInsets) < abs(offsetCorrection) {
					offsetCorrection = layoutAttributes.frame.origin.x - proposedXCoordWithInsets
				}
			} else {
				// Elements different from UICollectionViewCell will fall here.
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
