//
//  ContentView.swift
//  multiplyMe!
//
//  Created by Vladimir Dvornikov on 26/08/2023.
//

import SwiftUI

struct ContentView: View {
    
    @State private var questions = 3
    @State private var chosenNumber = 1
    @State private var userAnswer = ""
    @State private var rightAnswer = 0
    @State private var questionsCount = 0
    @State private var userCount = 0
    @State private var isCorrect = false
    @State private var showAlert = false
    @State private var gameOver = false
    @State private var fontColor = Color.black
    
    @FocusState private var isFocused: Bool
    
    
    let numberOfQuestions = [3, 6, 12]
    var allMultipliers = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12].shuffled()
        
    var body: some View {
                
        VStack {
            HStack {
                Text("Questions")
                Picker("Questions", selection: $questions) {
                    ForEach(numberOfQuestions, id: \.self) {
                        Text("\($0)")
                    }
                }
                .pickerStyle(.segmented)
            }
            
            HStack {
                Text("Chose number")
                Spacer()
                Picker("Chose number", selection: $chosenNumber) {
                    ForEach(1..<13, id: \.self) {
                        Text("\($0)")
                    }
                }
            }
                
            HStack {
                Text("\(chosenNumber) x \(allMultipliers[questionsCount]) =")
                TextField("??", text: $userAnswer)
                    .keyboardType(.decimalPad)
                    .focused($isFocused)
            }

            .font(.system(size: 50, weight: .bold, design: .default))
            .foregroundColor(fontColor)
            Spacer()
        }
        
        .padding()
        .alert(isCorrect ? "You got it!" : "You didn't!", isPresented: $showAlert) {
            Button("Next") {
                userAnswer = ""
                fontColor = Color.black
                if questionsCount < questions - 1 {
                    questionsCount += 1
                } else {
                    gameOver = true
                }
                showAlert = false
            }
        } message: {
            Text(isCorrect ? "\(userAnswer) is the right answer!" : "The correct answer is \(rightAnswer)")
        }
        .alert("Game over!", isPresented: $gameOver) {
            Button("New game") {
                reset()
            }
        } message: {
            Text("You score is \(userCount)")
        }
        .toolbar {
            ToolbarItemGroup(placement: .keyboard) {
                Spacer()
                Button("Check") {
                   isCorrect = checkAnswer()
                    if isCorrect {
                        fontColor = Color.green
                        userCount += 1
                    } else {
                        fontColor = Color.red
                    }
                    isFocused = false
                    showAlert = true
                }
                .disabled(self.userAnswer.isEmpty)

            }
        }
    }
    
    
    func checkAnswer() -> Bool {
        rightAnswer = chosenNumber * allMultipliers[questionsCount]
        return Int(userAnswer) == rightAnswer
    }
    func reset() {
        chosenNumber = 1
        questionsCount = 0
        userCount = 0
    }
}



struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
