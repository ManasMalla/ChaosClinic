import SwiftUI
import ContactsUI
import AuthenticationServices // NEW

struct OnboardingPage: View {
    let geometrySize: CGSize
    let title: String
    let subtitle: String
    let image: String
    let content: String
    var body: some View {
        VStack{
            VStack(alignment: .leading){
//                Image("manasmalla").resizable().aspectRatio(contentMode: .fit).frame(width: .infinity, height: .infinity, alignment: .center)
                Text(title).font(.title2).fontDesign(.serif).bold()
                Text(subtitle).font(.headline).bold().padding(.bottom, 12)
                Text(content).font(.system(size: 14)).lineHeight(.loose).opacity(0.8).fontWeight(.regular)
            }.padding().frame(height: geometrySize.height - 90, alignment: .bottom)

            Button{

            } label: {
                Text("Next").font(.subheadline).bold().padding().padding(.bottom, 24).frame(width: geometrySize.width, height: 90)
            }.foregroundStyle(.white).background(.regularMaterial)
        }
    }
}

struct OnboardingScreen: View{
    @Environment(\.colorScheme) var colorScheme
    @AppStorage("is-user-onboarded") var onboardingCompleted: Bool = false
    @AppStorage("coping-up-style") var copingUpStyle: String = ""
    @AppStorage("trusted-contact") var trustedContact: String = ""
    @AppStorage("trusted-contact-name") var trustedContactName: String = ""
    @AppStorage("user-name") var username: String = ""
    @AppStorage("trusted-contact-phone") var trustedContactPhone: String = ""
    @AppStorage("apple-user-id") var appleUserID: String = "" // NEW: store Apple user ID to track sign in state
    @State var showError = false
    @State private var showContactPicker = false
    @State private var appleSignInDelegate = AppleSignInCoordinator() // NEW
    @State private var prefilledName: String = "" // NEW: prefilled username for onboarding from Apple login
    var onOnboardingComplete: ()->Void = {}
    @State var navigateToRegistration = false

    private let people: [String] = ["Mother", "Father", "Friend", "Partner", "Other"]

    var body: some View{
        NavigationStack{
            NavigationLink(destination: onboardingAsGuestView, isActive: $navigateToRegistration) {
                               EmptyView()
                           }
            GeometryReader{ geometry in
                TabView{
                    OnboardingPage(geometrySize: geometry.size, title: "Reclaim your calm.", subtitle: "Tired of Overthinking?", image: "", content: "Chaos Clinic helps young adults like you quiet the noise of anxiety and overthinking. Gain control over your thoughts and emotions, finding peace and clarity when you need it most. Your journey to a calmer mind starts here.")
                    
                    OnboardingPage(geometrySize: geometry.size, title: "Your Private Path to Well-being.", subtitle: "Personalized Support, Securely Yours.", image: "", content: "Meet Kanha, your emotional AI assistant, offering kind, personalized guidance tailored just for you. All your interactions and data are processed securely on your device, ensuring your privacy is always protected. Connect with a supportive community to feel understood and less alone.")
                    
                    OnboardingPage(geometrySize: geometry.size, title: "Simple Steps, Lasting Impact.", subtitle: "Easy to Start, Powerful Results.", image: "", content: "Dive into engaging minigames and activities designed to shift your focus and build resilience. Track your emotional journey effortlessly, with future aspirations to securely integrate with Apple Health for a holistic view of your well-being.")
                    
                    VStack{
                        Rectangle().fill(.regularMaterial).frame(width: geometry.size.width, height: geometry.size.height - 302)
                        Divider().padding(.bottom, 20)
                        Text("Welcome to Chaos Clinic").font(.title).fontDesign(.serif)
                        Text("Choose an option to get started").font(.headline)
                        HStack{
                            NavigationLink{
                                onboardingAsGuestView
                            } label: {

                                    Text("Continue as Guest").font(.footnote).bold().padding().frame(width: geometry.size.width/2 - 24, height: 56).foregroundStyle(.white).background(ChaosClinicTheme.primary).clipShape(RoundedRectangle(cornerRadius: 12))

                            }
                            // REPLACED: Apple Sign in button with ASAuthorizationAppleIDButton wrapped in SwiftUI
                            ZStack{
                                SignInWithAppleButtonView(onRequest: { request in
                                    request.requestedScopes = [.fullName, .email]
                                }, onCompletion: { result in
                                    switch result {
                                    case .success(let authResults):
                                        if let appleIDCredential = authResults.credential as? ASAuthorizationAppleIDCredential {
                                            let userID = appleIDCredential.user
                                            let fullName = appleIDCredential.fullName
                                            appleUserID = userID // Save Apple user ID for later reference
                                            // NEW: Attempt login with Apple ID, if 404 then prefill onboarding with name
                                            loginWithAppleID(userID, fullName: fullName)
                                        }
                                    case .failure:
                                        break
                                    }
                                })
                                .clipShape(RoundedRectangle(cornerRadius: 12))
                            }.frame(width: geometry.size.width/2 - 24, height: 56)
                            
                        }

                    }

                }
            }
            .ignoresSafeArea(.container).tabViewStyle(.page(indexDisplayMode: .never))
        }
    }

