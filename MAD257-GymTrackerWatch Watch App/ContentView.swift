//
//  ContentView.swift
//  MAD257-GymTrackerWatch Watch App
//
//  Created by Jacob Miller on 2/23/23.
//

import SwiftUI

struct ContentView: View {
    
    //bring in the ViewModel
    @StateObject private var viewModel = ViewModel()
    
    //MARK: USER INTERFACE
    var body: some View {
        VStack {
            Text(viewModel.phaseTitle)
            //Screen UI elements are updated from here//
            /**if statements handle updating the screen elements. Listeners/connection are nested within the elements***/
            if viewModel.summaryShown {
                ScrollView{
                    Text(viewModel.summaryText).padding([.top], 3)
                }
            } else {
                HStack{
                    if (viewModel.madeInputs != 3) {
                        Picker("3", selection: $viewModel.input3, content: {
                            ForEach(0..<10){n in
                                Text("\(n)").tag(n)
                            }.pickerStyle(.wheel)
                        })
                    }
                    Picker("2", selection: $viewModel.input2, content: {
                        ForEach(0..<10){n in
                            Text("\(n)").tag(n)
                        }.pickerStyle(.wheel)
                    })
                    Picker("1", selection: $viewModel.input1, content: {
                        ForEach(0..<10){n in
                            Text("\(n)").tag(n)
                        }.pickerStyle(.wheel)
                    })
                }
            }
            HStack{
                Button("QUIT", action: {
                    viewModel.onQuitButtonTapped()
                })
                Button(viewModel.buttonConfirmText, action: {
                    viewModel.onButtonTapped()
                })
            }.padding([.top], 10)
            
        //works like viewDidLoad() -- this will run my fuction on start up.
        }.onAppear { viewModel.workoutDetails()}
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
