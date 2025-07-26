//
//  DetectiveProblemView.swift
//  Chaos Clinic
//
//  Created by Manas Malla on 23/02/25.
//

import SwiftUI

struct DetectiveProblemView: View {
    
    @State private var word1 = ""
    @State private var word2 = ""
    @State private var word3 = ""
    @State private var word4 = ""
    @State private var word5 = ""
    @State private var timer = 45
    
    @State private var timerInstance: Timer? = nil
    
    @AppStorage("user-score") private var userScore = 20
    
    @State private var showNudgeValue = false
    @State private var nudgeValue = 0.0
    
    var onBack: ()->Void = {}
    var onChat: ()->Void = {}
    
    
    var body: some View {
        VStack{
            Spacer().frame(height: 24)
            HStack{
                Spacer().frame(width: 48)
                Spacer()
                Text("00:\(timer < 10 ? "0\(timer)" : "\(timer)")").contentTransition(.numericText(countsDown: true)).bold().padding(.vertical).padding(.horizontal, 24).background(.thickMaterial).clipShape(.capsule).alert(isPresented: $showNudgeValue) {
                    if(nudgeValue > 1.2){
                        Alert(title: Text("Hurray"), message: Text(nudgeValue == 1.5 ? "You almost made, but yeah well done." : "Well done. You nailed it."), dismissButton: .default(Text("OK"), action: {
                            showNudgeValue = false
                            userScore = userScore + 20
                            onBack()
                        }))
                    }else{
                        Alert(title: Text("Just checking up"), message: Text(nudgeValue == 0 ? "Hope everything is ok?" : nudgeValue == 0.5 ? "Was it just challening or is there something bothering you?" : "I believe there is something really bothering you. You might want to vent it out?"), primaryButton: .default(Text("Chat With AI"), action: {
                            showNudgeValue = false
                            //TODO: NAVIGATE TO CHAT SCREEN
                            onChat()
                        }), secondaryButton: .default(Text("Nah, I'm fine"), action: {
                            showNudgeValue = false
                            if(timer == 0){
                                onBack()
                            }else{
                                withAnimation{
                                    timer = timer - 1
                                }
                            }
                        }))
                    }
                }
                Spacer()
                Image(systemName: "xmark").onTapGesture {
                    onBack()
                }.padding(.trailing, 24)
                
            }
            Spacer()
            Text("List out 5 issues you see around yourself in 45s")
            Spacer()
            VStack{
                TextField(text: $word1, prompt: Text("Guess a problem"), label: {
                    Text("Problem 1")
                }).padding().background(.regularMaterial).frame(maxWidth: 300).clipShape(RoundedRectangle(cornerRadius: 10))
                TextField(text: $word2, prompt: Text("Guess a problem"), label: {
                    Text("Problem 2")
                }).padding().background(.regularMaterial).frame(maxWidth: 300).clipShape(RoundedRectangle(cornerRadius: 10))
                TextField(text: $word3, prompt: Text("Guess a problem"), label: {
                    Text("Problem 3")
                }).padding().background(.regularMaterial).frame(maxWidth: 300).clipShape(RoundedRectangle(cornerRadius: 10))
                TextField(text: $word4, prompt: Text("Guess a problem"), label: {
                    Text("Problem 4")
                }).padding().background(.regularMaterial).frame(maxWidth: 300).clipShape(RoundedRectangle(cornerRadius: 10))
                
                TextField(text: $word5, prompt: Text("Guess a problem"), label: {
                    Text("Problem 5")
                }).padding().background(.regularMaterial).frame(maxWidth: 300).clipShape(RoundedRectangle(cornerRadius: 10))
            }.padding().onAppear{
                self.timerInstance = Timer.scheduledTimer(withTimeInterval: 1, repeats: true, block: { _ in
                    DispatchQueue.main.async {
                        if(timer == 30 && !checkIfUserIsInteractive()){
                            showNudge(severity: 0)
                        }else if(timer == 15 && !checkIfUserIsInteractive()){
                            showNudge(severity: 0.5)
                        }else if(timer == 0 && !checkIfUserIsInteractive()){
                            showNudge(severity: 1)
                        }
                        if(timer == 0){
                            timerInstance?.invalidate()
                            timerInstance = nil
                        }else if(!showNudgeValue){
                            withAnimation{
                                timer = timer - 1
                            }
                        }
                    }
                })
            }
            .onDisappear {
                timerInstance?.invalidate()
                timerInstance = nil
            }
            Spacer()
            Button(action: {
                if isCorrect(word: word1) && isCorrect(word: word2) && isCorrect(word: word3) && isCorrect(word: word4) && isCorrect(word: word5) {
                    //USER WON
                    showNudge(severity: 2)
                }else{
                    if(word1 == "" || word2 == "" || word3 == "" || word4 == "" || word5 == ""){
                        showNudge(severity: 0.8)
                    }else{
                        // SHOW SCORE
                        showNudge(severity: 1.5)
                    }
                }
            }, label: {
                Text("Submit").padding(.vertical, 8).padding(.horizontal, 24)
            }).buttonStyle(.borderedProminent).clipShape(.capsule).shadow(radius: 5, y: 4)
            Spacer()
        }
    }
}

#Preview {
    DetectiveProblemView()
}

// MARK: FUNCTIONS

extension DetectiveProblemView{
    
    func wordExistsInCrossword(word: String, grid: String) -> Bool {
        let rows = grid.components(separatedBy: "\n") // Split into rows

        // Check horizontally
        for row in rows {
            if row.contains(word.split(separator: "").joined(separator: " ")) {
                return true
            }
        }

        // Check vertically
        let numRows = rows.count
        guard numRows > 0 else { return false }
        let numCols = rows[0].count // Assuming all rows have the same length

        // Now you need to iterate with the string
        for col in 0..<numCols {
            var verticalWord = ""
            for row in 0..<numRows {
                // Accessing string using index is depreciated
                if(rows[row].count > col){
                    let index = String.Index(utf16Offset: col, in: rows[row])
                    verticalWord.append(rows[row][index])
                }
            }
            if verticalWord.contains(word) {
                return true
            }
        }

        return false
    }
    
    func isCorrect(word: String) -> Bool{
        return word != "" && validateWord(word: word)
    }
    func validateWord(word: String) -> Bool {
        let checker = UITextChecker()
        let range = NSRange(location: 0, length: word.utf16.count)
        let misspelledRange = checker.rangeOfMisspelledWord(in: word, range: range, startingAt: 0, wrap: false, language: "en")
        return misspelledRange.location == NSNotFound
    }
    func checkIfUserIsInteractive() -> Bool{
        return word1 != "" || word2 != "" || word3 != "" || word4 != "" || word5 != ""
    }
    func showNudge(severity: Double){
        showNudgeValue = true
        nudgeValue = severity
    }
}

