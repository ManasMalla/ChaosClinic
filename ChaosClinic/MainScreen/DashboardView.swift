//
//  SwiftUIView.swift
//  Chaos Clinic
//
//  Created by Manas Malla on 15/07/25.
//

import SwiftUI
import HealthKit
import UIKit // Import UIKit for UIApplication.shared

struct DashboardView: View {
    
    @Environment(\.colorScheme) var environmentColorScheme
    
    @State var hasRequestedHealthData = false
    @State var showAlertDialog = false
    @AppStorage("last-emotion-logged") var lastEmotionLogged = "Unknown"
    @AppStorage("last-emotion-logged-time") var lastEmotionLoggedTime = Date().timeIntervalSinceReferenceDate - 400
    
    // Added trusted contact phone number storage
    @AppStorage("trusted-contact-phone") var trustedContactPhone: String = ""
    
    @State private var healthStore: HKHealthStore? = nil
    @Binding var userScore: Int
    @Binding var showProfileSheet: Bool
    
    private let stateOfMindLabels: [String:Emotion] = ["Happy 😀": .Happy, "Sad 😔": .Sad,"Calm 😌": .Calm, "Angry 🤬": .Angry, "Anxious 😰": .Anxious,"Guilty 😬": .Guilty,"Excited 🤩": .Excited, "Stressed 😵‍💫": .Stressed, "Worried 😟": .Worried, "Lonely 🥺": .Lonely, "Frustrated 😤": .Frustrated]
    @AppStorage("user-name") private var username:String = "homo sapien"
    @AppStorage("trusted-contact") var trustedContact: String = ""
    @AppStorage("trusted-contact-name") var trustedContactName: String = ""
    @AppStorage("coping-up-style") var copingUpStyle: String = ""
    @State private var selectedStateOfMind: Emotion? = nil
    @Binding var tabViewSelection: AppTabState
    @State var showPrivacyErrorForContact = false
    
    let chaosCardsEmotionalLocale: [Emotion: [String: [String: String]]] = [
        .Happy : [
            "ChaosCard": [
                "title": "Something makes you happy.",
                "subtitle": "Share with Kanha about the source of your happiness.",
            ]
        ],
        .Excited : [
            "ChaosCard": [
                "title": "Mind sharing your excitement?",
                "subtitle": "Kanha is super curious and excited to know what’s making you so happy."
            ]
        ],
        .Sad : [
            "ChaosCard": [
                "title": "Oh, Kanha hears that you are sad.",
                "subtitle": "Do you want to share what's making you feel a little blue today?"
            ]
        ],
        .Calm : [
            "ChaosCard": [
                "title": "Enjoying a moment of peace?",
                "subtitle": "That's awesome! What do you want to do today?"
            ]
        ],
        .Angry : [
            "ChaosCard": [
                "title": "Just got more chaotic?",
                "subtitle": "Looks like you are in a bit of a pickle! I know you can get through this."
            ]
        ],
        .Anxious: [
            "ChaosCard": [
                "title": "Oh no! Things got difficult",
                "subtitle": "But are you willing to give up now? You are just getting started!"
            ]
        ],
        .Guilty: [
            "ChaosCard": [
                "title": "Uh oh, Kanha hears that you are guilty",
                "subtitle": "You can always ask for help, we are all here to support and lift you up!"
            ]
        ],
        .Stressed: [
            "ChaosCard": [
                "title": "Take a break, why are you running?",
                "subtitle": "Remember there's a ton to do, but make sure to enjoy the journey. What's your plans, you should go get ice cream!"
            ]
        ],
        .Worried: [
            "ChaosCard": [
                "title": "It's ok to be worried, says Kanha.",
                "subtitle": "Sometimes things are just too big for us and we want to make sure everything goes in its place, take it easy!"
            ]
        ],
        .Lonely: [
            "ChaosCard": [
                "title": "This place might be lonely.",
                "subtitle": "The thing is that everyone can feel it, even our best friends are fighting a thing of their own so do know you ain't alone, just open the door of your heart and say hiii. Wanna talk?"
            ]
        ],
        .Frustrated: [
            "ChaosCard": [
                "title": "Its really okay to be frustrated, and you are not the only one. It sucks man",
                "subtitle": "Sometimes, it's better to try and switch your head so there's something new to look for. Have fun, its all about having some fun."
            ]
        ],
        .Unknown: [
            "ChaosCard": [
                "title": "Chat with Kanha?",
                "subtitle": "Kanha is our emotional and emphatetic AI bot to help you cope up with your mood."
            ]
        ]
        
    ]
    
