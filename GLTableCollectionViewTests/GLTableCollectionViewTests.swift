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
	override func setUp() {
		super.setUp()
		// Put setup code here. This method is called before the invocation of
		// each test method in the class.
	}

	func testInstanceVariables() {
		let controller: GLTableCollectionViewController = GLTableCollectionViewController()

		XCTAssertGreaterThan(controller.numberOfSections, 0, "UITableView must have at least one section")
		XCTAssertGreaterThan(controller.numberOfCollectionsForRow, 0, "There must be at least a GLIndexedCollectionView per UITableViewCell")
		XCTAssertGreaterThan(controller.numberOfCollectionItems, 0, "There must be at least one GLIndexedCollectionViewCell")
		XCTAssertNotEqual(controller.tableCellID, "", "The cellIdentifier for the UITableViewCells must not be empty")
		XCTAssertTrue(controller.tableCellID.hasSuffix("_section_#"), "The cellIdentifier for the UITableViewCells must end with section number suffix")
		XCTAssertNotEqual(controller.collectionCellID, "", "The cellIdentifier for the UICollectionCells should not be empty")
	}

	func testRandomColorsGeneration() {
		let controller: GLTableCollectionViewController = GLTableCollectionViewController()
		controller.viewDidLoad()

		let colorsDictionary: [Int: [UIColor]] = controller.colorsDict

		XCTAssertNotNil(colorsDictionary, "Colors dictionary is nil")
		XCTAssertEqual(colorsDictionary.count, controller.numberOfSections, "The number of keys in the colors dictionary must match the number of UITableView sections")

		for colorSection in 0..<controller.numberOfSections {
			XCTAssertEqual(colorsDictionary[colorSection]!.count, controller.numberOfCollectionItems, "The number of colors for section must match the number of UICollectionCells")
		}
	}

	func testOpaqueFlag() {
		let controller: GLTableCollectionViewController = GLTableCollectionViewController()
		controller.viewDidLoad()

		XCTAssertTrue(controller.tableView.isOpaque, "The UITableView should be opaque for increased performances")
	}

	override func tearDown() {
		// Put teardown code here. This method is called after the invocation of
		// each test method in the class.
		super.tearDown()
	}
}
