//
//  FileListViewController.swift
//  ShareDataStorage
//
//  Created by See.Ku on 2016/04/06.
//  Copyright (c) 2016 AxeRoad. All rights reserved.
//

import UIKit
import SK4Toolkit

class FileListViewController: UIViewController {

	@IBOutlet weak var tableView: UITableView!

	@IBAction func onConfig(sender: AnyObject) {
		g_config.openConfigViewController(self) { cancel in
			self.tableAdmin.updateFileInfoArray()
			self.tableView.reloadData()
		}
	}

	var tableAdmin: FileListTableAdmin!

    override func viewDidLoad() {
        super.viewDidLoad()

		// 後で目印に使うディレクトリを作成
//		makeMarkerDir()

		view.backgroundColor = UIColor.darkGrayColor()
		navigationItem.backBarButtonItem = sk4BarButtonItem(title: "Back")

		// テーブルビューの制約を修正
		let maker = SK4ConstraintMaker(viewController: self)
		maker.addOverlay(tableView, baseItem: view, maxWidth: 560)
		view.addConstraints(maker.constraints)

		tableAdmin = FileListTableAdmin(tableView: tableView, parent: self)
		tableAdmin.clearSeparator()

		AppEvent.UpdateData.recieveNotify(self) { [weak self] in
			self?.tableAdmin.updateFileInfoArray()
			self?.tableView.reloadData()
		}
    }

	override func viewWillAppear(animated: Bool) {
		super.viewWillAppear(animated)

		tableAdmin.viewWillAppear()
	}

	override func viewWillDisappear(animated: Bool) {
		super.viewWillDisappear(animated)

		tableAdmin.viewWillDisappear()
	}

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

	// /////////////////////////////////////////////////////////////

/*
	/// ディレクトリを探す時の目印になるディレクトリ
	func makeMarkerDir() {
		let path = sk4GetDocumentDirectory() + "ShareDataStorage"
		let man = NSFileManager.defaultManager()
		let _ = try? man.createDirectoryAtPath(path, withIntermediateDirectories: true, attributes: nil)
	}
*/

}

// eof