    // NEW: MARK: - Networking and Login/Signup Logic

    /// Attempts to log in using Apple ID on the server.
    /// On success (200), sets onboardingCompleted and calls onOnboardingComplete if all user data fields are present and non-empty.
    /// If any required fields are missing, pre-fills onboarding with available data and lets user complete onboarding.
    /// On 404 (not found), pre-fills the onboarding guest flow with fullName and waits for user to complete onboarding, then triggers signup.
    /// Other errors ignored silently.
    func loginWithAppleID(_ userID: String, fullName: PersonNameComponents?) {
        guard let url = URL(string: "https://zwpdrng5-5001.inc1.devtunnels.ms/chaosclinic-hackathon/us-central1/api/login") else { return }
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        let body: [String: Any] = ["apple_id": userID]
        request.httpBody = try? JSONSerialization.data(withJSONObject: body)
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")

        URLSession.shared.dataTask(with: request) { data, response, error in
            guard let httpResponse = response as? HTTPURLResponse else { return }
            if httpResponse.statusCode == 200, let data = data {
                // Parse response JSON (assumed to have user info)
                if let json = try? JSONSerialization.jsonObject(with: data) as? [String: Any] {
                    DispatchQueue.main.async {
                        // NEW: Update @AppStorage properties from returned JSON if present
                        if let name = json["user_name"] as? String { username = name }
                        if let copingStyle = json["coping_style"] as? String { copingUpStyle = copingStyle }
                        if let contact = json["trusted_contact"] as? String { trustedContact = contact }
                        if let contactName = json["trusted_contact_name"] as? String { trustedContactName = contactName }
                        if let contactPhone = json["trusted_contact_phone"] as? String { trustedContactPhone = contactPhone }

                        // Check if all required fields are present and non-empty
                        let allFieldsPresent = !username.isEmpty && !copingUpStyle.isEmpty && !trustedContact.isEmpty
                        let trustedNameNeeded = (copingUpStyle == "Talking with someone") && (trustedContact == "Partner" || trustedContact == "Other" || trustedContact == "Friend")
                        let trustedNamePresent = !trustedNameNeeded || !trustedContactName.isEmpty

                        if allFieldsPresent && trustedNamePresent {
                            // All data complete, mark onboarding complete and proceed
                            onboardingCompleted = true
                            onOnboardingComplete()
                        } else {
                            // Some data missing: pre-fill onboarding and let user complete
                            prefilledName = username
                            onboardingCompleted = false
                        }
                    }
                }
            } else if httpResponse.statusCode == 404 {
                // User not found => prefill guest onboarding with fullName and wait for onboarding to complete
                DispatchQueue.main.async {
                    if let fullName = fullName, let givenName = fullName.givenName {
                        prefilledName = givenName
                        username = givenName // Pre-fill username field in onboarding
                    }
                    // Show onboarding screen for guest to finish signup
                    onboardingCompleted = false
                    navigateToRegistration.toggle()
                }
            } else {
                // Other errors ignored for now
            }
        }.resume()
    }

