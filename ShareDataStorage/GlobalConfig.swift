//
//  GlobalConfig.swift
//  ShareDataStorage
//
//  Created by See.Ku on 2016/04/07.
//  Copyright (c) 2016 AxeRoad. All rights reserved.
//

import UIKit
import SK4Toolkit

class GlobalConfig: SK4ConfigUserDefaults {

	let sortType = SK4ConfigIndex(title: "Sort Type", value: 0)
	let sortAscending = SK4ConfigBool(title: "Ascending", value: true)

	let deleteAll = SK4ConfigAction(title: "Delete All Data")

	let version = SK4ConfigString(title: "Version", value: "")

	override func onSetup() {
		title = "Config"

		let sec = addUserSection("Data Sort")
		sec.addConfig(sortType)
		sec.addConfig(sortAscending)

		sortType.choices = [
			"Name",
			"Date",
			"Size",
		]

		let info = addUserSection("Information")
		info.addConfig(version)
		version.value = sk4VersionString()

		let sec2 = addUserSection("")
		sec2.addConfig(deleteAll)
		deleteAll.textColor = UIColor.redColor()
		deleteAll.onAction = { [weak self] vc in
			self?.deleteAllExec(vc)
		}
	}

	func deleteAllExec(vc: UIViewController) {
		let alert = SK4AlertController(title: "Delete All Data?", message: "This operation can not be restored.")

		alert.addCancel("Cancel")

		alert.addDefault("OK") { al in
			self.deleteAllData(vc)
		}

		alert.presentAlertController(vc)
	}

	func deleteAllData(vc: UIViewController) {
		let path = sk4GetDocumentDirectory()
		let ar = sk4FileListAtPath(path)

		for fn in ar {
			let full = path.sk4AppendingPath(fn)
			sk4DeleteFile(full)
		}

		AppEvent.UpdateData.postNotify()

		sk4AlertView(title: "Delete All Data", message: "", vc: vc)
	}

}

// eof
