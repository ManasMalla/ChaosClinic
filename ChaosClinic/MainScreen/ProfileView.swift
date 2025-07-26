//
//  SwiftUIView.swift
//  Chaos Clinic
//
//  Created by Manas Malla on 15/07/25.
//

import SwiftUI
import HealthKit
import HealthKitUI

struct ProfileView: View {
    
    @AppStorage("apple-health-authenticated") private var authenticated: Bool = false
    @State var hasRequestedHealthData: Bool = false
    @State var healthDataAccessRequestTrigger: Bool = false
    @AppStorage("should-show-apple-health-dialog") private var shouldShowAppleHealthAlert = true
    @State var showAppleHealthAlert = false
    @State var showCredits = false
    @AppStorage("user-name") private var userName = ""
    var onLogout: ()->Void = {}
    var body: some View {
            List{
                Section {
                    HStack {
                        Image("manasmalla").resizable().frame(width: 64, height: 64, alignment: .center)
                            .clipShape(Circle())
                        VStack(alignment: .leading, spacing: 0){
                            Text(userName.capitalized).font(.title2)
                            Text("\(userName.lowercased().replacingOccurrences(of: " ", with: ""))@chaosclinic.com").font(.subheadline)
                        }.padding()
                    }
                }
                HStack {
                    Text("View Health Trends")
                    
                    Spacer()
                    Image(systemName: "chevron.right").imageScale(.small).opacity(0.3)
                }.onTapGesture {
                    if(!shouldShowAppleHealthAlert){
                        guard let url = URL(string: "x-apple-health://MentalHealthAppPlugin.healthplugin") else {
                                return
                            }

                            if UIApplication.shared.canOpenURL(url) {
                                UIApplication.shared.open(url, options: [:])
                            }
                    }else{
                        shouldShowAppleHealthAlert = false
                        showAppleHealthAlert.toggle()
                    }
                }.alert(isPresented: $showAppleHealthAlert, content: {
                    Alert(title: Text("Better with Apple Health"), message: Text("We'll navigate you for the best experience at the Apple Health app, the central place to know all about your health. Tap the 'Show in charts' feature for a detailed report."), dismissButton: .default(Text("Take me there"), action: {
                        showAppleHealthAlert.toggle()
                        guard let url = URL(string: "x-apple-health://MentalHealthAppPlugin.healthplugin") else {
                                return
                            }

                            if UIApplication.shared.canOpenURL(url) {
                                UIApplication.shared.open(url, options: [:])
                            }
                    }))
                })
                HStack{
                    Text(authenticated ? "Authorized with Apple Health" : "Authorize with Apple Health")
                    Spacer()
                    Image(systemName: "chevron.right").imageScale(.small).opacity(0.3)
                }.onTapGesture {
                    if(authenticated){
                       return
                    }
                    if(HealthRepository.initializeHealthStore() && HealthRepository.healthStore != nil){
                        healthDataAccessRequestTrigger = true
                    }else{
                            hasRequestedHealthData = true
                    }
                }.alert(isPresented: $hasRequestedHealthData) {
                    Alert(title: Text("HealthKit Not Available"), message: Text("Your device doesn't yet support the HealthKit capability."))
                }.healthDataAccessRequest(store: HKHealthStore(), shareTypes: [HKSampleType.stateOfMindType()], readTypes: [
                    HKSampleType.stateOfMindType()
                ], trigger: healthDataAccessRequestTrigger, completion: { result in
                    switch result {
                                   
                               case .success(_):
                                   authenticated = true
                        healthDataAccessRequestTrigger.toggle()
                               case .failure(let error):
                                   // Handle the error here.
                                   fatalError("*** An error occurred while requesting authentication: \(error) ***")
                               }
                })
                Section{
                    HStack{
                        Text("Credits")
                        Spacer()
                        Image(systemName: "chevron.right").imageScale(.small).opacity(0.3)
                    }.onTapGesture {
                        showCredits = true
                    }.sheet(isPresented: $showCredits) {
                       CreditsView()
                    }
                }
                Section{
                    VStack(alignment: .leading){
                        Text("KIRAN").font(.title2).bold()
                        Text("a 24x7 toll free #MentalHealth rehabilitation helpline called #KIRAN and is available in 13 Indian languages.").font(.callout)
                        Text("1800-599-0019").padding(.top, 2).foregroundStyle(.blue)
                    }
                    VStack(alignment: .leading){
                        Text("Caution").font(.title2).bold()
                        Text("This app isn't a replacement for a therapist and we highly recommend seeking professional help if you are experiencing mental health issues.").font(.callout)
                    }
                }
                Section{
                    Button {
                        UserDefaults.standard.resetDefaults()
                        onLogout()
                    } label: {
                        Text("Sign out")
                    }

                }
            }
        }
}

struct CreditsView: View {
    var body: some View {
        NavigationStack{
            List{
                VStack(alignment: .leading){
                    Text("Swift").font(.headline)
                    Text("Apple").font(.subheadline)
                }
                VStack(alignment: .leading){
                    Text("BadgeBackground.swift").font(.headline)
                    Text("HexagonParameters.swift").font(.headline)
                    Text("Apple").font(.subheadline)
                    Text("\nCopyright © 2023 Apple Inc.\n\nPermission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the 'Software'), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:\n\nThe above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.\n\nTHE SOFTWARE IS PROVIDED 'AS IS', WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.").font(.caption2)
                }
                VStack(alignment: .leading){
                    Text("SizeReader.swift").font(.headline)
                    Text("FlexibleView.swift").font(.headline)
                    Text("_FlexibleView.swift").font(.headline)
                    Text("Federico Zanetello").font(.subheadline)
                    Text("\nCopyright (c) 2020, Federico Zanetello\n\nAll rights reserved.\n\nRedistribution and use in source and binary forms, with or without modification, are permitted provided that the following conditions are met:\n\nRedistributions of source code must retain the above copyright notice, this list of conditions and the following disclaimer.\nRedistributions in binary form must reproduce the above copyright notice, this list of conditions and the following disclaimer in the documentation and/or other materials provided with the distribution.\n\nNeither the name of Federico Zanetello nor the names of contributors may be used to endorse or promote products derived from this software without specific prior written permission.\n\nTHIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS 'AS IS' AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.").font(.caption2)
                }
            }.navigationTitle("Credits")
        }
    }
}

#Preview {
    ProfileView()
}

#Preview{
    CreditsView()
}

extension UserDefaults {
    func resetDefaults() {
        let dictionary = self.dictionaryRepresentation()
        dictionary.keys.forEach{ key in self.removeObject(forKey: key)
        }
    }
}
