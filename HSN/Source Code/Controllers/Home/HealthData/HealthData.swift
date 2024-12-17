//
//  File.swift
//
//  Created by fluper on 17/03/20.
//  Copyright © 2020 Fluper. All rights reserved.
//

//import Foundation
//
//import HealthKit
//import UIKit
//
//class HealthKitInterface {
//
//    // STEP 2: a placeholder for a conduit to all HealthKit data
//    let healthKitDataStore: HKHealthStore?
//
//    // STEP 3: get a user's physical property that won't change
//    let genderCharacteristic        = HKCharacteristicType.characteristicType(forIdentifier: HKCharacteristicTypeIdentifier.biologicalSex)
//    let dateOfBirth                 = HKCharacteristicType.characteristicType(forIdentifier: HKCharacteristicTypeIdentifier.dateOfBirth)
//    let bloodType                   = HKCharacteristicType.characteristicType(forIdentifier: HKCharacteristicTypeIdentifier.bloodType)
//
//    let readableHKQuantityTypes     = HKQuantityType.quantityType(forIdentifier: HKQuantityTypeIdentifier.heartRate)
//    let workOuts                    = HKQuantityType.quantityType(forIdentifier: .appleExerciseTime)
//    let heightSampleType            = HKQuantityType.quantityType(forIdentifier: .height)
//    let activityEnergyType          = HKQuantityType.quantityType(forIdentifier: .activeEnergyBurned)
//    let stepCountType               = HKQuantityType.quantityType(forIdentifier: .stepCount)
//    let distanceWalkingRunningType  = HKQuantityType.quantityType(forIdentifier: .distanceWalkingRunning)
//    let summaryType                 = HKObjectType.activitySummaryType()
//    let workOutType                 = HKObjectType.workoutType()
//
//    // STEP 4: for flexibility, the API allows us to ask for
//    // multiple characteristics at once
//    let readableHKCharacteristicTypes: Set<HKObjectType>?
//
//    init() {
//
//        // STEP 5: make sure HealthKit is available
//        if HKHealthStore.isHealthDataAvailable() {
//
//            // STEP 6: create one instance of the HealthKit store
//            // per app; it's the conduit to all HealthKit data
//            self.healthKitDataStore = HKHealthStore()
//
//            // STEP 7: I create a Set of one as that's what the call wants
//            readableHKCharacteristicTypes = [genderCharacteristic!, readableHKQuantityTypes!, workOuts!, heightSampleType!, activityEnergyType!, dateOfBirth!, bloodType!, stepCountType!, distanceWalkingRunningType!, summaryType, workOutType]
//
//            // STEP 8: request user permission to read gender and
//            // then read the value asynchronously
//
//            getHealthData()
//
//        } // end if HKHealthStore.isHealthDataAvailable()
//
//        else {
//            self.healthKitDataStore = nil
//            readableHKCharacteristicTypes = nil
//        }
//
//    } // end init()
//
//    func getHealthData(){
//        switch kSharedUserDefaults.getHealthStatus(){
//        case 0:
//
//
//            let alertVC = UIAlertController(style: .actionSheet, title: "Hlthera Fitness Track", message: "Introducing Hlthera Fitness Track, keep track of your workout records with us. To enable Fitness Track, we need health app permissions.", tintColor: UIColor(named: "3")!)
//
//            let fitnessTrackVCAction = UIAlertAction(title: "View fitness track", style: .default, handler: {_ in
//                alertVC.dismiss(animated: true, completion: {
//                    CommonUtils.showToast(message: "Under Developement")
//                })
//
//            })
//            let askPermissionAction = UIAlertAction(title: "Ask permissions", style: .default, handler: {_ in
//                alertVC.dismiss(animated: true, completion: {
//                    self.healthKitDataStore?.requestAuthorization(toShare: nil,
//                                                             read: self.readableHKCharacteristicTypes,
//                                                                  completion: { (success, error) -> Void in
//                                                                    if success {
//                                                                        kSharedUserDefaults.setHealthPreferences(status: 1)
//                                                                        print("Successful authorization.")
//                                                                    } else {
//                                                                        kSharedUserDefaults.setHealthPreferences(status: 0)
//                                                                        print(error.debugDescription)
//                                                                    }
//                                                            })
//                })
//
//            })
//            let remindPermissionAction = UIAlertAction(title: "Remind me later", style: .cancel, handler: {_ in
//                alertVC.dismiss(animated: true, completion: {
//                    kSharedUserDefaults.setHealthPreferences(status: 0)
//                })
//
//            })
//            let denyPermissionAction = UIAlertAction(title: "Don't ask again", style: .destructive, handler: {_ in
//                alertVC.dismiss(animated: true, completion: {
//                    kSharedUserDefaults.setHealthPreferences(status: 2)
//                })
//            })
//            alertVC.addAction(fitnessTrackVCAction)
//            alertVC.addAction(askPermissionAction)
//            alertVC.addAction(remindPermissionAction)
//            alertVC.addAction(denyPermissionAction)
//
//            UIApplication.shared.windows.first?.rootViewController?.present(alertVC, animated: true, completion: nil)
//
//
//            print("need to ask health data")
//        case 1:
//            print("accessed health data")
//        case 2:
//            print("user denied access of health data")
//        default: kSharedUserDefaults.setHealthPreferences(status: 0)
//        }
//    }
//    //MARK:- Read Gender
//    //@Auther :- Deepak Kumar
//    func readGenderType() -> String {
//        do {
//            let genderType = try self.healthKitDataStore?.biologicalSex()
//
//            if genderType?.biologicalSex == .female {
//                print("Gender is female.")
//                return "Female"
//            }
//            else if genderType?.biologicalSex == .male {
//                print("Gender is male.")
//                return "Male"
//            }
//            else {
//                print("Gender is unspecified.")
//                return ""
//            }
//        }
//        catch {
//            print("Error looking up gender.")
//            return ""
//        }
//        return ""
//    } // end func readGenderType
//
//    //MARK:- Read Date Of Birth
//    //@Auther :- Deepak Kumar
//    func readDateOfBirthType() -> String {
//
//        var dateOfBirth: String? {
//            do {
//                if let dateOfBirth = try self.healthKitDataStore?.dateOfBirthComponents() {
//                    let formatter = DateFormatter()
//                    formatter.dateStyle = .short
//                    return formatter.string(from: dateOfBirth.date!)
//                }
//                return ""
//            }
//            catch {
//                print("Error looking up gender.")
//                return ""
//            }
//        }
//        return dateOfBirth ?? ""
//    } // end func readDateOfBirthType
//
//    //MARK:- Read Blood Group
//    //@Auther :- Deepak Kumar
//    func readBloodGroupType() -> String {
//        var bloodType: String? {
//            do {
//                if let bloodType = try self.healthKitDataStore?.bloodType() {
//                    switch bloodType.bloodType {
//                        case .aPositive:
//                            return "A+"
//                        case .aNegative:
//                            return "A-"
//                        case .bPositive:
//                            return "B+"
//                        case .bNegative:
//                            return "B-"
//                        case .abPositive:
//                            return "AB+"
//                        case .abNegative:
//                            return "AB-"
//                        case .oPositive:
//                            return "O+"
//                        case .oNegative:
//                            return "O-"
//                        case .notSet:
//                            return nil
//                    }
//                }
//            }
//            catch {
//                print("Error looking up gender.")
//                return ""
//            }
//            return ""
//        }
//            return bloodType ?? ""
//    } // end func readBloodGroupType
//
//    //MARK:- Read Step
//    //@Auther :- Deepak Kumar
//    func readStepCountType(completion: @escaping (String) -> Void) {
//        let stepsQuantityType = HKQuantityType.quantityType(forIdentifier: .stepCount)!
//
//        let now = Date()
//        let startOfDay = Calendar.current.startOfDay(for: now)
//        let predicate = HKQuery.predicateForSamples(withStart: startOfDay, end: now, options: .strictStartDate)
//
//        let query = HKStatisticsQuery(quantityType: stepsQuantityType, quantitySamplePredicate: predicate, options: .cumulativeSum) { _, result, _ in
//            guard let result = result, let sum = result.sumQuantity() else {
//
//                return
//            }
//            print(result)
//            print(sum)
//            completion("\(sum)")
//        }
//
//        healthKitDataStore?.execute(query)
//
//    } // end func readStepType
//
//    //MARK:- Get Active Energy Burn
//    //@Auther :- Deepak Kumar
//    func getActiveEnergyBurn(completion: @escaping (String) -> Void) {
//         let stepsQuantityType = HKQuantityType.quantityType(forIdentifier: .activeEnergyBurned)!
//
//        let now = Date()
//
//        //let earlyDate = Calendar.current.date(byAdding: .day, value: -32, to: now)
//        let startOfDay = Calendar.current.startOfDay(for: now)
//        let predicate = HKQuery.predicateForSamples(withStart: startOfDay, end: now, options: .strictStartDate)
//
//        let query = HKStatisticsQuery(quantityType: stepsQuantityType, quantitySamplePredicate: predicate, options: .cumulativeSum) { _, result, _ in
//            guard let result = result, let sum = result.sumQuantity() else {
//                return
//            }
//            print(result)
//            print(sum)
//            completion("\(sum)")
//        }
//        healthKitDataStore?.execute(query)
//    }
//
//    //MARK:- Get Exercise Time
//    //@Auther :- Deepak Kumar
//    func getExerciseTime(completion: @escaping (Double) -> Void) {
//        let exerciseQuantityType = HKQuantityType.quantityType(forIdentifier: .appleExerciseTime)!
//
//        let now = Date()
//        let earlyDate = Calendar.current.date(byAdding: .day, value: -6, to: now)
//        let startOfDay = Calendar.current.startOfDay(for: earlyDate!)
//        let predicate = HKQuery.predicateForSamples(withStart: startOfDay, end: now, options: .strictStartDate)
//
//        //let predicate = HKQuery.predicateForWorkouts(with: .other)
//
//        let query = HKStatisticsQuery(quantityType: exerciseQuantityType, quantitySamplePredicate: predicate, options: .cumulativeSum ) { (_, result, error) in
//            var resultCount = 0.0
//            guard let result = result else {
//                //log.error("Failed to fetch steps = \(error?.localizedDescription ?? "N/A")")
//                completion(resultCount)
//                return
//            }
//
//            if let sum = result.sumQuantity() {
//                resultCount = sum.doubleValue(for: HKUnit.minute())
//            }
//
//            DispatchQueue.main.async {
//                completion(resultCount)
//                print("Exercise time : \(resultCount)")
//            }
//        }
//        healthKitDataStore?.execute(query)
//
////        let workoutPredicate = NSPredicate(format: "(%K == %d) OR (%K == %d)",
////                HKPredicateKeyPathWorkoutType,
////                HKWorkoutActivityType.functionalStrengthTraining.rawValue,
////                HKPredicateKeyPathWorkoutType,
////                HKWorkoutActivityType.traditionalStrengthTraining.rawValue)
////
////        let predicate = HKQuery.predicateForWorkouts(with: .other)
////        let timePredicate = HKQuery.predicateForSamples(withStart: startOfDay, end: now, options: [])
////
////        let combinedPredicate = NSCompoundPredicate.init(andPredicateWithSubpredicates: [predicate, timePredicate])
////
////
////        let query1 = HKSampleQuery(sampleType: HKSampleType.workoutType(), predicate: combinedPredicate, limit: HKObjectQueryNoLimit, sortDescriptors: nil) { [weak self] (query, samples, error) in
////
////            guard let samples = samples as? [HKQuantitySample] else {
////                return
////            }
////
////            let values = samples.map { $0.quantity.doubleValue(for: HKUnit.minute()) }
////            print(values)
////        }
////
////        healthKitDataStore?.execute(query1)
//    }
//
//    //@available(iOS 12.0, *)
//    func getTodaysHeartRate(completion: @escaping (Double) -> Void) {
//        if #available(iOS 12.0, *) {
//            let heartRateType = HKQuantityType.quantityType(forIdentifier: .heartRate)!
//            let now = Date()
//            //let earlyDate = Calendar.current.date(byAdding: .day, value: -34, to: Date())
//            let startOfDay = Calendar.current.startOfDay(for: now)
//            let predicate = HKQuery.predicateForSamples(withStart: startOfDay, end: now, options: .strictStartDate)
//
//        //replaced options parameter .cumulativeSum with .discreteMostRecent
//        let query = HKStatisticsQuery(quantityType: heartRateType, quantitySamplePredicate: predicate, options: .discreteMostRecent) { (_, result, error) in
//            var resultCount = 0
//            guard let result = result else {
//                print("Failed to fetch heart rate")
//                completion(Double(resultCount))
//                return
//            }
//
//            // More changes here in order to get bpm value
//            guard let beatsPerMinute: Double = result.mostRecentQuantity()?.doubleValue(for: HKUnit.count().unitDivided(by: HKUnit.minute())) else { return }
//            resultCount = Int(beatsPerMinute)
//
//            DispatchQueue.main.async {
//                completion(Double(resultCount))
//            }
//        }
//        healthKitDataStore!.execute(query)
//    }
//        else {
//            // Fallback on earlier versions
//        }
//    }
//
//    //func retrieveStepCount(completion: (_ stepRetrieved: Double) -> Void) {
////
////            //   Define the Step Quantity Type
////            let stepsCount = HKQuantityType.quantityType(forIdentifier: HKQuantityTypeIdentifier.stepCount)
////
////            //   Get the start of the day
////            let date = Date()
////            let cal = Calendar(identifier: Calendar.Identifier.gregorian)
////            let newDate = cal.startOfDay(for: date)
////
////            //  Set the Predicates & Interval
////            let predicate = HKQuery.predicateForSamples(withStart: newDate, end: Date(), options: .strictStartDate)
////            var interval = DateComponents()
////            interval.day = 1
////
////            //  Perform the Query
////            let query = HKStatisticsCollectionQuery(quantityType: stepsCount!, quantitySamplePredicate: predicate, options: [.cumulativeSum], anchorDate: newDate as Date, intervalComponents:interval)
////
////            query.initialResultsHandler = { query, results, error in
////
////                if error != nil {
////
////                    //  Something went Wrong
////                    return
////                }
////
////                if let myResults = results{
////                    myResults.enumerateStatistics(from: self.yesterday, to: self.today) {
////                        statistics, stop in
////
////                        if let quantity = statistics.sumQuantity() {
////
////                            let steps = quantity.doubleValue(for: HKUnit.count())
////
////                            print("Steps = \(steps)")
////                            completion(stepRetrieved: steps)
////
////                        }
////                    }
////                }
////
////
////            }
////
////            storage.execute(query)
////        }
////
//
//} // end class HealthKitInterface
//