    let exercisesEmotionalLocale: [Emotion: [String: String]] = [
        .Happy: [
            "title": "Level up!",
            "subtitle": "Have a blast with these happy games and activities!"
        ],
        .Excited: [
            "title": "Woohoo!",
            "subtitle": "Keep that excitement rolling with these fun challenges."
        ],
        .Sad: [
            "title": "Here, cheer up",
            "subtitle": "It's going to be ok! Activities like these may help ease the soul."
        ],
        .Calm: [
            "title": "Feeling at Ease",
            "subtitle": "Some more suggestions from the app, just for you!"
        ],
        .Angry: [
            "title": "Cooldown, Mr. Grumpy",
            "subtitle": "These activities are here when things get out of hand, so let's try to get through these shall we?"
        ],
        .Anxious: [
            "title": "Put some of that creativity here.",
            "subtitle": "Take all the time you want because these might really help lift up those burden of thoughts!"
        ],
        .Guilty: [
            "title": "Being Guilty, huh?",
            "subtitle": "It's ok, let it go! With these easy games!"
        ],
        .Stressed: [
            "title": "Stressed out huh, why are you running?",
            "subtitle": "With these games you can cool those racing wheels in your mind, because they can take all the time you want!"
        ],
        .Worried: [
            "title": "Everything is a worry, I see",
            "subtitle": "Well I'm just here to try to make it all into smaller pieces so you don't feel that big!"
        ],
        .Lonely: [
            "title": "It's not that lonely over here, with me by your side",
            "subtitle": "Here these are activities that just requires you and me. A bit of me time with a bit of you time, so why is it us time? "
        ],
        .Frustrated: [
            "title": "You are frustrated",
            "subtitle": "Well why don't you just let that out! You can get that out with my help."
        ],
        .Unknown: [
            "title": "Exercises just for you.",
            "subtitle": "curated activities to help you be mindful."
        ]
    ]
    
    
    @State private var users: [CommunityUser] = [
        CommunityUser(username: "Kavya", avatar: "kavya", isFollowed: false),
        CommunityUser(username: "Manas", avatar: "manas", isFollowed: true),
        CommunityUser(username: "Swapna", avatar: "swapna", isFollowed: false),
        CommunityUser(username: "Varshita", avatar: "varshita", isFollowed: false),
        CommunityUser(username: "CurrentUser", avatar: "person.circle.fill", isFollowed: false)
    ]
    
    // Assume current user is "CurrentUser"
    private let currentUsername = "CurrentUser"
    
    var body: some View {

                SwipeContainer(mainView: {
                    mainFeed
                }, sideView: {
                    
                        MessagingView(users: $users, currentUsername: currentUsername)
                })
           
    }
    
    private func logEmotionToHealthKit(_ emotion: Emotion) {
        // Initialize if not already
        if healthStore == nil {
            healthStore = HKHealthStore()
        }
        guard let healthStore = healthStore else { return }
        let stateOfMindType = HKSampleType.stateOfMindType()
        let now = Date()
        let valenceValue: Double
        switch emotion.getPleasantness() {
        case let x where x > 0:
            valenceValue = 1.0
        case let x where x < 0:
            valenceValue = -1.0
        default:
            valenceValue = 0.0
        }
        let labels: [HKStateOfMind.Label]
        if let label = emotion.hkLabel {
            labels = [label]
        } else {
            labels = []
        }
        let sample = HKStateOfMind(date: now, kind: .momentaryEmotion, valence: valenceValue, labels: labels, associations: [.currentEvents])
        healthStore.requestAuthorization(toShare: [stateOfMindType], read: [stateOfMindType]) { success, error in
            if success {
                healthStore.save(sample) { success, error in
                    if !success {
                        print("Error saving state of mind: \(error?.localizedDescription ?? "Unknown error")")
                    }
                }
            } else {
                print("HealthKit authorization failed: \(error?.localizedDescription ?? "Unknown error")")
            }
        }
    }
}

