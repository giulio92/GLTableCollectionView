//
//  GLCollectionTableViewCell.swift
//  GLTableCollectionView
//
//  Created by Giulio Lombardo on 24/11/16.
//
//  MIT License
//
//  Copyright (c) 2018 Giulio Lombardo
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to
//  deal in the Software without restriction, including without limitation the
//  rights to use, copy, modify, merge, publish, distribute, sublicense, and/or
//  sell copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in
//  all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
//  FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS
//  IN THE SOFTWARE.
//

import UIKit

class GLIndexedCollectionViewFlowLayout: UICollectionViewFlowLayout {
	fileprivate var paginatedScroll: Bool?

	override func awakeFromNib() {
		super.awakeFromNib()
	}

	override func targetContentOffset(forProposedContentOffset proposedContentOffset: CGPoint, withScrollingVelocity velocity: CGPoint) -> CGPoint {
		guard proposedContentOffset.x > 0 else {
			return CGPoint(x: 0, y: 0)
		}

		// If the UICollectionView has paginatedScroll set to false there is no
		// need to apply any pagination logic, we will return the current
		// proposedContentOffset coordinates.
		guard paginatedScroll == true else {
			return CGPoint(x: proposedContentOffset.x, y: 0)
		}

		// It's not a bad idea to shield us for some strange cases where the
		// UICollectionView won't be there for any reason, since it comes in an
		// Optional flavor. If it won't be available we return the current
		// proposedContentOffset coordinates and exit.
		guard let collectionView: UICollectionView = collectionView else {
			return CGPoint(x: proposedContentOffset.x, y: 0)
		}

		let scannerFrame: CGRect = CGRect(x: proposedContentOffset.x,
		                                  y: 0,
		                                  width: collectionView.bounds.width,
		                                  height: collectionView.bounds.height)

		// If there is no UICollectionViewLayoutAttributes for the given
		// scannerFrame there is no reason to calculate a paginated layout for
		// it, so we return the current proposedContentOffset coordinates.
		guard let layoutAttributes: [UICollectionViewLayoutAttributes] = super.layoutAttributesForElements(in: scannerFrame) else {
			return CGPoint(x: proposedContentOffset.x, y: 0)
		}

		// To make paginated scrolling work fine this CGFloat below MUST be
		// equal to the value set in the insetForSectionAt method of
		// UICollectionView's UICollectionViewDelegate Flow Layout.
		let collectionViewInsets: CGFloat = 10.0

		// Since UICollectionViewFlowLayout's proposedContentOffset coordinates
		// won't take count of any UICollectionView UIEdgeInsets values we need
		// to fix it by adding collectionViewInsets to the .x coordinate.
		//
		// Note: This will only cover horizontal scrolling and pagination, if
		// you need vertical pagination replace the .x coordinate with .y and
		// update collectionViewInsets value with the appropriate one.
		let proposedXCoordWithInsets: CGFloat = proposedContentOffset.x + collectionViewInsets

		// We now create a variable and we assign a very high CGFloat to it (a
		// to cover very large UICollectionViewContentSize cases).
		// This var will hold the needed horizontal adjustment to make the
		// UICollectionView paginate scroll.
		var offsetCorrection: CGFloat = .greatestFiniteMagnitude

		// UICollectionViewLayoutAttributes may contain all sort of layout
		// attributes so we need to check if it belongs to a
		// UICollectionViewCell, otherwise logic won't work.
		layoutAttributes.filter { layoutAttribute -> Bool in

			layoutAttribute.representedElementCategory == .cell
		}.forEach { cellLayoutAttribute in

			// Now we loop through all the different layout attributes of the
			// UICollectionViewCells contained between the .x value of the
			// proposedContentOffset and collectionView's width, looking for the
			// cell which needs the least offsetCorrection value: it will mean
			// that it's the first cell on the left of the screen which will
			// give pagination.
			// To accurately calculate the offsetCorrection we will check only
			// the cells contained in one half of UICollectionView's width,
			// following the scrolling direction. The check will be done by the
			// if statement below. This will fix the "last cell" issue.
			let discardableScrollingElementsFrame: CGFloat = collectionView.contentOffset.x + (collectionView.frame.size.width / 2)

			if (cellLayoutAttribute.center.x <= discardableScrollingElementsFrame && velocity.x > 0) || (cellLayoutAttribute.center.x >= discardableScrollingElementsFrame && velocity.x < 0) {
				return
			}

			if abs(cellLayoutAttribute.frame.origin.x - proposedXCoordWithInsets) < abs(offsetCorrection) {
				offsetCorrection = cellLayoutAttribute.frame.origin.x - proposedXCoordWithInsets
			}
		}

		return CGPoint(x: proposedContentOffset.x + offsetCorrection, y: 0)
	}
}

