//
//  DataBaseManager.swift
//  Dylan.Lee
//
//  Created by Dylan on 2017/7/25.
//  Copyright © 2017年 Dylan.Lee. All rights reserved.
//

import UIKit
import RealmSwift

//private let singleton =

private let dbVersion: UInt64 = 1

class DataBaseManager {
	
	
	public class var `default`: DataBaseManager {
		return DataBaseManager()
	}
	
	/// 默认数据库变量
	private lazy var realm = { () -> Realm in
		
		let docPath: String = NSSearchPathForDirectoriesInDomains(.documentDirectory,
		                                                          .userDomainMask,
		                                                          true).first!
		
		var path = docPath + "/DataBase/"
		
		FilesManager.default.creatFileDirectoryIfNotExit(path)
		
		path += "AutohomeMall.realm"

		var configuration = Realm.Configuration.defaultConfiguration
		
		configuration.fileURL = URL(string: path)
		
		
		configuration.schemaVersion = dbVersion
		DebugPrint(configuration.fileURL?.absoluteString ?? "")
		Realm.Configuration.defaultConfiguration = configuration
		
		let db = try! Realm()
		
		return db
	}()

	
	/// 查询
	///
	/// - Parameter type: 所查询的数据类型
	/// - Returns: 查询结果
	///		let dm = DataBaseManager.default
	///		let tests = dm.queryObjects(type: Test.self)
	func queryObjects<T: DBModel>(type: T.Type) -> Results<T> {
		let results = realm.objects(type)
		return results
	}
	
	
	/// 插入或更新数据
	///
	/// - Parameter objects: 需要插入的数据
	///		let testDic: [String: Any?] = ["time": "2017-08-12", "author": "李海洋001", "articleid": 1, "title": "测试数据库工具", "id": "002"];
	///		let test = Test(value: testDic)
	/// 	let dm = DataBaseManager.default
	///	    dm.insertOrUpdate(objects: [test])
	func insertOrUpdate<T: DBModel>(objects: [T]) {
		try! realm.write({
			realm.add(objects, update: true)
		})
	}
	
	
	/// 删除数据
	///
	/// - Parameter objects: 需要删除的数据
	/// 	let dm = DataBaseManager.default
	///		dm.deleteObjects(objects: [user])
	func deleteObjects<T: DBModel>(objects: [T]) {
		try! realm.write({ 
			realm.delete(objects)
		})
	}
	
	
}