    /// Called after guest onboarding completes for Apple ID users.
    /// Sends signup data to backend.
    /// On success (201), updates user data and marks onboarding as complete.
    func signupWithAppleID(_ userID: String, fullName: PersonNameComponents?) {
        guard let url = URL(string: "https://zwpdrng5-5001.inc1.devtunnels.ms/chaosclinic-hackathon/us-central1/api/signup") else { return }
        var request = URLRequest(url: url)
        request.httpMethod = "POST"

        // Prepare fullName dictionary from PersonNameComponents
        var fullNameDict: [String: String] = [:]
        if let name = fullName {
            if let given = name.givenName { fullNameDict["givenName"] = given }
            if let family = name.familyName { fullNameDict["familyName"] = family }
            if let middle = name.middleName { fullNameDict["middleName"] = middle }
            if let nickname = name.nickname { fullNameDict["nickname"] = nickname }
            if let prefix = name.namePrefix { fullNameDict["namePrefix"] = prefix }
            if let suffix = name.nameSuffix { fullNameDict["nameSuffix"] = suffix }
        }

        let payload: [String: Any] = [
            "apple_id": userID,
            "username": username,
            "coping_style": copingUpStyle,
            "trusted_contact": trustedContact,
            "trusted_contact_name": trustedContactName,
            "trusted_contact_phone": trustedContactPhone,
            "full_name_components": fullNameDict
        ]
        request.httpBody = try? JSONSerialization.data(withJSONObject: payload)
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")

        URLSession.shared.dataTask(with: request) { data, response, error in
            guard let httpResponse = response as? HTTPURLResponse else { return }
            if httpResponse.statusCode == 201 {
                // Signup successful
                if let data = data,
                   let json = try? JSONSerialization.jsonObject(with: data) as? [String: Any] {
                    DispatchQueue.main.async {
                        // Update @AppStorage properties if returned from signup
                        if let name = json["user_name"] as? String { username = name }
                        if let copingStyle = json["coping_style"] as? String { copingUpStyle = copingStyle }
                        if let contact = json["trusted_contact"] as? String { trustedContact = contact }
                        if let contactName = json["trusted_contact_name"] as? String { trustedContactName = contactName }
                        if let contactPhone = json["trusted_contact_phone"] as? String { trustedContactPhone = contactPhone }

                        onboardingCompleted = true
                        onOnboardingComplete()
                    }
                } else {
                    DispatchQueue.main.async {
                        // If no user data returned, still mark onboarding as complete
                        onboardingCompleted = true
                        onOnboardingComplete()
                    }
                }
            } else {
                // Handle signup error if needed
                print(error)
                print(response)
            }
        }.resume()
    }
}

#Preview {
    OnboardingScreen()
}

// MARK: COMPONENTS

extension OnboardingScreen{

    var onboardingAsGuestView: some View{
        ScrollView{
            VStack{
                heroSection
                VStack(alignment: .leading){
                    Text("Help us know you better?").font(.title2).fontWeight(.semibold).padding(.top)
                    nameSection
                    copingUpForm
                    // Show trusted contact sections only if coping style is "Talking with someone"
                    if copingUpStyle == "Talking with someone" {
                        trustedContactSection
                        if(trustedContact == "Partner" || trustedContact == "Other" || trustedContact == "Friend"){
                            trustedContactNameSection
                        }
                    }
                    Button(action: {
                        // Validation check with added prefillName condition
                        if(username == "" || copingUpStyle == "" || (copingUpStyle == "Talking with someone" ? (trustedContact == "" || (trustedContact == "Partner" || trustedContact == "Other" || trustedContact == "Friend" ) && trustedContactName == "") : false)){
                            showError.toggle()
                        }else{
                            // NEW: If user logged in via Apple but onboarding was incomplete, call signupWithAppleID here
                            if !appleUserID.isEmpty && !onboardingCompleted {
                                // Gather fullName from prefilledName if possible (personNameComponents not kept here, so pass nil)
                                // Signup will update onboardingCompleted and trigger onOnboardingComplete after success
                                signupWithAppleID(appleUserID, fullName: nil)
                            } else if onboardingCompleted == false {
                                // If just a guest onboarding without Apple sign in, mark onboarding completed here
                                onboardingCompleted = true
                                onOnboardingComplete()
                            }
                            // Note: Do NOT toggle onboardingCompleted here redundantly if signupWithAppleID is called
                        }
                    }, label: {
                        Text("Get started").bold()
                    }).padding(.vertical, 14).padding(.horizontal, 32).background(Color.accentColor).foregroundStyle(.white).clipShape(RoundedRectangle(cornerRadius: 48)).frame(maxWidth: .infinity, alignment: .center).padding(.top)
                }.padding()
            }
        }
        // Sheet to pick a contact, returns both name and phone
        .sheet(isPresented: $showContactPicker) {
            ContactPicker { name, phone in
                trustedContactName = name
                trustedContactPhone = phone
                showContactPicker = false
            }
        }
        .ignoresSafeArea(.container)
        .alert(isPresented: $showError) {
            Alert(title: Text("You have missed filling a field"), message: Text("Kindly fill up the entire form before getting started. It helps us personalize the app exeperince just for you. \(NSUserName())"))
        }
        .onAppear {
            // NEW: If prefilledName is set, sync username
            if !prefilledName.isEmpty {
                username = prefilledName
            }
        }
    }

