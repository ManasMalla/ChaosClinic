//
//  CrosswordView.swift
//  Chaos Clinic
//
//  Created by Manas Malla on 23/02/25.
//

import SwiftUI

struct CrosswordView: View {
    
    @State private var word1 = ""
    @State private var word2 = ""
    @State private var word3 = ""
    @State private var word4 = ""
    @State private var word5 = ""
    @State private var timer = 30
    
    @AppStorage("user-score") private var userScore = 20
    
    @State private var showNudgeValue = false
    @State private var nudgeValue = 0.0
    
    var onBack: ()->Void = {}
    var onChat: ()->Void = {}
    
    let crosswordGrids: [String] = [
        """
        Q W E R T O Y I O P A
        Z X C V B N M Q W E R
        S A D F G H J K L Z X
        V B N M Q W E B T Y U
        O P A S D F G H J K L
        X C V B N A P L A P T
        U I O P A C E F G H J
        L Z X C V B N M Q W E
        Z X R U B N M Q W A R
        A S D F G H J K L Z X
        """,
        """
        A S F O G H J K L Z X
        V B N M Q W E R A Y U
        O P A S S F G H J K L
        X C V B N A S S E R T
        Q W E R T Y U I O P A
        Z X C V B N M Q W E R
        A S D F G H A P P Y X
        V B N M Q W E R T Y U
        A S O N G H J K L Z X
        V B N M Q W E R T Y U
        """,
        """
        Q A N X I O U S O P A
        Z X C V A N G R Y E R
        A S D F G H J F U N X
        V B N M U W E R T N U
        O P A S I G H H J Y L
        X C V B L M Q W E R T
        U H O P T S D F G H J
        L Z X C Y B N M Q W E
        C O D I N G F U Z X C
        H A C K A T H O N S D
        """,
        """
        C O D I N G F U Z X C
        H A C K A T H O N S D
        A L G O R I T H M Q W
        O P T I M I Z E R T Y
        S Y S T E M S A S D F
        C O M P U T E R G H J
        E F F I C I E N K L Z
        M E M O R Y X C V B N
        V B N M Q W E R T Y U
        O P A S D F G H J K L
        """,
        """
        S U N S E T S Q W E R
        T R O P I C A L Z X C
        A D V E N T U R M Q R
        R A I N B O W Q W E R 
        I M A G I N E L Z X M 
        S P A R K L E Y Q W E
        E M O T I O N H Z X C
        N A T U R E H Q W E R
        A D V E N T U R M Q R
        R A I N B O W Q W E R 
        """,
        """
        M U S I C A L Y U I O
        E N T E R T A I N P A
        L Y R I C A L S D F G
        O R C H E S T R H J K
        D I A P H R A G L Z X
        Y O D E L I N G V B V
        X Y L O P H O N Q W E
        B A L L A D S Z X C V
        A D V E N T U R M Q R
        R A I N B O W Q W E R 
        """,
        """
        P L A N E T G A S D F
        O R B I T A L H J K L
        L U M I N O U S Z X C
        A S T R O N O M V B F
        R E F R A C T Q W E R
        I N F I N I T Y U I J
        Z E N I T H O P A S E
        A T M O S P H E D F O
        O R C H E S T R H J K
        D I A P H R A G L Z X
        I N T E R E S T G H W
        L O V E L Y L Z X C S
        """,
        """
        F R I E N D L Y U I O
        A D J A C E N T P A E
        M E M O R A B L S D F
        I N T E R E S T G H W
        L O V E L Y L Z X C S
        I N S P I R E V B N F
        A D M I R A B L Q W H
        R E L A T I V E R T V
        """,
        """
        G A L A X Y C Q W E R 
        R E G I O N A L T Y U 
        A D A P T A B L I O P 
        S O C I E T Y A S D L
        S Y M P A T H G H J S
        S U B S T A N C E Z D
        L I B E R T Y C V B F
        A M B I T I O N M Q L
        F R I E N D L Y U I O
        A D J A C E N T P A E
        """,
        """
        H E A L T H Y Q W E R 
        E N E R G E T I C T S
        A C T I V I T Y U I A
        R E L A X I N G O P A
        T H E R A P E U A S E
        B A L A N C E D F G S
        R E C O V E R Y H J P
        I M M U N I T Y L Z Z
        L I B E R T Y C V B F
        A M B I T I O N M Q L
        """
    ]
    @State var timerInstance: Timer? = nil
    @State private var timerActive = true
    var crosswordIndex = Int.random(in: 0...9)
    