class GLIndexedCollectionView: UICollectionView {
	/// The inner-`indexPath` of the GLIndexedCollectionView.
	///
	/// Use it to discriminate between all the possible GLIndexedCollectionViews
	/// inside `UICollectionView`'s `dataSource` and `delegate` methods.
	///
	/// This should be set and updated only through GLCollectionTableViewCell's
	/// `setCollectionViewDataSourceDelegate` func to avoid strange behaviors.
	var indexPath: IndexPath!
}

class GLCollectionTableViewCell: UITableViewCell {
	/// The `UICollectionView`-inside-a-`UITableViewCell` itself.
	///
	/// Keep the variable `public` so it would be easier to access later in the
	/// code, for example in UITableView's `dataSource` and
	/// `delegate` methods.
	///
	/// GLIndexedCollectionView requires a `strong` ARC reference, do not assign
	/// a `weak` reference to it otherwise it could be released unexpectedly,
	/// causing a crash.
	var collectionView: GLIndexedCollectionView!
	var collectionFlowLayout: GLIndexedCollectionViewFlowLayout!

	/// A Boolean value that controls whether the `UICollectionViewFlowLayout`
	/// of the GLIndexedCollectionView will paginate scroll or not.
	///
	/// Set [true]() to make the UICollectionView paginate scroll based on it's
	/// `itemSize`, set to [false]() for regular scrolling. The
	/// `UICollectionViewFlowLayout` will deduct the right scrolling offset
	/// values automatically so you should not set the `itemSize` value
	/// directly.
	///
	/// Default value is `nil`, since `Bool` is `Optional`.
	var collectionViewPaginatedScroll: Bool?

	override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
		super.init(style: style, reuseIdentifier: reuseIdentifier)

		collectionFlowLayout = GLIndexedCollectionViewFlowLayout()
		collectionFlowLayout.scrollDirection = .horizontal

		collectionView = GLIndexedCollectionView(frame: .zero, collectionViewLayout: collectionFlowLayout)
		collectionView.register(UINib(nibName: "GLIndexedCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: GLIndexedCollectionViewCell.identifier)
		collectionView.backgroundColor = .white
		collectionView.showsHorizontalScrollIndicator = false
		collectionView.showsVerticalScrollIndicator = false
		collectionView.bounces = true
		collectionView.isDirectionalLockEnabled = true
		collectionView.isMultipleTouchEnabled = false
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

	final override func layoutSubviews() {
		super.layoutSubviews()

		collectionFlowLayout.paginatedScroll = collectionViewPaginatedScroll

		if collectionViewPaginatedScroll == true {
			collectionView.isPagingEnabled = false
		}

		guard collectionView.frame != contentView.bounds else {
			return
		}

		collectionView.frame = contentView.bounds
	}

	override func setSelected(_ selected: Bool, animated: Bool) {
		super.setSelected(selected, animated: animated)

		// Configure the view for the selected state
	}

	/// Re-assigns `dataSource` and `delegate` classes back to the
	/// GLIndexedCollectionView inside GLCollectionTableViewCell.
	///
	/// Call this `func` in your [tableView(_:willDisplay:forRowAt:)](apple-reference-documentation://hs3G9NleF7)
	/// method of GLTableCollectionViewController so the UITableView will
	/// re-assign it automatically following the regular UITableViewCells reuse
	/// logic.
	///
	/// This method will also check if the re-assignment are needed or not.
	///
	/// - Parameter dataSource: The `dataSource` class for the
	/// GLIndexedCollectionView in the GLCollectionTableViewCell, responsible
	/// for the UICollectionView's `dataSource` methods.
	///
	/// - Parameter delegate: The `delegate class` for the
	/// GLIndexedCollectionView in the GLCollectionTableViewCell, responsible
	/// for the UICollectionView's delegation methods.
	///
	/// - Parameter indexPath: The inner-`indexPath` of the
	/// GLIndexedCollectionView, it's recommended to pass the same `indexPath`
	/// of the UITableViewCell to the GLIndexedCollectionView so they will share
	/// the same `indexPath.section` making easier to understand from which
	/// UITableViewCell the UICollectionView will come from.
	final func setCollectionView(dataSource: UICollectionViewDataSource, delegate: UICollectionViewDelegate, indexPath: IndexPath) {
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
