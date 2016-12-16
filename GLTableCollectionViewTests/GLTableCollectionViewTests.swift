//
//  GLTableCollectionViewTests.swift
//  GLTableCollectionViewTests
//
//  Created by Giulio Lombardo on 24/11/16.
//  Copyright © 2016 Giulio Lombardo. All rights reserved.
//

import XCTest
@testable import GLTableCollectionView

class GLTableCollectionViewTests: XCTestCase {
	var tableCollectionView: GLTableCollectionViewController!
	var visibleCells: [UITableViewCell]!

	override func setUp() {
		super.setUp()
		// Put setup code here. This method is called before the invocation of
		// each test method in the class.

		let storyboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
		tableCollectionView = storyboard.instantiateViewController(withIdentifier: "tableCollectionView") as! GLTableCollectionViewController
		tableCollectionView.beginAppearanceTransition(true, animated: false)

		visibleCells = tableCollectionView.tableView.visibleCells
	}

	// MARK: <GLTableCollectionViewController>

	func testInstanceVariables() {
		XCTAssertGreaterThan(tableCollectionView.numberOfSections, 0, "UITableView must have at least one section")
		XCTAssertGreaterThan(tableCollectionView.numberOfCollectionsForRow, 0, "There must be at least a GLIndexedCollectionView per UITableViewCell")
		XCTAssertGreaterThan(tableCollectionView.numberOfCollectionItems, 0, "There must be at least one GLIndexedCollectionViewCell")
		XCTAssertNotEqual(tableCollectionView.tableCellID, "", "The cellIdentifier for the UITableViewCells must not be empty")
		XCTAssertTrue(tableCollectionView.tableCellID.hasSuffix("_section_#"), "The cellIdentifier for the UITableViewCells must end with section number suffix")
		XCTAssertTrue((tableCollectionView.tableCellID.components(separatedBy: "#").count - 1) == 1, "The cellIdentifier for the UITableViewCells must contain only one # in it")
		XCTAssertNotEqual(tableCollectionView.collectionCellID, "", "The cellIdentifier for the UICollectionCells should not be empty")
	}

	func testRandomColorsGeneration() {
		let colorsDictionary: [Int: [UIColor]] = tableCollectionView.colorsDict

		XCTAssertNotNil(colorsDictionary, "Colors dictionary is nil")
		XCTAssertNotEqual(colorsDictionary.count, 0, "Colors dictionary is empty")
		XCTAssertEqual(colorsDictionary.count, tableCollectionView.numberOfSections, "The number of keys in the colors dictionary must match the number of UITableView sections")

		for colorSection in 0..<tableCollectionView.numberOfSections {
			XCTAssertEqual(colorsDictionary[colorSection]!.count, tableCollectionView.numberOfCollectionItems, "The number of colors for section must match the number of UICollectionCells")
		}
	}

	func testTableViewDataSource() {
		XCTAssertNotNil(tableCollectionView.tableView.dataSource, "UITableView dataSource is nil")
	}

	func testTableViewDelegate() {
		XCTAssertNotNil(tableCollectionView.tableView.delegate, "UITableView delegate is nil")
	}

	func testUITableViewCellClass() {
		XCTAssertGreaterThan(visibleCells.count, 0, "UITableView visible cells must be greater than 0")

		for tableViewCell in visibleCells {
			XCTAssertTrue(tableViewCell is GLCollectionTableViewCell, "UITableViewCells must be GLCollectionTableViewCell")
		}
	}

	func testTableViewCellsIdentifier() {
		for tableViewCell in visibleCells as! [GLCollectionTableViewCell] {
			XCTAssertTrue(Int(tableViewCell.reuseIdentifier!.components(separatedBy: "#").last!)! >= 0, "The GLCollectionTableViewCell cellIdentifier must end with a positive integer")
		}
	}

	// MARK: <GLCollectionTableViewCell>

	func testDataSourceAndDelegateCollectionCells() {
		for tableViewCell in visibleCells as! [GLCollectionTableViewCell] {
			XCTAssertNotNil(tableViewCell.collectionView.dataSource, "GLCollectionTableViewCell dataSource is nil")
			XCTAssertNotNil(tableViewCell.collectionView.delegate, "GLCollectionTableViewCell delegate is nil")
		}
	}

	func testCollectionNativePaginationFlag() {
		for tableViewCell in visibleCells as! [GLCollectionTableViewCell] {
			if tableViewCell.collectionViewScrollPagination == true {
				XCTAssertTrue(tableViewCell.collectionView.isPagingEnabled, "Custom scrolling pagionation and native UICollectionView pagination can't be enabled at the same time")
			}
		}
	}

	// MARK: <Other>

	func testOpaqueFlag() {
		XCTAssertTrue(tableCollectionView.tableView.isOpaque, "The UITableView should be opaque for increased performances")

		for cell in visibleCells as! [GLCollectionTableViewCell] {
			XCTAssertTrue(cell.collectionView.isOpaque, "The UICollectionView should be opaque for increased performances")
		}
	}

	override func tearDown() {
		// Put teardown code here. This method is called after the invocation of
		// each test method in the class.
		super.tearDown()

		tableCollectionView.endAppearanceTransition()
	}
}
