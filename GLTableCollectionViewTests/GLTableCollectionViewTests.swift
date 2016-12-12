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

	override func setUp() {
		super.setUp()
		// Put setup code here. This method is called before the invocation of
		// each test method in the class.

		let storyboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
		tableCollectionView = storyboard.instantiateViewController(withIdentifier: "tableCollectionView") as! GLTableCollectionViewController
		tableCollectionView.beginAppearanceTransition(true, animated: false)
	}

	func testDataSource() {
		XCTAssertNotNil(tableCollectionView.tableView.dataSource, "UITableView dataSource is nil")
	}

	func testDelegate() {
		XCTAssertNotNil(tableCollectionView.tableView.delegate, "UITableView delegate is nil")
	}

	func testInstanceVariables() {
		XCTAssertGreaterThan(tableCollectionView.numberOfSections, 0, "UITableView must have at least one section")
		XCTAssertGreaterThan(tableCollectionView.numberOfCollectionsForRow, 0, "There must be at least a GLIndexedCollectionView per UITableViewCell")
		XCTAssertGreaterThan(tableCollectionView.numberOfCollectionItems, 0, "There must be at least one GLIndexedCollectionViewCell")
		XCTAssertNotEqual(tableCollectionView.tableCellID, "", "The cellIdentifier for the UITableViewCells must not be empty")
		XCTAssertTrue(tableCollectionView.tableCellID.hasSuffix("_section_#"), "The cellIdentifier for the UITableViewCells must end with section number suffix")
		XCTAssertNotEqual(tableCollectionView.collectionCellID, "", "The cellIdentifier for the UICollectionCells should not be empty")
	}

	func testRandomColorsGeneration() {
		let colorsDictionary: [Int: [UIColor]] = tableCollectionView.colorsDict

		XCTAssertNotNil(colorsDictionary, "Colors dictionary is nil")
		XCTAssertEqual(colorsDictionary.count, tableCollectionView.numberOfSections, "The number of keys in the colors dictionary must match the number of UITableView sections")

		for colorSection in 0..<tableCollectionView.numberOfSections {
			XCTAssertEqual(colorsDictionary[colorSection]!.count, tableCollectionView.numberOfCollectionItems, "The number of colors for section must match the number of UICollectionCells")
		}
	}

	func testUITableViewCellsClass() {
		let visibleCells: [UITableViewCell] = tableCollectionView.tableView.visibleCells

		for cell in visibleCells {
			XCTAssertTrue(cell is GLCollectionTableViewCell, "UITableViewCells must be GLCollectionTableViewCell")
		}
	}

	func testOpaqueFlag() {
		XCTAssertTrue(tableCollectionView.tableView.isOpaque, "The UITableView should be opaque for increased performances")
	}

	override func tearDown() {
		// Put teardown code here. This method is called after the invocation of
		// each test method in the class.
		super.tearDown()
	}
}
