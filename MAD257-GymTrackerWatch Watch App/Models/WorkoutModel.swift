//
//  WorkoutModel.swift
//  MAD257-GymTrackerWatch Watch App
//
//  Created by student on 8/28/23.
//
import Foundation

/**Class oof Workout:
 Acts as container to group exercises together to make up a workout for the user.**/
struct Workout{
    var name:String
    var exercises:[Exercise]
    
    /**asDictionary is how I've built workout classes after the data for the workout is retrieved by firebase.
     This currently does not connect to any database but I have left this in here in case I change that later.**/
    var asDictionary : [String:Any] {
        let mirror = Mirror(reflecting: self)
        let dict = Dictionary(uniqueKeysWithValues: mirror.children.lazy.map({ (label:String?, value:Any) -> (String, Any)? in
          guard let label = label else { return nil }
          return (label, value)
        }).compactMap { $0 })
        return dict
    }
    //used to appened addition exercises to the exercise class.
    mutating func addExercise(newExercise: Exercise){
        print("adding new exercise: \(newExercise)")
        self.exercises.append(newExercise)
    }
}