// MARK: COMPONENTS

extension Date{
    var partOfDay: String{
        let hour = Calendar.current.component(.hour, from: Date())
        return hour < 12 ? "morning" : hour < 16 ? "afternoon" :  hour < 20 ? "evening" : "night"
    }
}


extension DashboardView {
    
    var mainFeed: some View{
        ScrollView{
            LazyVStack(alignment: .leading){
                appBar
                heroSection.onAppear{
                    if(Date().timeIntervalSinceReferenceDate - lastEmotionLoggedTime < 300){
                        selectedStateOfMind = lastEmotionLogged.emotion
                    }
                }
                if(Date().timeIntervalSinceReferenceDate - lastEmotionLoggedTime > 300){
                    stateOfMindSection
                }
                if(selectedStateOfMind != nil && selectedStateOfMind != .Unknown && copingUpStyle == "Talking with someone"){
                    ChaosCard(title: chaosCardsEmotionalLocale[selectedStateOfMind!]?["ChaosCard"]?["title"] ?? "Chat with Kanha?", subtitle: chaosCardsEmotionalLocale[selectedStateOfMind!]?["ChaosCard"]?["subtitle"] ?? "Kanha is our emotional and emphatetic AI bot to help you cope up with your mood.", image: selectedStateOfMind!.getPleasantness() > 0 ? "ai-bubble" : "ai-bubble-sad", isAIEnabled: true, color: ChaosClinicTheme.getColor(red: 102, green: 36, blue: 160, alpha: 1.0)).onTapGesture {
                        tabViewSelection = .ChatWithAi
                    }
                    if(selectedStateOfMind!.getPleasantness() < 0){
                        // Updated onTapGesture to attempt call if phone number exists, else show alert
                        ChaosCard(title: "Call \(trustedContact == "Partner" || trustedContact == "Other" || trustedContact == "Friend" ? (trustedContactName.split(separator: " ").first?.capitalized ?? trustedContactName.capitalized) : trustedContact.capitalized)?", subtitle: "It’s ok to share how you feel with \(trustedContact == "Partner" || trustedContact == "Other" || trustedContact == "Friend" ? (trustedContactName.split(separator: " ").first?.capitalized ?? trustedContactName.capitalized) : trustedContact.capitalized), they should have time for you, when you just can’t take in any more.", image: "worried-bubble", color: ChaosClinicTheme.orange).onTapGesture {
                            if !trustedContactPhone.isEmpty {
                                let filteredNumber = trustedContactPhone.filter { $0.isNumber }
                                if let url = URL(string: "tel://\(filteredNumber)"), UIApplication.shared.canOpenURL(url) {
                                    UIApplication.shared.open(url)
                                } else {
                                    // Could not open phone dialer, show alert
                                    showPrivacyErrorForContact = true
                                    showAlertDialog = true
                                }
                            } else {
                                // No phone number available, show alert
                                showPrivacyErrorForContact = true
                                showAlertDialog = true
                            }
                        }
                    }
                    
                }
                exercisesSection
                Spacer()
            }.padding().alert(isPresented: $showAlertDialog) {
                if(hasRequestedHealthData){
                    Alert(title: Text("HealthKit Not Available"), message: Text("App Playgrounds don't yet support the HealthKit capability. NOTE: THIS IS AN EXPERIMENTAL TEMPORARY WORKAROUND with App Storage."), dismissButton: .default(Text("OK"), action: {
                        showAlertDialog = false
                        hasRequestedHealthData = false
                        showPrivacyErrorForContact = false
                    }))
                }else{
                    Alert(title: Text("Contact Not Available"), message: Text("Due to privacy reasons of this submission, we couldn't request for the contact. You can dial this person manually using their contact."), dismissButton: .default(Text("OK"), action: {
                        showAlertDialog = false
                        hasRequestedHealthData = false
                        showPrivacyErrorForContact = false
                    }))
                }
            }
        }
    }
    