    var body: some View {
        VStack{
            Spacer().frame(height: 24)
            
            HStack {
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
            Text(crosswordGrids[crosswordIndex])
                .font(.title2).font(.system(.title2, design: .monospaced)).onAppear{
                    startTimer()
                }.onDisappear{
                    timerActive = false
                    timerInstance?.invalidate()
                }
            Spacer()
            VStack{
                HStack{
                    TextField(text: $word1, prompt: Text("Guess a word"), label: {
                        Text("Word One")
                    }).padding().background(.regularMaterial).frame(maxWidth: 200).clipShape(RoundedRectangle(cornerRadius: 10))
                    TextField(text: $word2, prompt: Text("Guess a word"), label: {
                        Text("Word Two")
                    }).padding().background(.regularMaterial).frame(maxWidth: 200).clipShape(RoundedRectangle(cornerRadius: 10))
                }
                HStack{
                    TextField(text: $word3, prompt: Text("Guess a word"), label: {
                        Text("Word Three")
                    }).padding().background(.regularMaterial).frame(maxWidth: 200).clipShape(RoundedRectangle(cornerRadius: 10))
                    TextField(text: $word4, prompt: Text("Guess a word"), label: {
                        Text("Word Four")
                    }).padding().background(.regularMaterial).frame(maxWidth: 200).clipShape(RoundedRectangle(cornerRadius: 10))
                }
                
                    TextField(text: $word5, prompt: Text("Guess a word"), label: {
                        Text("Word Five")
                    }).padding().background(.regularMaterial).frame(maxWidth: 200).clipShape(RoundedRectangle(cornerRadius: 10))
            }.padding()
            Spacer()
            Button(action: {
                timerInstance?.invalidate()
                
                if isCorrect(word: word1) && isCorrect(word: word2) && isCorrect(word: word3) && isCorrect(word: word4) && isCorrect(word: word5){
                    //USER WON
                    showNudge(severity: 2)
                }else{
                    // SHOW SCORE
                    showNudge(severity: 1.5)
                }
            }, label: {
                Text("Submit").padding(.vertical, 8).padding(.horizontal, 24)
            }).buttonStyle(.borderedProminent).clipShape(.capsule).shadow(radius: 5, y: 4)
            Spacer()
        }
    }
}

#Preview {
    CrosswordView()
}

// MARK: FUNCTIONS

extension CrosswordView{
    
    func startTimer() {
        DispatchQueue.main.async {
            timerActive = true
        }
        timerInstance?.invalidate()
        timerInstance = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { _ in
            DispatchQueue.main.async {
                if !timerActive { return }
                if(timer == 20 && !checkIfUserIsInteractive()){
                    showNudge(severity: 0)
                }else if(timer == 10 && !checkIfUserIsInteractive()){
                    showNudge(severity: 0.5)
                }else if(timer == 0 && !checkIfUserIsInteractive()){
                    showNudge(severity: 1)
                }
                if(timer == 0){
                    timerActive = false
                    showNudge(severity: 2)
                }else if(!showNudgeValue){
                    withAnimation{
                        timer = timer - 1
                    }
                }
            }
        }
    }
    
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
        if(wordExistsInCrossword(word: word, grid: crosswordGrids[crosswordIndex])){
            return validateWord(word: word)
        }
        return false
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
