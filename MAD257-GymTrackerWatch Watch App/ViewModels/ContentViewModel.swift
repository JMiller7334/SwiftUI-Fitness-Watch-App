//
//  ContentViewModel.swift
//  MAD257-GymTrackerWatch Watch App
//
//  Created by student on 8/29/23.
//

import Foundation
import SwiftUI

extension ContentView {
    
    // configure the view model so it can be called by the contentView
    @MainActor class ViewModel: ObservableObject {
        //MARK: INIT VARS: variables such as class need to be initialized like below.
        /**below defines the mock workout that will be run by this app**/
        var benchPress: Exercise
        var deadlift: Exercise
        var testWorkout: Workout
        init(){ //init the class
            /**The workout is configured below with the exercise variable defined above. Normally this could be loaded in from a database.**/
            self.benchPress = Exercise(Name: "Benchpress", Sets: 3, Reps: [10, 8, 5], Weight: [185, 205, 225], Exertion: ["8", "8", "9"], ExertionType: ["RIR", "RPE", "RPE"], RestMin: [1, 1, 1], RestSec: [0,0,0], Type: "Str")
            
            self.deadlift = Exercise(Name: "Deadlift(Sumo)", Sets: 2, Reps: [2,2], Weight: [327, 350], Exertion: ["9", "9", "9"], ExertionType: ["RPE", "RPE", "RPE"], RestMin: [0, 0, 0], RestSec: [90, 90, 90], Type: "Str")
            
            self.testWorkout = Workout(name: "Test Workout", exercises: [])
            self.testWorkout.addExercise(newExercise: self.benchPress)
            self.testWorkout.addExercise(newExercise: self.deadlift)
        }
       
        
        //MARK: VARS
        //Published vars required.
        @Published var currentRecord = [Exercise]()// a list to hold the data from the current session - this data could then be saved.
        var pastRecords = [//a mockup past record to display what the user did last time for this workout.
            Exercise(Name: "benchpress", Sets: 2, Reps: [10, 8], Weight: [185, 205], Exertion: ["10", "10"], ExertionType: ["RIR", "RPE"], RestMin: [0,0,0], RestSec: [120, 120], Type: "Str")
        ]
        
        @Published var currentSet = 1
        @Published var currentPhase = 0
        @Published var currentExercise = 0

        //MARK: STATE VARS
        @Published var userInput = ""
        @Published var input1 = 0
        @Published var input2 = 0
        @Published var input3 = 0
        @Published var summaryText = "test"
        @Published var phaseTitle = "phase"
        @Published var summaryShown: Bool = true
        
        //picker related -- whether data was written.
        @Published var madeInputs = 5
        
        @Published var buttonConfirmText = "START"
        
        
        //MARK: FUNCTIONS
        /*Notes: this updates the display on the screen to show history and summary of set goals for the
         the current session.*/
        func workoutDetails(){
            //SET DISPLAY//
            print("App: getting workout details")
            if (currentPhase == 0 || currentPhase == 3 || currentPhase == 1){
                summaryShown = true
                //PHASE 1: WORKOUT
                if (currentPhase == 0){
                    phaseTitle = testWorkout.name
                    
                //PHASE 3
                } else {
                    //HANDLING UNFINISHED SETS OR NONE EXISTING HISTORY//
                    if (pastRecords.isEmpty) || (pastRecords[0].sets < currentSet){
                        phaseTitle = ("History: none")
                    } else {
                    //SHOW PAST HISTORY TO USER
                        print("App: record total: \(pastRecords.count) INDEX:\(currentExercise)")
                        if (pastRecords.count > currentExercise) { //verify the history exists
                            let recordExercise = pastRecords[currentExercise]
                            phaseTitle = ("Last time: Reps:\(recordExercise.reps[currentSet-1]), Weight:\(recordExercise.weight[currentSet-1]) lbs,  \(recordExercise.exertionType[currentSet-1]):\(recordExercise.exertion[currentSet-1])")
                        } else {
                            phaseTitle = ("History: none")
                        }
                       
                    }
                    buttonConfirmText = "BEGIN"
                    currentPhase = 3
                }
                
                summaryText = ("Set \(currentSet): \(testWorkout.exercises[currentExercise].name), Reps: \(testWorkout.exercises[currentExercise].reps[currentSet-1]), Sets: \(testWorkout.exercises[currentExercise].sets)")
                
                
            //REST TIMER INPUT: NOT USED CURRENTLY
            } else if (currentPhase == 3 && madeInputs > 3){
                /*var i = 0
                let timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true){ intervals in
                    print("timer: \(i)")
                    i += 1
                    if (currentPhase != 3){
                        intervals.invalidate()
                    }
                }*/
            }
            
        }
        