    var appBar: some View{
        HStack{
            ChaosClinicLogo(maxHeight: 54)
            Spacer()
            HStack{
                Text("\(userScore) pts").fontWeight(.semibold).padding(.trailing, 8)
//                Image(systemName: "person.fill").padding(8).background(ChaosClinicTheme.orange).clipShape(Circle())
            }.padding(.vertical, 8).padding(.leading, 24).padding(.trailing, 8).foregroundStyle(.white).background(ChaosClinicTheme.primary).clipShape(.capsule).padding(.trailing, 8).onTapGesture {
                showProfileSheet = true
            }
//            }.sheet(isPresented: $showProfileSheet) {
//                ProfileView(onLogout: {
//                    appState = .Splash
//                    showProfileSheet = false
//                })
//            }
        }
    }
    
    var heroSection: some View{
        VStack(alignment: .leading, spacing: 6){
            Text("Good \(Date().partOfDay), \(username.split(separator: " ").first ?? "homo")").font(.system(.title)).fontWeight(.bold).fontDesign(.serif).lineHeight(.normal)
        }.frame(maxWidth: .infinity, alignment: .leading)
    }
    
    var stateOfMindSection: some View{
        VStack(alignment: .leading){
            if(lastEmotionLogged != "Unknown"){
                Text("Are you still feeling \(lastEmotionLogged.lowercased()) right now?").fontWeight(.medium).font(.headline)
                Text("This will help us better suggest cool things to do.").font(.footnote)
                HStack{
                    Button(action: {
                        lastEmotionLogged = "Unknown"
                        selectedStateOfMind = .Unknown
                    }, label: {
                        Text("No").padding()
                    })
                    Button(action: {
                        selectedStateOfMind = lastEmotionLogged.emotion
                        lastEmotionLoggedTime = Date().timeIntervalSinceReferenceDate
                    }, label: {
                        Text("Yes").foregroundColor(fetchThemeBasedResource(colorScheme: environmentColorScheme, light: .white, dark: .black))
                    }).buttonStyle(.borderedProminent).buttonBorderShape(.capsule)
                }
            }else{
                Text("How are you feeling right now?").font(.headline).fontWeight(.medium)
                Text("This will help us better suggest cool things to do.").font(.footnote).foregroundStyle(.secondary).padding(.bottom, 12)
                FlexibleView(data: stateOfMindLabels.sorted{
                    return $0.value.getPleasantness() < $1.value.getPleasantness()
                }.map { $0.key }, spacing: 8, alignment: .leading){
                    stateOfMindLabel in
                    Button(action: {
                        withAnimation(.easeInOut){
                            selectedStateOfMind = stateOfMindLabels[stateOfMindLabel]
                            lastEmotionLogged = stateOfMindLabels[stateOfMindLabel]?.rawValue ?? "Unknown"
                            lastEmotionLoggedTime = Date().timeIntervalSinceReferenceDate
                            logEmotionToHealthKit(stateOfMindLabels[stateOfMindLabel] ?? .Unknown)
                            if(!HKHealthStore.isHealthDataAvailable()){
                                hasRequestedHealthData = true
                                showAlertDialog = true
                            }
                        }
                    }, label: {
                        Text(stateOfMindLabel.lowercased()).font(.system(size: 14)).padding(.vertical, 16).padding(.horizontal, 16)
                    }).foregroundStyle(fetchThemeBasedResource(colorScheme: environmentColorScheme, light: .black, dark: .white)).buttonStyle(.plain).background(Capsule().fill(.regularMaterial))
                }
            }
            Divider().padding(.top).padding(.bottom, 4)
        }.frame(maxWidth: .infinity, alignment: .leading)
    }
    var exercisesSection: some View{
        VStack(alignment: .leading){
            Text(exercisesEmotionalLocale[selectedStateOfMind ?? .Unknown]?["title"] ?? "Exercises just for you").font(.title2).bold().lineHeight(.normal)
            if #available(iOS 16.1, *) {
                Text(exercisesEmotionalLocale[selectedStateOfMind ?? .Unknown]?["subtitle"] ?? "curated activities to help you be mindful.").fontDesign(.rounded)
            } else {
                // Fallback on earlier versions
                Text(exercisesEmotionalLocale[selectedStateOfMind ?? .Unknown]?["subtitle"] ?? "curated activities to help you be mindful.")
            }
            VStack(alignment: .leading){
                Image("crossword").resizable().scaledToFill().clipShape(RoundedRectangle(cornerRadius: 10))
                Text("Crossword Crossover").font(.system(.title3)).bold()
                Text("Find the first five words you see from the crossword in 30s").font(.system(.body)).foregroundStyle(.secondary)
            }.onTapGesture(perform: {
                tabViewSelection = .CrosswordGame
            })
            Divider().padding(.bottom, 8)
            HStack{
                Image("detective-problem").resizable().scaledToFill().frame(width: 120, height: 72, alignment: .center).clipShape(RoundedRectangle(cornerRadius: 10))
                VStack(alignment: .leading){
                    Text("Detective Problem").font(.system(.title3)).bold().lineHeight(.normal)
                    Text("List out 5 issues you see around yourself in 45s").font(.system(.footnote)).foregroundStyle(.secondary)
                }
            }.onTapGesture(perform: {
                tabViewSelection = .DetectiveGame
            })
            Divider().padding(.vertical, 8)
            HStack{
                Image("bust-bug").resizable().scaledToFill().frame(width: 120, height: 72, alignment: .center).clipShape(RoundedRectangle(cornerRadius: 10))
                VStack(alignment: .leading){
                    Text("Bust the Bug").font(.system(.title3)).bold().lineHeight(.normal)
                    Text("Bust as many bugs as you can in 15s").font(.system(.footnote)).foregroundStyle(.secondary)
                }
            }.onTapGesture(perform: {
                tabViewSelection = .BustBugGame
            })
            Divider().padding(.vertical, 8)
            HStack{
                Image("mindful-meditation").resizable().scaledToFill().frame(width: 120, height: 72, alignment: .center).clipShape(RoundedRectangle(cornerRadius: 10))
                VStack(alignment: .leading){
                    Text("Mindful Meditation").bold().lineHeight(.normal)
                    Text("Focus your thoughts on the bubble for 20s").font(.system(.footnote)).foregroundStyle(.secondary)
                }
            }.onTapGesture(perform: {
                tabViewSelection = .MindfulMeditaton
            })
        }.padding(.bottom)
    }
}


