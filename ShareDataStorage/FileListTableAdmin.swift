//
//  FileListTableAdmin.swift
//  ShareDataStorage
//
//  Created by See.Ku on 2016/04/06.
//  Copyright (c) 2016 AxeRoad. All rights reserved.
//

import UIKit
import SK4Toolkit

class FileListTableAdmin: SK4TableViewAdmin {

	struct FileInfo {
		let filename: String
		let createDate: NSDate
		let fileSize: UInt64
	}

	var fileInfoArray = [FileInfo]()

	func updateFileInfoArray() {
		fileInfoArray.removeAll(keepCapacity: true)
		makeFileInfoArray()
		sortFileInfoArray()
	}

	func makeFileInfoArray() {
		let path = sk4GetDocumentDirectory()
		let ar = sk4FileListAtPath(path)

		for fn in ar {
			let full = path.sk4AppendingPath(fn)

			if let info = sk4FileAttributesAtPath(full) {
				if info.fileType() != NSFileTypeRegular {
					continue
				}

				let cd = info.fileCreationDate() ?? NSDate(timeIntervalSinceReferenceDate: 0)
				let fs = info.fileSize()
				let make = FileInfo(filename: fn, createDate: cd, fileSize: fs)
				fileInfoArray.append(make)
			}
		}
	}

	func sortFileInfoArray() {
		fileInfoArray.sortInPlace() { (fi0, fi1) in
			var flag = false

			switch g_config.sortType.value {
			case 1:		// Date
				flag = fi0.createDate.timeIntervalSinceReferenceDate < fi1.createDate.timeIntervalSinceReferenceDate

			case 2:		// Size
				flag = fi0.fileSize < fi1.fileSize

			default:	// Name
				flag = fi0.filename < fi1.filename
			}

			if g_config.sortAscending.value == false {
				flag = !flag
			}

			return flag
		}
	}
	
	override func viewWillAppear() {
		updateFileInfoArray()
		tableView.reloadData()
	}

	// /////////////////////////////////////////////////////////////

	override func numberOfRows(section: Int) -> Int {
		return fileInfoArray.count
	}

	override func cellForRow(cell: UITableViewCell, indexPath: NSIndexPath) {
		let fi = fileInfoArray[indexPath.row]
		cell.textLabel?.text = fi.filename

		let create = g_admin.dateFormatter.sk4DateToString(fi.createDate) ?? ""
		let size = sk4FileSizeString(fi.fileSize)
		cell.detailTextLabel?.text = "Create: \(create) Size: \(size)"
	}

	override func didSelectRow(indexPath: NSIndexPath) {
		let fi = fileInfoArray[indexPath.row]
		g_admin.filename = fi.filename

		let vc = FileConfigViewController()
		parent.navigationController?.pushViewController(vc, animated: true)
	}

	// /////////////////////////////////////////////////////////////

	override func heightForHeader(section: Int) -> CGFloat {
		if fileInfoArray.isEmpty {
			return 254
		} else {
			return 0
		}
	}

	override func viewForHeader(section: Int) -> UIView? {
		if fileInfoArray.isEmpty == false {
			return nil
		}

		let img = UIImage(named: "ShareIcon")
		let vi = UIImageView(image: img)
		vi.contentMode = .ScaleAspectFit
		vi.backgroundColor = UIColor.whiteColor()
		return vi
	}

	// /////////////////////////////////////////////////////////////

	override func canEditRow(indexPath: NSIndexPath) -> Bool {
		return true
	}

	override func commitEditingDelete(indexPath: NSIndexPath) {

		// ファイルを削除
		let fi = fileInfoArray[indexPath.row]
		let full = sk4GetDocumentDirectory(fi.filename)
		sk4DeleteFile(full)

		// 管理してる配列から削除
		fileInfoArray.removeAtIndex(indexPath.row)

		// テーブルビューから削除
		if fileInfoArray.isEmpty {
			tableView.reloadData()
		} else {
			tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: UITableViewRowAnimation.Automatic)
		}
	}

}

// eof
