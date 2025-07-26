//
//  SwiftUIView.swift
//  Chaos Clinic
//
//  Created by Manas Malla on 24/02/25.
//

import Combine
import SwiftUI

struct MindfulMeditationView: View {
    
    @State private var timer = 20
    @State private var breatheState = true
    @State private var timerActive = true
    @AppStorage("user-score") private var userScore = 20
    
    @State private var showNudgeValue = false
    @State private var nudgeValue = 0.0
    
    var onBack: ()->Void = {}
    
    
    var body: some View {
        VStack{
            Spacer().frame(height: 24)
            HStack {
                Spacer().frame(width: 48)
                Spacer()
                Text("00:\(timer < 10 ? "0\(timer)" : "\(timer)")").bold().contentTransition(.numericText(countsDown: true)).padding(.vertical).padding(.horizontal, 24).background(.thickMaterial).clipShape(.capsule).alert(isPresented: $showNudgeValue) {
                    
                    Alert(title: Text("Hurray"), message: Text(nudgeValue == 1.5 ? "You almost made, but yeah well done." : "Well done. You nailed it."), dismissButton: .default(Text("OK"), action: {
                        showNudgeValue = false
                        userScore = userScore + 20
                        onBack()
                    }))
                    
                }
                
                Spacer()
                Image(systemName: "xmark").onTapGesture {
                    timerActive = false
                    onBack()
                }.padding(.trailing, 24)
            }
            Spacer()
            VStack{
                Image("meditation").resizable().frame(width: breatheState ? 180 : 100, height: breatheState ? 180 : 100, alignment: .center).frame(minWidth: 180, minHeight: 180).padding(.vertical)
                Text(breatheState ? "Breathe in." : "Breathe out.").contentTransition(.numericText()).font(.largeTitle)
                Text("Nice and easy.")
            }.padding().onAppear {
                // Removed old Timer.scheduledTimer block
            }
            .onReceive(Timer.publish(every: 1, on: .main, in: .common).autoconnect()) { _ in
                guard timerActive else { return }
                if timer == 0 {
                    timerActive = false
                    showNudge(severity: 2)
                } else if !showNudgeValue {
                    withAnimation {
                        timer = timer - 1
                    }
                    if timer % 2 == 0 {
                        swapBreath()
                    }
                }
            }
            Spacer()
        }
    }
}

#Preview {
    MindfulMeditationView()
}

// MARK: FUNCTIONS

extension MindfulMeditationView{
    
    func swapBreath(){
        withAnimation{
            breatheState.toggle()
        }
    }
    
    func showNudge(severity: Double){
        showNudgeValue = true
        nudgeValue = severity
    }
}