#Preview {
    @Previewable @State var selection: AppTabState = .Dashboard
    @Previewable @State var userScore = 10
    @Previewable @State var showProfileSheet = false
    DashboardView(userScore: $userScore, showProfileSheet: $showProfileSheet, tabViewSelection: $selection)
}

struct ChaosCard: View{
    var title: String
    var subtitle: String
    var image: String
    var isAIEnabled = false
    var color: Color
    var foregroundColor: Color = .white
    var body: some View{
        HStack(alignment: .bottom){
            VStack(alignment: .leading, spacing: 0){
                Text(title).font(.title2).lineSpacing(0).fontWeight(.semibold).overlay(isAIEnabled ? Text("A.I.").font(.caption2).padding(.horizontal, 8).padding(.vertical, 4).background(RoundedRectangle(cornerRadius: 10).fill(.white.opacity(0.3))).offset(x: 48, y: 2).scaleEffect(0.7) : nil, alignment: .topTrailing)
                Text(subtitle).font(.system(size: 14)).padding(.top, 6)
            }.padding(.bottom, 20)
            Spacer()
            Image(image).resizable().scaledToFit().frame(maxWidth: 120)
        }.padding(.leading, 20).padding(.top, 20).foregroundStyle(foregroundColor).frame(maxWidth: .infinity).background(color).clipShape(RoundedRectangle(cornerRadius: 10))
    }
}

