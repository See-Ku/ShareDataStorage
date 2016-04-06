//
//  FileConfig.swift
//  ShareDataStorage
//
//  Created by See.Ku on 2016/04/06.
//  Copyright (c) 2016 AxeRoad. All rights reserved.
//

import UIKit
import SK4Toolkit

class FileConfig: SK4ConfigAdmin {

	let check = SK4LeakCheck(name: "FileConfig")

	let filename = SK4ConfigString(title: "Name", value: "")
	let fileTime = SK4ConfigString(title: "Create", value: "")
	let fileSize = SK4ConfigString(title: "Size", value: "")

	let shareFile = SK4ConfigAction(title: "Share File")
	let deleteFile = SK4ConfigAction(title: "Delete File")

	override func onSetup() {
		title = "Data Info"

		let sec1 = addUserSection("")
		sec1.addConfig(filename)
		sec1.addConfig(fileTime)
		sec1.addConfig(fileSize)
		filename.cell = SK4ConfigCellTextField(maxLength: 200)

		let sec2 = addUserSection("")
		sec2.addConfig(shareFile)
		shareFile.onAction = { [weak self] vc in
			self?.shareExec(vc)
		}

		let sec3 = addUserSection("")
		sec3.addConfig(deleteFile)
		deleteFile.textColor = UIColor.redColor()
		deleteFile.onAction = { [weak self] vc in
			self?.deleteExec(vc)
		}
	}

	override func onLoad() {
		filename.value = g_admin.filename

		let full = sk4GetDocumentDirectory(g_admin.filename)

		if let info = sk4FileAttributesAtPath(full) {
			let md = info.fileCreationDate()
			fileTime.value = g_admin.dateFormatter.sk4DateToString(md) ?? ""
			fileSize.value = sk4FileSizeString(info.fileSize())
		}
	}

	override func onSave() {
		if g_admin.filename != filename.value {
			let path = sk4GetDocumentDirectory()
			let src = path + g_admin.filename
			let dst = path + filename.value
			sk4MoveFile(src: src, dst: dst)
		}
	}

	// /////////////////////////////////////////////////////////////

	func shareExec(vc: UIViewController) {
		if let vc = vc as? FileConfigViewController {
			let full = sk4GetDocumentDirectory(g_admin.filename)
			vc.shareFile(full)
		}
	}

	func deleteExec(vc: UIViewController) {
		let alert = SK4AlertController(title: "Delete Data?", message: g_admin.filename)

		alert.addCancel("Cancel")

		alert.addDefault("OK") { al in
			let full = sk4GetDocumentDirectory(g_admin.filename)
			sk4DeleteFile(full)
			vc.navigationController?.popViewControllerAnimated(true)
		}

		alert.presentAlertController(vc)
	}
	
}

// eof
