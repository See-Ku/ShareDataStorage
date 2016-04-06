//
//  AppAdmin.swift
//  ShareDataStorage
//
//  Created by See.Ku on 2016/04/07.
//  Copyright (c) 2016 AxeRoad. All rights reserved.
//

import UIKit
import SK4Toolkit

/// 各種通知
enum AppEvent: SK4Notify {
	case UpdateData
}

let g_admin = AppAdmin()

class AppAdmin {

	var filename = ""
	let dateFormatter = NSDateFormatter(dateStyle: .ShortStyle, timeStyle: .ShortStyle)

}

// eof