    //Hero section of the onboarding page
    var heroSection: some View{
        VStack(alignment: .leading){
            ChaosClinicLogo(colorScheme: .dark, maxHeight: 54).padding(.top, 48)
            Spacer()
            Image("group-hero").resizable().scaledToFit().frame(maxWidth: .infinity, maxHeight: 130, alignment: .trailing)
        }.padding(.top).padding(.leading).frame(maxWidth: .infinity,minHeight: 320, maxHeight: .infinity, alignment: .leading).background(ChaosClinicTheme.primary)
            .clipShape(
                UnevenRoundedRectangle(cornerRadii: .init(bottomLeading: 120))
            )
    }

    // Form section to input users trusted contact
    var nameSection: some View{
        VStack(alignment: .leading){
            Text("What do people call you?").font(.system(.body, design: .rounded)).padding(.vertical, 8)
            TextField(text: $username, label: {
                Text("Name").font(.system(.body, design: .rounded))
            }).textContentType(.name).padding().overlay(RoundedRectangle(cornerRadius: 16).stroke()).padding(.bottom)
        }
    }

    var trustedContactNameSection: some View{
        VStack(alignment: .leading){
            Text("Name of the \(trustedContact == "Partner" ? "spouse" : trustedContact == "Friend" ? "friend":  "person")").font(.system(.body, design: .rounded)).padding(.vertical)
            TextField(text: $trustedContactName, label: {
                Text("Name").font(.system(.body, design: .rounded))
            }).padding().overlay(RoundedRectangle(cornerRadius: 16).stroke()).padding(.bottom)
        }
    }

    // Form section to enquire user coping methods
    var copingUpForm: some View{
        VStack(alignment: .leading){
            Text("How do you usually cope up with overthinking?").font(.system(.body, design: .rounded)).padding(.bottom, 12)
            HStack(spacing: 0){
                Button(action: {
                    copingUpStyle = "Talking with someone"
                }, label: {
                    Text("Talking with someone").font(.system(.subheadline, design: .rounded)).lineLimit(1)
                }).buttonStyle(.plain).padding().frame(maxWidth: .infinity).padding(.vertical, copingUpStyle == "Talking with someone" ? 1 : 0).foregroundStyle(copingUpStyle == "Talking with someone" ? Color.white : .primary).background(copingUpStyle == "Talking with someone" ? AnyView(UnevenRoundedRectangle(cornerRadii: .init(topLeading: 12, bottomLeading: 12, bottomTrailing: 0, topTrailing: 0)
                                                                                                                                                                                                                                                                                                                     ).fill(ChaosClinicTheme.primary)) :AnyView(
                                                                                                                                                                                                                                                                                                                        UnevenRoundedRectangle(cornerRadii: .init(topLeading: 12, bottomLeading: 12, bottomTrailing: 0, topTrailing: 0)
                                                                                                                                                                                                                                                                                                                                              ).stroke()))
                Button(action: {
                    copingUpStyle = "Distracting yourself"
                }, label: {
                    Text("Distracting yourself").font(.system(.subheadline, design: .rounded))
                }).buttonStyle(.plain).padding().frame(maxWidth: .infinity).padding(.vertical, copingUpStyle == "Distracting yourself" ? 1 : 0).foregroundStyle(copingUpStyle == "Distracting yourself" ? Color.white : .primary).background(copingUpStyle == "Distracting yourself" ? AnyView(UnevenRoundedRectangle(cornerRadii: .init(topLeading: 0, bottomLeading: 0, bottomTrailing: 12, topTrailing: 12)
                                                                                                                                                                                                                                                                                                                     ).fill(ChaosClinicTheme.primary)) :AnyView(
                                                                                                                                                                                                                                                                                                                        UnevenRoundedRectangle(cornerRadii: .init(topLeading: 0, bottomLeading: 0, bottomTrailing: 12, topTrailing: 12)
                                                                                                                                                                                                                                                                                                                                              ).stroke()))
            }
        }
    }

