//
//  FileConfigViewController.swift
//  ShareDataStorage
//
//  Created by See.Ku on 2016/04/06.
//  Copyright (c) 2016 AxeRoad. All rights reserved.
//

import UIKit
import SK4Toolkit

class FileConfigViewController: SK4TableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

		let tv = makeDefaultTableView()

		// テーブルビューの制約を修正
		let maker = SK4ConstraintMaker(viewController: self)
		maker.addOverlay(tv, baseItem: view, maxWidth: 560)
		view.addConstraints(maker.constraints)

		let config = FileConfig()
		config.setup()
		setup(tableView: tv, configAdmin: config)

		AppEvent.UpdateData.recieveNotify(self) { [weak self] in
			self?.navigationController?.popViewControllerAnimated(false)
		}
	}

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

	// /////////////////////////////////////////////////////////////

	var shareDoc: UIDocumentInteractionController!

	func shareFile(path: String) {
		let url = NSURL(fileURLWithPath: path)
		shareDoc = UIDocumentInteractionController(URL: url)

		let cell = tableView.cellForRowAtIndexPath(NSIndexPath(forRow: 0, inSection: 1))!
		shareDoc.presentOptionsMenuFromRect(cell.bounds, inView: cell, animated: true)
	}
}

// eof
