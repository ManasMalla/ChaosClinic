//
//  BustBugView.swift
//  Chaos Clinic
//
//  Created by Manas Malla on 23/02/25.
//

import SwiftUI

struct BustBugView: View {
    
    @State private var bugsBusted = 0
    @State private var timer = 15
    @State private var timerActive = true
    
    @AppStorage("user-score") private var userScore = 20
    
    @State private var showNudgeValue = false
    @State private var nudgeValue = 0.0
    
    var onBack: ()->Void = {}
    var onChat: ()->Void = {}
    
    var body: some View {
        VStack{
            Spacer().frame(height: 24)
            HStack {
                Spacer().frame(width: 48)
                Spacer()
                Text("00:\(timer < 10 ? "0\(timer)" : "\(timer)")").contentTransition(.numericText(countsDown: true)).bold().padding(.vertical).padding(.horizontal, 24).background(.thickMaterial).clipShape(.capsule).alert(isPresented: $showNudgeValue) {
                    if(nudgeValue > 1.2){
                        Alert(title: Text("Hurray"), message: Text(nudgeValue == 1.5 ? "You almost made, but yeah well done." : "Well done. You nailed it. You earned \(bugsBusted) points."), dismissButton: .default(Text("OK"), action: {
                            showNudgeValue = false
                            userScore = userScore + bugsBusted
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
            Text("\(bugsBusted)").font(.title).bold()
            Spacer()
            VStack{
                LazyVGrid(columns: [GridItem(.adaptive(minimum: 60, maximum: 80))]){
                    ForEach(0..<20){ value in
                        var random = Int.random(in: 0...1) == 0 ? 1 : 0.5
                        Circle().foregroundStyle(ChaosClinicTheme.bugHoleColor.opacity(random)).overlay(
                            random == 1 ? Image("bug-report").resizable().frame(width: 40, height: 40) : nil
                        ).onTapGesture{
                            if(random == 1 && timer > 0){
                                bugsBusted = bugsBusted + 1
                            }
                        }
                                
                    }
                    
                }.padding()
            }.padding()
            .onAppear {
                timerActive = true
                Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { _ in
                    DispatchQueue.main.async {
                        if !timerActive { return }
                        if(timer == 10 && !checkIfUserIsInteractive()){
                            showNudge(severity: 0)
                        }else if(timer == 5 && !checkIfUserIsInteractive()){
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
            .onDisappear {
                timerActive = false
            }
            Spacer()
            Spacer()
        }.background(ChaosClinicTheme.getColor(red: 252, green: 205, blue: 1, alpha: 1.0))
    }
}

#Preview {
    BustBugView()
}

// MARK: FUNCTIONS

extension BustBugView{
    
    func checkIfUserIsInteractive() -> Bool{
        return bugsBusted > 0
    }
    func showNudge(severity: Double){
        showNudgeValue = true
        nudgeValue = severity
    }
}