    // Form section to input users trusted contact
    var trustedContactSection: some View{
        VStack(alignment: .leading){
            Text("Who do you trust to share everything with?").font(.system(.body, design: .rounded)).padding(.vertical)
            FlexibleView(data: people, spacing: 8, alignment: .leading){
                person in
                Button(action: {
                    trustedContact = person
                    if copingUpStyle == "Talking with someone" {
                        showContactPicker = true
                    }
                }, label: {
                    HStack(spacing: 8){
                        if(trustedContact == person){
                            Image(systemName: "checkmark.circle")
                        }
                        Text(person).font(.system(.body, design: .rounded))
                    }.padding(.horizontal, 16).padding(.vertical, 8)
                }).buttonStyle(.plain).foregroundStyle(trustedContact == person ? Color.white : .primary).background( trustedContact == person ? AnyView(Capsule().fill( ChaosClinicTheme.primary)) : AnyView(Capsule().fill(.fill)))

            }
            // Display both saved trusted contact's name and phone if available
            if !trustedContactPhone.isEmpty && !trustedContactName.isEmpty {
                Text("Saved contact: \(trustedContactName) (\(trustedContactPhone))").font(.footnote).foregroundColor(.secondary)
            }
        }
    }
}

// NEW: Wrapper for ASAuthorizationAppleIDButton to use in SwiftUI
struct SignInWithAppleButtonView: UIViewRepresentable {
    var onRequest: (ASAuthorizationAppleIDRequest) -> Void
    var onCompletion: (Result<ASAuthorization, Error>) -> Void

    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    func makeUIView(context: Context) -> ASAuthorizationAppleIDButton {
        let button = ASAuthorizationAppleIDButton(type: .signIn, style: .white)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(context.coordinator, action: #selector(Coordinator.didTapButton), for: .touchUpInside)
        return button
    }

    func updateUIView(_ uiView: ASAuthorizationAppleIDButton, context: Context) {

    }

    class Coordinator: NSObject, ASAuthorizationControllerDelegate, ASAuthorizationControllerPresentationContextProviding {
        let parent: SignInWithAppleButtonView

        init(_ parent: SignInWithAppleButtonView) {
            self.parent = parent
        }

        @objc func didTapButton() {
            let request = ASAuthorizationAppleIDProvider().createRequest()
            parent.onRequest(request)
            let controller = ASAuthorizationController(authorizationRequests: [request])
            controller.delegate = self
            controller.presentationContextProvider = self
            controller.performRequests()
        }

        func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
            parent.onCompletion(.success(authorization))
        }

        func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
            parent.onCompletion(.failure(error))
        }

        func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
            // Return key window
            return UIApplication.shared.windows.first { $0.isKeyWindow } ?? ASPresentationAnchor()
        }
    }
}

// NEW: Apple Sign In Coordinator for delegate handling (not used directly due to inline implementation, but kept per instructions)
private class AppleSignInCoordinator: NSObject, ASAuthorizationControllerDelegate, ASAuthorizationControllerPresentationContextProviding {
    func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
        if let appleIDCredential = authorization.credential as? ASAuthorizationAppleIDCredential {
            DispatchQueue.main.async {
                // Normally, you'd notify your view model or update app state here
                // This is handled inline in SignInWithAppleButtonView coordinator
            }
        }
    }

    func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
        // Handle error if needed
    }

    func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
        return UIApplication.shared.windows.first { $0.isKeyWindow } ?? ASPresentationAnchor()
    }
}

