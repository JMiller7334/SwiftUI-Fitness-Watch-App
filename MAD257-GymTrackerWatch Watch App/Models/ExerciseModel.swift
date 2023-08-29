//
//  ExerciseModel.swift
//  MAD257-GymTrackerWatch Watch App
//
//  Created by student on 8/28/23.
//

import Foundation

struct Exercise{
    /*The properties of the exercise. Exrcise are contained within the workout class and the primary building blocks
     of user built workouts
     
     below are the exercise properties.**/
    var name: String
    var sets: Int
    var reps: [Int]
    var weight: [Double]
    var exertion: [String]
    var exertionType: [String]
    var restMin: [Int]
    var restSec: [Int]
    var type: String
    
    
    /*This is used pulling class data down from firebase. Currently this app does not use firebase, but I have left this
     in here in case I change that in the future.**/
    var asDictionary : [String:Any] {
        let mirror = Mirror(reflecting: self)
        let dict = Dictionary(uniqueKeysWithValues: mirror.children.lazy.map({ (label:String?, value:Any) -> (String, Any)? in
          guard let label = label else { return nil }
          return (label, value)
        }).compactMap { $0 })
        return dict
    }
    init(Name: String ,Sets: Int, Reps: [Int], Weight:[Double], Exertion:[String], ExertionType:[String], RestMin:[Int], RestSec:[Int], Type:String){
        self.name = Name
        self.sets = Sets
        self.reps = Reps
        self.weight = Weight
        self.exertion = Exertion
        self.exertionType = ExertionType
        self.restMin = RestMin
        self.restSec = RestSec
        self.type = Type
    }
}
