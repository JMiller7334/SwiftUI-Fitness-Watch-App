//
//  ContentView.swift
//  MAD257-GymTrackerWatch Watch App
//
//  Created by student on 2/23/23.
//

import SwiftUI

struct Exercise{ // is like a class
    // properties are target/goals
    var name: String
    var sets: Int
    var reps: [Int]
    var weight: [Double]
    var exertion: [String]
    var exertionType: [String]
    var restMin: [Int]
    var restSec: [Int]
    var type: String
    
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
struct Workout{
    var name:String
    var exercises:[Exercise]
    var asDictionary : [String:Any] {
        let mirror = Mirror(reflecting: self)
        let dict = Dictionary(uniqueKeysWithValues: mirror.children.lazy.map({ (label:String?, value:Any) -> (String, Any)? in
          guard let label = label else { return nil }
          return (label, value)
        }).compactMap { $0 })
        return dict
      }
    mutating func addExercise(newExercise: Exercise){
        print("adding new exercise: \(newExercise)")
        self.exercises.append(newExercise)
    }
}




struct ContentView: View {
    
    //MARK: INIT VARS: variables such as class need to be initialized like below.
    var benchPress: Exercise
    var deadlift: Exercise
    var testWorkout: Workout
    init(){
        self.benchPress = Exercise(Name: "Benchpress", Sets: 3, Reps: [10, 8, 5], Weight: [185, 205, 225], Exertion: ["8", "8", "9"], ExertionType: ["RPE", "RPE", "RPE"], RestMin: [1, 1, 1], RestSec: [0,0,0], Type: "Str")
        
        self.deadlift = Exercise(Name: "Deadlift(Sumo)", Sets: 2, Reps: [2,2], Weight: [327, 350], Exertion: ["9", "9", "9"], ExertionType: ["RPE", "RPE", "RPE"], RestMin: [0, 0, 0], RestSec: [90, 90, 90], Type: "Str")
        
        self.testWorkout = Workout(name: "Test Workout", exercises: [])
        self.testWorkout.addExercise(newExercise: self.benchPress)
        self.testWorkout.addExercise(newExercise: self.deadlift)
    }
   
    
    //MARK: VARS
    @State var currentRecord = [Exercise]()
    var pastRecords = [
        Exercise(Name: "benchpress", Sets: 2, Reps: [10, 8], Weight: [185, 205], Exertion: ["10", "10"], ExertionType: ["RPE", "RPE"], RestMin: [0,0,0], RestSec: [120, 120], Type: "Str")
    ]
    
    
    @State var currentSet = 1
    @State var currentPhase = 0
    @State var currentExercise = 0

    //MARK: STATE VARS
    @State var userInput = ""
    @State var input1 = 0
    @State var input2 = 0
    @State var input3 = 0
    @State var summaryText = "test"
    @State var phaseTitle = "phase"
    @State var summaryShown: Bool = true
    
    //picker related -- whether data was written.
    @State var madeInputs = 5
    
    @State var buttonConfirmText = "START"
    
    //MARK: USER INTERFACE
    var body: some View {
        VStack {
            Text(phaseTitle)
            //if statement to set screen elements (THIS IS AWESOME!!!
            if summaryShown {
                ScrollView{
                    Text(summaryText).padding([.top], 3)
                }
            } else {
                HStack{
                    Picker("3", selection: $input3, content: {
                        ForEach(0..<10){n in
                            Text("\(n)").tag(n)
                        }.pickerStyle(.wheel)
                    })
                    Picker("2", selection: $input2, content: {
                        ForEach(0..<10){n in
                            Text("\(n)").tag(n)
                        }.pickerStyle(.wheel)
                    })
                    Picker("1", selection: $input1, content: {
                        ForEach(0..<10){n in
                            Text("\(n)").tag(n)
                        }.pickerStyle(.wheel)
                    })
                    
                }

                
            }
            
            HStack{
                Button("QUIT", action: {})
                Button(buttonConfirmText, action: {
                    onButtonTapped()
                })
            }.padding([.top], 10)
            
        //works like viewDidLoad() -- this will run my fuction on start up.
        }.onAppear { self.updateWorkout()}
    }
    
    //MARK: FUNCTION
    func updateWorkout(){
        //SET DISPLAY//
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
                    print("record total: \(pastRecords.count) INDEX:\(currentExercise)")
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
            
            
        //REST TIMER INPUT
        } else if (currentPhase == 3 && madeInputs > 3){
            print("START TIMER")
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
    
    func onButtonTapped(){
        if (currentPhase == 5){
            return
        }
        if (currentPhase == 0){
            currentPhase = 3 //To Summary/History
        } else if (currentPhase == 3){
            print("phase: \(currentPhase) set\(currentSet) Index\(currentExercise)")
            //currentPhase = 1//To Timer Input
            if (madeInputs == 1){
                //write to weight
                
                //indicates we haven't added the exercise to our record.
                print("\(input1)\(input2)\(input3)")
                guard let userInput = Double("\(input1)\(input2)\(input3)")
                    else {return}
                if(currentSet == 1){
                    currentRecord.append(Exercise(Name: testWorkout.exercises[currentExercise].name, Sets: currentSet, Reps: [], Weight: [userInput], Exertion: [], ExertionType: testWorkout.exercises[currentExercise].exertionType, RestMin: [], RestSec: [], Type: testWorkout.exercises[currentExercise].type))
                    
                    //if we haven't reached the maxium sets append to the existing array element for weight
                } else if (currentSet <= testWorkout.exercises[currentExercise].sets){
                    currentRecord[currentExercise].weight.append(userInput)
                    
                }
                madeInputs = 2
                phaseTitle = "Input Reps"
                return
                
            //  WRITE REPS
            } else if (madeInputs == 2){
                guard let userInput = Int("\(input1)\(input2)\(input3)") else {return}
                currentRecord[currentExercise].reps.append(userInput)
                madeInputs = 3
                phaseTitle = "Input RPE"
                return
                
            }else if (madeInputs == 3){
                let userInput = "\(input1)\(input2)\(input3)"
                currentRecord[currentExercise].exertion.append(userInput)
                madeInputs = 4
                phaseTitle = "Last Set Summary"
                summaryShown = true
                summaryText = "Sets:\(currentSet), Reps\(currentRecord[currentExercise].reps), \(currentRecord[currentExercise].exertion)"
                
                buttonConfirmText = "CONFIRM"
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
                    print("WORKOUT FINISHED")
                    currentPhase = 5
                    summaryShown = true
                    
                    var finalSummary = ""
                    for (_, obj) in currentRecord.enumerated(){
                        finalSummary = ("\(finalSummary) | \(obj)")
                    }
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
                return
            }
        }
        updateWorkout()
        print("phase@\(currentPhase)")
    }
    
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