        /*This returns all variables and the screen to a default stat and workout can be started from the beginning.*/
        func onQuitButtonTapped(){
            print("App: quit workout")
            
            //reset all variable to an unstarted state.
            currentSet = 1
            currentPhase = 0
            currentExercise = 0
            userInput = ""
            input1 = 0
            input2 = 0
            input3 = 0
            summaryText = "test"
            phaseTitle = "phase"
            summaryShown = true
            
            madeInputs = 5
            buttonConfirmText = "START"
            currentRecord = [Exercise]()
            
            //update the screen to an unstarted state.
            workoutDetails()
        }
        /*Handles phases and screen updates, along with writting to the current session variable */
        func onButtonTapped(){
            if (currentPhase == 5){
                return
            }
            if (currentPhase == 0){
                print("phase - 3")
                currentPhase = 3 //To Summary/History
            } else if (currentPhase == 3){
                print("phase: \(currentPhase) set\(currentSet) Index\(currentExercise)")
                //currentPhase = 1//To Timer Input
                if (madeInputs == 1){
                    //write to weight
                    
                    //indicates we haven't added the exercise to our record.
                    print("\(input3)\(input2)\(input1)")
                    guard let userInput = Double("\(input3)\(input2)\(input1)")
                        else {return}
                    if(currentSet == 1){
                        currentRecord.append(Exercise(Name: testWorkout.exercises[currentExercise].name, Sets: currentSet, Reps: [], Weight: [userInput], Exertion: [], ExertionType: testWorkout.exercises[currentExercise].exertionType, RestMin: [], RestSec: [], Type: testWorkout.exercises[currentExercise].type))
                        
                        //if we haven't reached the maxium sets append to the existing array element for weight
                    } else if (currentSet <= testWorkout.exercises[currentExercise].sets){
                        currentRecord[currentExercise].weight.append(userInput)
                        
                    }
                    madeInputs = 2
                    phaseTitle = "Input Reps"
                    input1 = 0
                    input2 = 0
                    input3 = 0
                    return
                    
                //  WRITE REPS
                } else if (madeInputs == 2){
                    guard let userInput = Int("\(input3)\(input2)\(input1)") else {return}
                    currentRecord[currentExercise].reps.append(userInput)
                    madeInputs = 3
                    phaseTitle = "Input \(testWorkout.exercises[currentExercise].exertionType[currentSet-1])"
                    input1 = 0
                    input2 = 0
                    input3 = 0
                    return
                    
                }else if (madeInputs == 3){
                    let userInput = "\(input2)\(input1)"
                    currentRecord[currentExercise].exertion.append(userInput)
                    madeInputs = 4
                    phaseTitle = "Last Set Summary"
                    summaryShown = true
                    summaryText = "Sets:\(currentSet)\nReps\(currentRecord[currentExercise].reps)\nWeight\(currentRecord[currentExercise].weight)lbs.\nExertion\(currentRecord[currentExercise].exertion)"
                    
                    buttonConfirmText = "CONFIRM"
                    input1 = 0
                    input2 = 0
                    input3 = 0
                    return
                    
                }else if (madeInputs == 4){
                    madeInputs = 5
                    currentSet += 1
                    if (currentSet > testWorkout.exercises[currentExercise].sets){
                        currentRecord[currentExercise].sets = currentSet-1
                        currentExercise += 1
                        currentSet = 1
                    }
                    if (currentExercise >= testWorkout.exercises.count){
                        print("App: WORKOUT FINISHED")
                        currentPhase = 5
                        summaryShown = true
                        
                        var finalSummary = ""
                        for (_, _exercise) in currentRecord.enumerated(){
                            finalSummary = "\(finalSummary)\(_exercise.name):\nReps:\n\(_exercise.reps)\n\n Weight:\n\(_exercise.weight)lbs.\n\nRPE-Type:\n\(_exercise.exertionType)\n\nRPE:\(_exercise.exertion)\n\n\n"
                        }
                        phaseTitle = "Workout Summary"
                        summaryText = finalSummary
                        return
                    }
                    currentPhase = 1
                }
                else{
                    summaryShown = false
                    phaseTitle = "Input Weight" //This is our starting point for this sub phase.
                    madeInputs = 1
                    buttonConfirmText = ("NEXT")
                    input1 = 0
                    input2 = 0
                    input3 = 0
                    return
                }
            }
            workoutDetails()
            print("phase@\(currentPhase)")
        }
    }
}
