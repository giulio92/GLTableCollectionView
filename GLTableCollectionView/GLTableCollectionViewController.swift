//
//  GLTableCollectionViewController.swift
//  GLTableCollectionView
//
//  Created by Giulio Lombardo on 24/11/16.
//  Copyright © 2016 Giulio Lombardo. All rights reserved.
//

import UIKit

class GLTableCollectionViewController: UITableViewController, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
	var scrollOffsetDictionary: [Int: CGFloat] = [:]

	override func viewDidLoad() {
		super.viewDidLoad()

		// Uncomment the following line to preserve selection between presentations
		// self.clearsSelectionOnViewWillAppear = false

		// Uncomment the following line to display an Edit button in the navigation bar for this view controller.
		// self.navigationItem.rightBarButtonItem = self.editButtonItem()
	}

	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
		// Dispose of any resources that can be recreated.
	}

	// MARK: <UITableView Data Source>

	override func numberOfSections(in tableView: UITableView) -> Int {
		return 20
	}

	override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return 1
	}

	override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		var cell: GLCollectionTableViewCell? = tableView.dequeueReusableCell(withIdentifier: "tableViewCellID" + indexPath.section.description) as? GLCollectionTableViewCell

		if cell == nil {
			cell = GLCollectionTableViewCell(style: .default, reuseIdentifier: "tableViewCellID")
			cell?.selectionStyle = .none
			cell?.isOpaque = true
			cell?.setCollectionViewDataSourceDelegate(dataSource: self, delegate: self, indexPath: indexPath)
		}

		// Configure the cell...

		return cell!
	}

	override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
		return "Section: " + section.description
	}

	override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
		return 88
	}

	override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
		return 28
	}

	override func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
		return 0.0001
	}

	// MARK: <UITableView Delegate>

	override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
		guard let cell = cell as? GLCollectionTableViewCell else {
			return
		}

		cell.setCollectionViewDataSourceDelegate(dataSource: self, delegate: self, indexPath: indexPath)
		cell.collectionViewOffset = scrollOffsetDictionary[indexPath.row] ?? 0.0
	}

	override func tableView(_ tableView: UITableView, didEndDisplaying cell: UITableViewCell, forRowAt indexPath: IndexPath) {
		guard let cell = cell as? GLCollectionTableViewCell else {
			return
		}

		scrollOffsetDictionary[indexPath.row] = cell.collectionViewOffset
	}

	// MARK: <UICollectionView Data Source>

	func numberOfSections(in collectionView: UICollectionView) -> Int {
		return 1
	}

	func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		return 10
	}

	func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
		let cell: GLIndexedCollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: "collectionViewCellID", for: indexPath) as! GLIndexedCollectionViewCell

		// Configure the cell...
		cell.backgroundColor = .gray

		return cell
	}

	// MARK: <UICollectionViewDelegate Flow Layout>

	func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
		return CGSize(width: 50, height: 50)
	}

	func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
		return UIEdgeInsetsMake(0, 10, 0, 10)
	}

	func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
		return 8
	}

	func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
		return 0
	}

	// MARK: <UICollectionView Delegate>

	func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
		
	}

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
}
