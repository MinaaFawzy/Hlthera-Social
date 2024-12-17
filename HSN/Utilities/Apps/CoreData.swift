////
////  CoreData.swift
////  Core Data Example
////
////  Created by fluper on 20/09/19.
////  Copyright © 2019 fluper. All rights reserved.
////
//
//import Foundation
//import UIKit
//import CoreData
//
//let AppsCoredataReference = CoreDataClass.sharedInstanse
//let appDelegate = (UIApplication.shared.delegate as! AppDelegate)
//
//class CoreDataClass {
//
//    //Shared Instanse
//    internal static let sharedInstanse = CoreDataClass()
//
//    //Object s
//
//    var context = appDelegate.persistentContainer.viewContext
//
//
//    //Func for Save Data to Core Data
//    func requestForsaveData(entityName:String,forKey:String , responseData :Any)  {
//        let entity = NSEntityDescription.entity(forEntityName: entityName, in: self.context)!
//        let newUser = NSManagedObject(entity: entity, insertInto: self.context)
//        DispatchQueue.main.async {
//            newUser.setValue(responseData, forKey: forKey)
//            do { try self.context.save() } catch {print("Failed saving")}
//        }
//    }
//
//
//
//    //Func For FatchData From CoreData
//    func requestforData(entityName:String,forKey:String , completionClosure: @escaping (_ result: Any?) -> ()) -> Void {
//        let data = NSFetchRequest<NSFetchRequestResult>(entityName: entityName)
//        data.returnsObjectsAsFaults = false
//        do {
//            let result = try  context.fetch(data)
//            for data in result as! [NSManagedObject] {
//                let object = data.value(forKey: forKey)
//                completionClosure(object)
//            }
//        } catch {
//            print("Failed to fatch Data ")
//        }
//    }
//}
