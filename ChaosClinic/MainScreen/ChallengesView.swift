//
//  SwiftUIView.swift
//  Chaos Clinic
//
//  Created by Manas Malla on 16/07/25.
//

import SwiftUI

struct Badge{
    var title: String
    var id: String
    var earned: Bool
    var dateEarned: Date?
    var progress: Double = 0
    var description: String
    var image: String
    
    func getCompleteDescription() -> String {
        if(earned){
            return "Earned \(description)"
        }else{
            return "Earn \(description)"
        }
    }
}

struct ChallengesView: View {
    
    @State var selectedBadge: Badge? = nil
    @Binding var isInternallyNavigated: Bool
    
    @State var showAlertDialog = false

    @State var badges: [Badge] = [
        Badge(title: "WWDC Week", id: "wwdc-badge-25", earned: true, dateEarned: Date(timeIntervalSinceReferenceDate: 761943200), progress: 1.0, description: "this badge by completing your submission for WWDC Swift Student Challenge.", image: "swift"),
        Badge(title: "Mindful Moments", id: "wwdc-badge-24", earned: false, dateEarned: nil, description: "this badge by completing 48 minutes of mindful meditation this week.", image: "apple.meditate"),
        Badge(title: "Bike to Work Monday", id: "bike-work-monday", earned: false, dateEarned: nil, description: "this badge by biking to work every Monday of this month.", image: "figure.outdoor.cycle")
        
    ]
    
    var body: some View {
        if(selectedBadge != nil){
            selectedBadgePage.alert(isPresented: $showAlertDialog) {
                Alert(title: Text("Challenge Mockup"), message: Text("We'll actually log this via HealthKit APIs and other programatic interfaces. This is just to show you how it would feel in the app."), dismissButton: .default(
                    Text("Got it!")
                , action: {
                    selectedBadge?.progress = (selectedBadge?.progress ?? 0.0) + 0.2
                    badges[badges.firstIndex { _badge in
                        return _badge.id == selectedBadge?.id
                    } ?? 0] = selectedBadge ?? badges[0]
                    if(selectedBadge?.progress == 1.0){
                        selectedBadge?.earned = true
                        selectedBadge?.dateEarned = Date()
                        badges[badges.firstIndex { _badge in
                            return _badge.id == selectedBadge?.id
                        } ?? 0] = selectedBadge ?? badges[0]
                    }
                }))
            }
        }else{
            VStack{
                heroSection
                ScrollView{
                    LazyVGrid(columns: [.init(.adaptive(minimum: 160))]){
                        ForEach(badges, id: \.id){ badge in
                            BadgeView(badge: badge).onTapGesture {
                                selectedBadge = badge
                                isInternallyNavigated = true
                            }
                        }
                    }
                }
                Spacer()
            }
            .padding()
        }
    }
}

struct BadgeView : View{
    var badge: Badge
    var showProgressIndicator = true
    var body: some View{
        VStack{
            VStack{
                BadgeBackground().frame(width: 140, height: 140).overlay(Image(systemName: badge.image).font(.largeTitle)).opacity(0.5)
                Text(badge.title).font(.title3).fontWeight(.semibold).multilineTextAlignment(.center)
                if(badge.earned && badge.dateEarned != nil){ Text(badge.dateEarned?.formatted(date: .long, time: .omitted) ?? "")
                }
            }.saturation(badge.earned ? 1 : 0).opacity(badge.earned ? 1 : 0.3)
            if(!badge.earned && showProgressIndicator){
                ProgressView(value: badge.progress).padding(.horizontal, 32)
            }
            
        }
    }
}

// MARK: COMPONENTS

extension ChallengesView{
    var heroSection: some View{
        VStack(alignment: .leading){
            if #available(iOS 16.1, *) {
                Text("gear up for some".lowercased()).fontDesign(.rounded)
            } else {
                // Fallback on earlier versions
                Text("gear up for some".lowercased())
            }
            Text("challenges").bold().font(.title)
        }.frame(maxWidth: .infinity, alignment: .leading).padding(.vertical)
    }
    
    var selectedBadgePage: some View{
        VStack{
            Image(systemName: "chevron.left").padding().onTapGesture {
                selectedBadge = nil
                isInternallyNavigated = false
            }.frame(maxWidth: .infinity, alignment: .leading)
            Spacer()
            BadgeView(badge: selectedBadge!, showProgressIndicator: false).scaleEffect(x:1.5, y:1.5).frame(width: 280, height: 280)
            Text(selectedBadge!.getCompleteDescription()).multilineTextAlignment(.center).padding(.top, 4)
            if(!selectedBadge!.earned){ ProgressView(value: selectedBadge!.progress).padding()
                Button(action: {
                    showAlertDialog = true
                }, label:{
                    Text("Log Progress")
                })
            }
            Spacer()
        }
        .padding()
    }
}
