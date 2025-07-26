import SwiftUI
import SwiftData
import Combine

@Model
final class DirectMessage: Identifiable {
    let id: UUID
    let fromUser: String
    let toUser: String
    let content: String
    let timestamp: Date
    init(fromUser: String, toUser: String, content: String) {
        self.id = UUID()
        self.fromUser = fromUser
        self.toUser = toUser
        self.content = content
        self.timestamp = Date()
    }
}

struct Story: Identifiable {
    let id = UUID()
    let username: String
    let image: String // Name or URL
    let timestamp: Date
    let content: String
}

struct CommunityUser: Identifiable, Hashable {
    let id = UUID()
    let username: String
    let avatar: String // name or URL
    var isFollowed: Bool
}

struct CommunityCenterView: View {
    
    @Binding var isInternalNavigated: Bool
    
    @State private var showNewArticleSheet = false
    
    @State private var articles: [Article] = [
        Article(title: "Hear how Kavya broke stereotypes with confidence and courage", duration: 8, image: "kavya", emotionalAttribute: "Courage", tags: ["Stereotype"], description: "An inspiring story on how a young adult overcame her struggle through her anxious thoughts reminiscing about her career.", content: [
            "Hey everyone, Kavya here! I'm in my 3rd year of B.Tech, and let me tell you, it's been a wild ride so far. I always knew I wanted to be in tech, but sometimes it felt like I didn't quite fit the \"mold.\" You know, the image of the stereotypical programmer who's been coding since they were 10 and lives and breathes algorithms? That was never me.",
            "For a long time, I let those thoughts define me, until I realized I don't have to be someone to someone, I just have to be *me*.",
            "Being a woman in tech, especially in a field that's still largely male-dominated, comes with its own set of pressures. I constantly felt like I had to prove myself, work twice as hard, and always be on top of my game. It was exhausting! Then the overthinking would kick in:\n\nAm I smart enough?\n\nDo I belong here?\n\nAm I ever going to be taken seriously?\n\nCan I really become a great software engineer with this skill set that i am having?\n\nThose thoughts would leave me paralyzed with fear.",
            "The turning point for me was realizing that success isn't about fitting into a mold or meeting someone else's expectations. It's about defining your own path, embracing your unique strengths, and pursuing what genuinely excites you. It's like playing a video game, but you define what victory is.",
            "These are different weapons I've made to make this world better.",
            "Embrace My Strengths: I realized that I didn't have to be a coding whiz to be valuable in tech. I was able to be more empathetic than some of the people with great technical skills, making me a great team worker and more importantly a team leader.",
            "Find My Tribe: Surrounding myself with other supportive and like-minded individuals made a world of difference. I also realized that everyone felt the same at some point of time, making me realize these pressures were there just for a very short time to pass. And to be the best, you need to fail at it.",
            "Challenge the Status Quo: I started speaking up and advocating for more diversity and inclusion in tech. I joined organizations that support women and underrepresented groups in STEM, and I used my voice to challenge stereotypes and promote equality.",
            "Knowing when to stop: Its just that my anxiety comes from my career but its not that serious that its making me really depressed or anything. I know my goals and everything, and my actions are always driven towards it. I know if I am going the right way or not, and even it is not, it is fine, because I will find something along the way. And I cannot keep going forever. We all need to switch to youtube at some point of time.",
            "My Takeaway: Breaking stereotypes and conquering career anxieties takes courage, confidence, and a willingness to embrace your unique self. Don't be afraid to challenge the status quo, find your tribe, and define success on your own terms. You've got this! ✨"
        ], imageURL: nil),
        Article(title: "Hear how Manas overpowered his overthinking with help from his friends", duration: 8, image: "manas", emotionalAttribute: "Anxious", tags: ["Social Interaction"], description: "An inspiring story on how a young adult overcame his struggle through his anxious thoughts reminiscing about his social interactions.", content: [
            "What's up, everyone? Manas here, trying to survive the chaos. Tech is hard, but honestly, sometimes my biggest challenges happen *outside* the code editor. I'm talking about social interactions, group chats, and that constant *what are they thinking about me* spiral.",
            "I was just the \"it\" guy at the wrong time.",
            "Anyone else get crazy anxious after sending a text? Like, you analyze every word, every emoji, and then spend the next hour refreshing your phone, waiting for a reply? That was me, times a million. My brain would go into overdrive:\n\nDid I say something wrong?\n\nAre they mad at me?\n\nDid I bore them to death with that story about the algorithm I was working on?\n\nAnd if someone didn't reply right away, forget about it! My brain would be like, \"Okay, they clearly hate you now. Time to pack your bags and move to a remote island.\" Okay that was a bit to far.",
            "That feeling when people change how they talk to you, probably due to their time crunching schedule.",
            "Thankfully, I have some amazing friends who helped me see the light, especially Kavya. Seriously, she deserves a medal for putting up with my overthinking tendencies. I had a friend named Kavya, it wasn't anything serious but she was a real help.",
            "Kavya taught me these following toolkits that actually made myself better!",
            "The \"It's Not Always About You\" Reminder: Kavya would constantly remind me that people have their own lives, their own problems, and their own schedules. If someone doesn't reply right away, it's probably not because they hate you, but because they're busy, tired, or maybe just forgot to charge their phone (we've all been there!).",
            "The Straight-Up Truth: One of the best things about Kavya is that she's not afraid to give me a reality check. If I was spiraling out of control, she'd be like, \"Manas, chill! You're being ridiculous. They probably just haven't seen your message yet.\" Sometimes, you need that dose of tough love. XD",
            "Embracing Imperfection: I learned to let go of the need to be perfect in every social interaction. It's okay to say the wrong thing sometimes, to be a little awkward, or to not have all the answers. People are much more forgiving than my brain makes them out to be.",
            "Reaffirming my Actions: Making me understand that my actions are driven towards helping improve myself. I was already on the right path!",
            "Overcoming social anxieties and overthinking is a process. I learned how to manage my thoughts. And, most importantly, is be true to myself!",
            "And with that all we know, always love what others do and do what you love 💖😃! Now let's keep on building cool and awesome applications! ✨"
        ], imageURL: nil),
        Article(title: "Swapna solves stress with ease", duration: 4, image: "swapna", emotionalAttribute: "Empowering", tags: ["Upskilling"], description: "A girl with dreams overcames her struggle through her anxious thoughts reminiscing about her career.", content: [
            "Hey everyone! I'm Swapna Dande, a recent grad and super excited to be a Women Techmakers Ambassador for Google Developer Groups Vizag! For a while, I thought that I had it easy, however my dreams were big, but the stress to succeed, even bigger.",
            "The \"easy\" life was never really easy. It was just all a facade. I had to come up with a way to feel, ok.",
            "I was also struggling for:\n\nImpostor syndrome\n\nWhere am I really going?\n\nAll the success stories in the Google Developer Groups were also becoming a negative form of encouragement for me. Until I was able to come across several things that I needed to keep going, I would often remind myself.",
            "Embrace Lifelong Learning: Tech is constantly evolving, so there’s always something new to learn! Upskilling wasn't just about building my resume, it was more about building myself. Having a broader set of tools allows me to think bigger, to not feel that only I'm the bottleneck in the world.",
            "Find Your Voice: Being a Women Techmakers Ambassador has given me a platform to share my knowledge and passion with others. Helping women be more in STEM, and use the skills, and connections Google has to offer! We really can do this together.",
            "Celebrate Small Wins: Don't get caught up in the big picture! I would literally note them down! Each success story allows me to pat myself on the back and say everything I have accomplished has lead to some better point. All of these small things were making me stronger and stronger.",
            "Takeaway: You're capable of amazing things, and the journey is just as important as the destination. Keep learning, keep connecting, and keep empowering yourself and others, and you'll find your own path to success. ✨",
            "Also, remember to smile on the go, its something really fun! 😃"
        ], imageURL: nil)
    ]
    
    @State var selectedArticle: Article? = nil
    
    let featuredArticle = FeaturedArticle(article: Article(title: "Tune into how Värshita conquered her overthinking career", duration: 4, image: "varshita", emotionalAttribute: "Anxious", tags: ["Career"], description: "An inspiring story on how a young adult overcame her struggle through her anxious thoughts reminiscing about her career.", content: [
        "Hey everyone! I'm Varshita, and like many of you, I'm a student trying to navigate the crazy world of tech. I'm currently in my 3rd year, and if I'm being honest, the pressure to \"succeed\" in my career has often felt overwhelming. That feeling of constantly needing to keep up to avoid career suicide. Impostor syndrome became my best friend.",
        "I soon learned this was only in my head.",
        "It wasn't pretty. I'd spend hours comparing myself to other students, worrying about internships, and panicking about the future. It was exhausting, and it started to affect my studies, my relationships, and my overall well-being. I'd catch myself thinking:\n\nAm I good enough?\n\nAm I ready for what is to come?\n\nThe mind could always come up with something I wasn't. I became a perfectionist with my grades, since if it slipped it meant my death. All the fun and freedom I had were gone. I decided I've had enough.",
        "Then a small spark of recognition came by, which made me know I'm not crazy, that everyone goes through what I'm going through, and everyone has a unique way to managing it. There were a lot of different ways I found, but the best was doing art!",
        "Art gave me a way to express those hard emotions.",
        "I learned different toolkits to make myself understand the mind that is causing me pain.",
        "Mindfulness Moments: I started practicing mindfulness, even if it was just for a few minutes each day. Focusing on my breath or the sensations in my body helped me ground myself in the present moment and quiet the mental chatter.",
        "Cognitive Reframing: Whenever I noticed myself having negative thoughts, I challenged them. I asked myself, \"Is this thought really true? Is there another way to look at this situation?\"",
        "Seeking Support: I had to reach out to friends and a professional for help. Talking to others who understood what I was going through made me feel less alone.",
        "The big challenge was the negative talk, but it soon came to an end!",
        "Conquering career overthink is a journey, not a destination. There will be good days and bad days, but the important thing is to keep moving forward. Be kind to yourself, celebrate your successes, and don't be afraid to ask for help when you need it. 💖",
        "You can do it! 😄"
    ], imageURL: nil))
    
    @State private var stories: [Story] = [
        Story(username: "Kavya", image: "https://github.com/manasmalla.png", timestamp: .now, content: "Hello")
    ]
    @State private var selectedStory: Story? = nil
    @State private var showNewStorySheet = false
    
    @State private var users: [CommunityUser] = [
        CommunityUser(username: "Kavya", avatar: "kavya", isFollowed: false),
        CommunityUser(username: "Manas", avatar: "manas", isFollowed: true),
        CommunityUser(username: "Swapna", avatar: "swapna", isFollowed: false),
        CommunityUser(username: "Varshita", avatar: "varshita", isFollowed: false),
        CommunityUser(username: "CurrentUser", avatar: "manasmalla", isFollowed: false)
    ]
    
    // Assume current user is "CurrentUser"
    private let currentUsername = "CurrentUser"
    
    // Added for messaging UI
    @State private var showMessagingView = false
    
    var body: some View {
        if(selectedArticle != nil){
            VStack{
                HStack {
                    Image(systemName: "chevron.left").padding().onTapGesture {
                        selectedArticle = nil
                        isInternalNavigated = false
                    }
                    Spacer()
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding()
                
                ScrollView{
                    LazyVStack(spacing: 16){
                        
                        FeaturedArticleView(article: selectedArticle!, horizontalAlignment: .center)
                        if let authorUser = users.first(where: { $0.username == selectedArticle!.titleAuthorName }) {
                            AuthorHeaderView(user: authorUser, currentUsername: currentUsername, followAction: toggleFollow)
                        }
                        ForEach(selectedArticle?.content ?? [], id: \.self){ para in
                            Text(para)
                                .frame(maxWidth: .infinity, alignment: .leading)
                        }.padding(.top)
                    }.padding()
                }
            }
        }else if(selectedStory != nil){
            VStack{
                HStack {
                    Button(action: {
                        selectedStory = nil
                    }) {
                        Image(systemName: "chevron.left").padding()
                    }
                    Spacer()
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding()
                
                ScrollView{
                    LazyVStack(spacing: 16){
                        if let authorUser = users.first(where: { $0.username == selectedStory!.username }) {
                            AuthorHeaderView(user: authorUser, currentUsername: currentUsername, followAction: toggleFollow)
                        }
                        StoryContentView(story: selectedStory!)
                    }
                    .padding()
                }
            }
        } else {
            ScrollView{
                VStack{
                    // Stories horizontal scroll
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 16) {
                            Button(action: {
                                showNewStorySheet = true
                            }) {
                                
                                    VStack(spacing: 8) {
                                        Image(users.first(where: {
                                            $0.username == currentUsername
                                        })?.avatar ?? "manas")
                                                .resizable()
                                                .scaledToFill()
                                                .clipShape(Circle()).padding(5)
                                                .frame(width: 64, height: 64).overlay(alignment: .bottomTrailing){
                                                    ZStack {
                                                        Circle()
                                                            .fill(Color.accentColor)
                                                            .frame(width: 24, height: 24)
                                                        Image(systemName: "plus")
                                                            .font(.system(size: 14, weight: .bold))
                                                            .foregroundColor(Color.white)
                                                    }
                                                }
                                        Text("Add Story")
                                            .font(.caption2)
                                            .foregroundColor(.primary)
                                            .lineLimit(1)
                                    }
                                }
                            
                            ForEach(stories) { story in
                                VStack(spacing: 8) {
                                    Button(action: {
                                        selectedStory = story
                                    }) {
                                        Image(users.first(where: {
                                            story.username == $0.username
                                        })?.avatar ?? "manas")
                                                .resizable()
                                                .scaledToFill()
                                                .clipShape(Circle()).padding(5).overlay{
                                                    Circle().stroke(style: StrokeStyle(lineWidth: 2)).foregroundStyle(ChaosClinicTheme.primary)
                                                }
                                                .frame(width: 64, height: 64)
                                    }
                                    .buttonStyle(PlainButtonStyle())
                                    Text(story.username)
                                        .font(.caption2)
                                        .lineLimit(1)
                                        .frame(width: 64)
                                        .foregroundColor(.primary)
                                }
                            }
                        }
                        .padding(.horizontal)
                        .padding(.vertical, 8)
                    }
                    
                    // Users horizontal scroll - Community section
                    //                ScrollView(.horizontal, showsIndicators: false) {
                    //                    HStack(spacing: 16) {
                    //                        ForEach(users.filter { $0.username != currentUsername }) { user in
                    //                            VStack(spacing: 8) {
                    //                                if user.avatar.starts(with: "http") || user.avatar.starts(with: "https") {
                    //                                    AsyncImage(url: URL(string: user.avatar)) { phase in
                    //                                        switch phase {
                    //                                        case .empty:
                    //                                            Circle()
                    //                                                .fill(Color.gray.opacity(0.3))
                    //                                                .frame(width: 64, height: 64)
                    //                                        case .success(let image):
                    //                                            image.resizable().scaledToFill()
                    //                                                .frame(width: 64, height: 64)
                    //                                                .clipShape(Circle())
                    //                                        case .failure:
                    //                                            Circle()
                    //                                                .fill(Color.red.opacity(0.3))
                    //                                                .frame(width: 64, height: 64)
                    //                                        @unknown default:
                    //                                            Circle()
                    //                                                .fill(Color.gray.opacity(0.3))
                    //                                                .frame(width: 64, height: 64)
                    //                                        }
                    //                                    }
                    //                                } else {
                    //                                    Image(user.avatar)
                    //                                        .resizable()
                    //                                        .scaledToFill()
                    //                                        .frame(width: 64, height: 64)
                    //                                        .clipShape(Circle())
                    //                                }
                    //                                Text(user.username)
                    //                                    .font(.caption2)
                    //                                    .lineLimit(1)
                    //                                    .frame(width: 64)
                    //                                    .foregroundColor(.primary)
                    //                                Button(action: {
                    //                                    toggleFollow(user: user)
                    //                                }) {
                    //                                    Text(user.isFollowed ? "Following" : "Follow")
                    //                                        .font(.caption2)
                    //                                        .fontWeight(.medium)
                    //                                        .padding(.horizontal, 10)
                    //                                        .padding(.vertical, 4)
                    //                                        .background(user.isFollowed ? Color.accentColor.opacity(0.8) : Color.gray.opacity(0.3))
                    //                                        .foregroundColor(user.isFollowed ? .white : .primary)
                    //                                        .cornerRadius(12)
                    //                                }
                    //                                .buttonStyle(PlainButtonStyle())
                    //                            }
                    //                            .frame(width: 80)
                    //                        }
                    //                    }
                    //                    .padding(.horizontal)
                    //                    .padding(.vertical, 8)
                    //                }
                    
                    //                Button("Write a New Article") {
                    //                    showNewArticleSheet = true
                    //                }
                    //                .padding(.horizontal)
                    //                .padding(.top, 8)
                    
                    LazyVStack{
                        heroSection
                        featuredArticleSection.onTapGesture {
                            selectedArticle = featuredArticle.article
                            isInternalNavigated = true
                        }
                        Divider().padding(.vertical, 12)
                        articlesSection
                    }.padding()
                }
            }
            .sheet(isPresented: $showNewArticleSheet) {
                NewArticleSheet { newArticle in
                    articles.append(newArticle)
                    showNewArticleSheet = false
                } onCancel: {
                    showNewArticleSheet = false
                }
            }
            .sheet(isPresented: $showNewStorySheet) {
                NewStorySheet { newStory in
                    stories.append(newStory)
                    showNewStorySheet = false
                } onCancel: {
                    showNewStorySheet = false
                }
            }
            .fullScreenCover(item: $selectedStory) { story in
                StoryFullScreenView(story: story) {
                    selectedStory = nil
                }
            }
        }
        
    }
    
    func toggleFollow(user: CommunityUser) {
        guard let index = users.firstIndex(where: { $0.id == user.id }) else { return }
        users[index].isFollowed.toggle()
    }
}



// MARK: Structs

struct Article: Identifiable, Hashable {
    var id = UUID()
    var title: String
    var duration: Int
    var image: String
    var emotionalAttribute: String
    var tags: [String]
    var description: String
    var content: [String]
    var imageURL: URL? = nil
    
    // Added property for author username (matching CommunityUser.username)
    var titleAuthorName: String {
        switch title {
        case let t where t.contains("Kavya"): return "Kavya"
        case let t where t.contains("Manas"): return "Manas"
        case let t where t.contains("Swapna"): return "Swapna"
        case let t where t.contains("Värshita") || t.contains("Varshita"): return "Varshita"
        default: return ""
        }
    }
}

struct FeaturedArticle{
    var article: Article
}

// MARK: COMPONENTS

extension CommunityCenterView{
    var heroSection: some View{
        VStack(alignment: .leading){
            if #available(iOS 16.1, *) {
                Text("hear out. be inspired.".lowercased()).fontDesign(.rounded).lineHeight(.normal)
            } else {
                // Fallback on earlier versions
                
                Text("hear out. be inspired.".lowercased()).lineHeight(.normal)
            }
            Text("community center").bold().font(.title)
        }.frame(maxWidth: .infinity, alignment: .leading).padding(.bottom)
    }
    var featuredArticleSection: some View{
        FeaturedArticleView(article: featuredArticle.article)
    }
    var articlesSection: some View{
        ForEach(articles) { article in
            VStack{
                ArticleView(article: article).onTapGesture {
                    selectedArticle = article
                    isInternalNavigated = true
                }
                Divider().padding(.vertical, 12)
            }
        }
    }
}

struct FeaturedArticleView: View{
    
    var article: Article
    var horizontalAlignment: HorizontalAlignment = .leading
    
    var body: some View{
        VStack(alignment: horizontalAlignment, spacing: 0){
            if let imageURL = article.imageURL {
                AsyncImage(url: imageURL) { phase in
                    switch phase {
                    case .empty:
                        Color.gray.opacity(0.3)
                    case .success(let image):
                        image.resizable().scaledToFit()
                    case .failure:
                        Color.red.opacity(0.3)
                    @unknown default:
                        Color.gray.opacity(0.3)
                    }
                }
                .frame(maxWidth: .infinity)
                .clipShape(RoundedRectangle(cornerRadius: 24))
            } else {
                Image(article.image).resizable().scaledToFit().frame(maxWidth: .infinity).clipShape(RoundedRectangle(cornerRadius: 24))
            }
            Text(article.title).font(horizontalAlignment == .center ? .title : .title2).fontDesign(horizontalAlignment == .center ? .serif : .default).bold().lineHeight(.loose).padding(.top, 12).padding(.bottom,3).multilineTextAlignment(horizontalAlignment == .center ? .center : .leading)
            Text("\(article.duration)\(article.duration > 1 ? "mins" : "min") • \(article.emotionalAttribute) • \(article.tags.joined(separator: ", "))").font(.system(size: 16)).fontWeight(.medium).padding(.bottom, 6)
            Text(article.description).font(.system(size: 14)).opacity(0.6).multilineTextAlignment(horizontalAlignment == .center ? .center : .leading)
        }
    }
}

struct ArticleView: View{
    
    var article: Article
    
    var body: some View{
        HStack(alignment: .top, spacing: 0){
            if let imageURL = article.imageURL {
                AsyncImage(url: imageURL) { phase in
                    switch phase {
                    case .empty:
                        Color.gray.opacity(0.3)
                    case .success(let image):
                        image.resizable().scaledToFill()
                    case .failure:
                        Color.red.opacity(0.3)
                    @unknown default:
                        Color.gray.opacity(0.3)
                    }
                }
                .frame(maxWidth: 160, maxHeight: 100, alignment: .top)
                .clipShape(RoundedRectangle(cornerRadius: 16))
            } else {
                Image(article.image).resizable().scaledToFill().frame(maxWidth: 160, maxHeight: 100, alignment: .top).clipShape(RoundedRectangle(cornerRadius: 16))
            }
            VStack(alignment: .leading){
                Text(article.title).font(.title3).bold().lineLimit(2).lineHeight(.normal).padding(.bottom, 1)
                Text("\(article.duration)\(article.duration > 1 ? "mins" : "min") • \(article.emotionalAttribute) • \(article.tags.joined(separator: ", "))").font(.system(size: 14)).fontWeight(.medium).lineLimit(1)
                Text(article.description).font(.system(size: 14)).opacity(0.6).lineLimit(2)
            }.padding(.leading, 12)
        }
    }
}

struct NewArticleSheet: View {
    @State private var title: String = ""
    @State private var durationText: String = ""
    @State private var imageNameOrURL: String = ""
    @State private var useImageURL: Bool = false
    @State private var emotionalAttribute: String = ""
    @State private var selectedTags: Set<String> = []
    @State private var description: String = ""
    @State private var contentText: String = ""
    
    @State private var showMarkdownPreview: Bool = false
    @State private var showValidationError: Bool = false
    
    var onSubmit: (Article) -> Void
    var onCancel: () -> Void
    
    // Preset tags for selection
    let availableTags = ["Career", "Social Interaction", "Stereotype", "Upskilling", "Mental Health", "Empowerment", "Anxious", "Courage"]
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Basic Info")) {
                    TextField("Title *", text: $title)
                    TextField("Duration (minutes) *", text: $durationText)
                        .keyboardType(.numberPad)
                    
                    Toggle("Use Image URL", isOn: $useImageURL.animation())
                    
                    if useImageURL {
                        TextField("Image URL", text: $imageNameOrURL)
                            .keyboardType(.URL)
                            .autocapitalization(.none)
                            .disableAutocorrection(true)
                    } else {
                        TextField("Image name (asset)", text: $imageNameOrURL)
                            .autocapitalization(.none)
                            .disableAutocorrection(true)
                    }
                    
                    TextField("Emotional Attribute", text: $emotionalAttribute)
                }
                
                Section(header: Text("Tags (select one or more) *")) {
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack {
                            ForEach(availableTags, id: \.self) { tag in
                                TagButton(tag: tag, isSelected: selectedTags.contains(tag)) {
                                    if selectedTags.contains(tag) {
                                        selectedTags.remove(tag)
                                    } else {
                                        selectedTags.insert(tag)
                                    }
                                }
                            }
                        }
                        .padding(.vertical, 4)
                    }
                }
                
                Section(header: Text("Description")) {
                    TextField("Description", text: $description)
                }
                
                Section(header: HStack {
                    Text("Content *")
                    Spacer()
                    Toggle("Preview", isOn: $showMarkdownPreview)
                        .labelsHidden()
                }) {
                    if showMarkdownPreview {
                        ScrollView {
                            if #available(iOS 15.0, *) {
                                if let attributed = try? AttributedString(markdown: contentText) {
                                    Text(attributed)
                                        .padding(4)
                                } else {
                                    Text(contentText)
                                        .padding(4)
                                }
                            } else {
                                Text(contentText)
                                    .padding(4)
                            }
                        }
                        .frame(minHeight: 150)
                    } else {
                        TextEditor(text: $contentText)
                            .frame(minHeight: 150)
                    }
                }
                
                if showValidationError {
                    Section {
                        Text("Please fill in all required fields correctly:\n- Title at least 1 character\n- Duration must be a positive integer\n- At least one tag selected\n- Content must not be empty")
                            .foregroundColor(.red)
                            .font(.footnote)
                    }
                }
            }
            .navigationBarTitle("New Article", displayMode: .inline)
            .navigationBarItems(
                leading: Button("Cancel") {
                    onCancel()
                },
                trailing: Button("Save") {
                    submit()
                }
                    .disabled(!isValid())
            )
        }
    }
    
    private func isValid() -> Bool {
        guard !title.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else { return false }
        guard let duration = Int(durationText.trimmingCharacters(in: .whitespacesAndNewlines)), duration > 0 else { return false }
        guard !selectedTags.isEmpty else { return false }
        let contentLines = contentText
            .split(separator: "\n")
            .map { String($0).trimmingCharacters(in: .whitespacesAndNewlines) }
            .filter { !$0.isEmpty }
        guard !contentLines.isEmpty else { return false }
        return true
    }
    
    private func submit() {
        guard isValid() else {
            showValidationError = true
            return
        }
        showValidationError = false
        
        let duration = Int(durationText.trimmingCharacters(in: .whitespacesAndNewlines))!
        let contentLines = contentText
            .split(separator: "\n")
            .map { String($0).trimmingCharacters(in: .whitespacesAndNewlines) }
            .filter { !$0.isEmpty }
        
        var imageURL: URL? = nil
        if useImageURL {
            imageURL = URL(string: imageNameOrURL.trimmingCharacters(in: .whitespacesAndNewlines))
        }
        
        let article = Article(
            title: title.trimmingCharacters(in: .whitespacesAndNewlines),
            duration: duration,
            image: useImageURL ? "photo" : imageNameOrURL.trimmingCharacters(in: .whitespacesAndNewlines),
            emotionalAttribute: emotionalAttribute.trimmingCharacters(in: .whitespacesAndNewlines),
            tags: Array(selectedTags),
            description: description.trimmingCharacters(in: .whitespacesAndNewlines),
            content: contentLines,
            imageURL: imageURL
        )
        onSubmit(article)
    }
}

struct TagButton: View {
    var tag: String
    var isSelected: Bool
    var action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Text(tag)
                .font(.subheadline)
                .padding(.horizontal, 12)
                .padding(.vertical, 6)
                .background(isSelected ? Color.accentColor.opacity(0.7) : Color.gray.opacity(0.3))
                .foregroundColor(isSelected ? .white : .primary)
                .cornerRadius(15)
        }
        .buttonStyle(PlainButtonStyle())
    }
}

struct NewStorySheet: View {
    @State private var username: String = ""
    @State private var imageNameOrURL: String = ""
    @State private var useImageURL: Bool = false
    @State private var contentText: String = ""
    
    @State private var showValidationError: Bool = false
    
    var onSubmit: (Story) -> Void
    var onCancel: () -> Void
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("User Info")) {
                    TextField("Username *", text: $username)
                    Toggle("Use Image URL", isOn: $useImageURL.animation())
                    if useImageURL {
                        TextField("Image URL *", text: $imageNameOrURL)
                            .keyboardType(.URL)
                            .autocapitalization(.none)
                            .disableAutocorrection(true)
                    } else {
                        TextField("Image name (asset) *", text: $imageNameOrURL)
                            .autocapitalization(.none)
                            .disableAutocorrection(true)
                    }
                }
                Section(header: Text("Story Content *")) {
                    TextEditor(text: $contentText)
                        .frame(minHeight: 150)
                }
                
                if showValidationError {
                    Section {
                        Text("Please fill in all required fields:\n- Username must not be empty\n- Image name or URL must not be empty\n- Content must not be empty")
                            .foregroundColor(.red)
                            .font(.footnote)
                    }
                }
            }
            .navigationBarTitle("New Story", displayMode: .inline)
            .navigationBarItems(
                leading: Button("Cancel") {
                    onCancel()
                },
                trailing: Button("Save") {
                    submit()
                }
                    .disabled(!isValid())
            )
        }
    }
    
    private func isValid() -> Bool {
        let trimmedUsername = username.trimmingCharacters(in: .whitespacesAndNewlines)
        let trimmedImage = imageNameOrURL.trimmingCharacters(in: .whitespacesAndNewlines)
        let trimmedContent = contentText.trimmingCharacters(in: .whitespacesAndNewlines)
        return !trimmedUsername.isEmpty && !trimmedImage.isEmpty && !trimmedContent.isEmpty
    }
    
    private func submit() {
        guard isValid() else {
            showValidationError = true
            return
        }
        showValidationError = false
        
        let story = Story(username: username.trimmingCharacters(in: .whitespacesAndNewlines),
                          image: imageNameOrURL.trimmingCharacters(in: .whitespacesAndNewlines),
                          timestamp: Date(),
                          content: contentText.trimmingCharacters(in: .whitespacesAndNewlines))
        onSubmit(story)
    }
}

struct StoryFullScreenView: View {
    var story: Story
    var onDismiss: () -> Void
    
    // Helper: time ago string
    var timeAgo: String {
        let elapsed = Date().timeIntervalSince(story.timestamp)
        if elapsed < 60 {
            return "Just now"
        } else if elapsed < 3600 {
            let m = Int(elapsed/60)
            return "\(m) minute\(m>1 ? "s" : "") ago"
        } else if elapsed < 86400 {
            let h = Int(elapsed/3600)
            return "\(h) hour\(h>1 ? "s" : "") ago"
        } else {
            let d = Int(elapsed/86400)
            return "\(d) day\(d>1 ? "s" : "") ago"
        }
    }
    
    var body: some View {
        ZStack(alignment: .topTrailing) {
            Color.black.ignoresSafeArea()
            
            VStack(spacing: 20) {
                Spacer()
                if story.image.starts(with: "http") || story.image.starts(with: "https") {
                    AsyncImage(url: URL(string: story.image)) { phase in
                        switch phase {
                        case .empty:
                            ProgressView()
                                .frame(width: 200, height: 200)
                        case .success(let image):
                            image.resizable().scaledToFit()
                                .frame(maxWidth: 300, maxHeight: 300)
                                .clipShape(RoundedRectangle(cornerRadius: 16))
                        case .failure:
                            Image(systemName: "photo.fill")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 200, height: 200)
                                .foregroundColor(.red)
                        @unknown default:
                            EmptyView()
                        }
                    }
                } else {
                    Image(story.image)
                        .resizable()
                        .scaledToFit()
                        .frame(maxWidth: 300, maxHeight: 300)
                        .clipShape(RoundedRectangle(cornerRadius: 16))
                }
                
                VStack(spacing: 6) {
                    Text(story.username)
                        .font(.title)
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                    
                    Text(timeAgo)
                        .font(.subheadline)
                        .foregroundColor(.gray)
                    
                    ScrollView {
                        Text(story.content)
                            .font(.body)
                            .foregroundColor(.white)
                            .multilineTextAlignment(.center)
                            .padding()
                    }
                    .frame(maxHeight: 200)
                }
                .padding(.horizontal)
                
                Spacer()
            }
            .padding(.top, 50)
            
            Button(action: {
                onDismiss()
            }) {
                Image(systemName: "xmark.circle.fill")
                    .font(.system(size: 36))
                    .foregroundColor(.white.opacity(0.8))
                    .padding()
            }
        }
    }
}

// New View to display author info with follow button
struct AuthorHeaderView: View {
    let user: CommunityUser
    let currentUsername: String
    var followAction: (CommunityUser) -> Void
    
    var body: some View {
        HStack(spacing: 12) {
            if user.avatar.starts(with: "http") || user.avatar.starts(with: "https") {
                AsyncImage(url: URL(string: user.avatar)) { phase in
                    switch phase {
                    case .empty:
                        Circle()
                            .fill(Color.gray.opacity(0.3))
                            .frame(width: 48, height: 48)
                    case .success(let image):
                        image.resizable().scaledToFill()
                            .frame(width: 48, height: 48)
                            .clipShape(Circle())
                    case .failure:
                        Circle()
                            .fill(Color.red.opacity(0.3))
                            .frame(width: 48, height: 48)
                    @unknown default:
                        Circle()
                            .fill(Color.gray.opacity(0.3))
                            .frame(width: 48, height: 48)
                    }
                }
            } else {
                Image(user.avatar)
                    .resizable()
                    .scaledToFill()
                    .frame(width: 48, height: 48)
                    .clipShape(Circle())
            }
            
            Text(user.username)
                .font(.headline)
            
            Spacer()
            
            if user.username != currentUsername {
                Button(action: {
                    followAction(user)
                }) {
                    Text(user.isFollowed ? "Following" : "Follow")
                        .font(.subheadline)
                        .fontWeight(.medium)
                        .padding(.horizontal, 14)
                        .padding(.vertical, 6)
                        .background(user.isFollowed ? Color.accentColor.opacity(0.8) : Color.gray.opacity(0.3))
                        .foregroundColor(user.isFollowed ? .white : .primary)
                        .cornerRadius(18)
                }
                .buttonStyle(PlainButtonStyle())
            }
        }
        .padding(.horizontal)
        .padding(.vertical, 8)
        .background(Color(.systemGray6))
        .clipShape(RoundedRectangle(cornerRadius: 16))
    }
}

struct StoryContentView: View {
    var story: Story
    
    var body: some View {
        VStack(spacing: 12) {
            if story.image.starts(with: "http") || story.image.starts(with: "https") {
                AsyncImage(url: URL(string: story.image)) { phase in
                    switch phase {
                    case .empty:
                        Circle()
                            .fill(Color.gray.opacity(0.3))
                            .frame(width: 150, height: 150)
                    case .success(let image):
                        image.resizable().scaledToFill()
                            .frame(width: 150, height: 150)
                            .clipShape(Circle())
                    case .failure:
                        Circle()
                            .fill(Color.red.opacity(0.3))
                            .frame(width: 150, height: 150)
                    @unknown default:
                        Circle()
                            .fill(Color.gray.opacity(0.3))
                            .frame(width: 150, height: 150)
                    }
                }
            } else {
                Image(story.image)
                    .resizable()
                    .scaledToFill()
                    .frame(width: 150, height: 150)
                    .clipShape(Circle())
            }
            
            Text(story.content)
                .font(.body)
                .frame(maxWidth: .infinity, alignment: .leading)
        }
    }
}

// MARK: - MessagingView and ChatDetailView

struct MessagingView: View {
    @Binding var users: [CommunityUser]
    let currentUsername: String
    
    
    @Environment(\.modelContext) private var modelContext
    
    var followedUsers: [CommunityUser] {
        users.filter { $0.isFollowed && $0.username != currentUsername }
    }
    
    var body: some View {
        NavigationStack {
            List(followedUsers) { user in
                if followedUsers.isEmpty {
                    Text("You are not following anyone yet.")
                        .foregroundColor(.secondary)
                } else {
                    //                    ForEach(followedUsers) { user in
                    NavigationLink(value: user) {
                        HStack(spacing: 12) {
                            if user.avatar.starts(with: "http") || user.avatar.starts(with: "https") {
                                AsyncImage(url: URL(string: user.avatar)) { phase in
                                    switch phase {
                                    case .empty:
                                        Circle()
                                            .fill(Color.gray.opacity(0.3))
                                            .frame(width: 48, height: 48)
                                    case .success(let image):
                                        image.resizable().scaledToFill()
                                            .frame(width: 48, height: 48)
                                            .clipShape(Circle())
                                    case .failure:
                                        Circle()
                                            .fill(Color.red.opacity(0.3))
                                            .frame(width: 48, height: 48)
                                    @unknown default:
                                        Circle()
                                            .fill(Color.gray.opacity(0.3))
                                            .frame(width: 48, height: 48)
                                    }
                                }
                            } else {
                                Image(user.avatar)
                                    .resizable()
                                    .scaledToFill()
                                    .frame(width: 48, height: 48)
                                    .clipShape(Circle())
                            }
                            Text(user.username)
                                .font(.headline)
                                .foregroundColor(.primary)
                            Spacer()
                        }
                        //                        }
                    }
                }
            }.navigationDestination(for: CommunityUser.self){ selectedUser in
                ChatDetailView(user: selectedUser, currentUsername: currentUsername)
                    .environment(\.modelContext, modelContext)
            }
            .navigationBarTitle("Messages")
        }
    }
}

struct ChatDetailView: View {
    let user: CommunityUser
    let currentUsername: String
    
    @Environment(\.modelContext) private var modelContext
    @Query private var directMessages: [DirectMessage]
    
    @State private var newMessageText: String = ""
    
    @Environment(\.dismiss) private var dismiss
    
    init(user: CommunityUser, currentUsername: String) {
        self.user = user
        self.currentUsername = currentUsername
        let other = user.username
        
        // Fix: Use direct string comparison in the predicate
        _directMessages = Query(filter: #Predicate<DirectMessage> { message in
            (message.fromUser == currentUsername && message.toUser == other) ||
            (message.fromUser == other && message.toUser == currentUsername)
        }, sort: \.timestamp)
    }
    
    var body: some View {
        VStack {
            ScrollViewReader { scrollProxy in
                ScrollView {
                    LazyVStack(spacing: 8) {
                        ForEach(directMessages) { msg in
                            HStack {
                                if msg.fromUser == currentUsername {
                                    Spacer()
                                    Text(msg.content)
                                        .padding(10)
                                        .background(Color.accentColor)
                                        .foregroundColor(.white)
                                        .cornerRadius(12)
                                        .frame(maxWidth: 250, alignment: .trailing)
                                        .id(msg.id)
                                } else {
                                    Text(msg.content)
                                        .padding(10)
                                        .background(Color.gray.opacity(0.3))
                                        .foregroundColor(.primary)
                                        .cornerRadius(12)
                                        .frame(maxWidth: 250, alignment: .leading)
                                        .id(msg.id)
                                    Spacer()
                                }
                            }
                        }
                    }
                    .padding()
                }
                .onChange(of: directMessages.count) { _ in
                    if let last = directMessages.last {
                        withAnimation {
                            scrollProxy.scrollTo(last.id, anchor: .bottom)
                        }
                    }
                }
            }
            Divider()
            HStack {
                TextField("Message", text: $newMessageText)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .disableAutocorrection(true)
                Button(action: sendMessage) {
                    Image(systemName: "paperplane.fill")
                        .foregroundColor(newMessageText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty ? .gray : Color.accentColor)
                }
                .disabled(newMessageText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
            }
            .padding(.horizontal)
            .padding(.bottom, 8)
        }
        .navigationTitle(user.username)
        .navigationBarTitleDisplayMode(.inline)
    }
    
    private func sendMessage() {
        let trimmed = newMessageText.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmed.isEmpty else { return }
        let msg = DirectMessage(fromUser: currentUsername, toUser: user.username, content: trimmed)
        modelContext.insert(msg)
        do {
            try modelContext.save()
        } catch {
            print("Failed to save message: \(error)")
        }
        newMessageText = ""
    }
}

#Preview {
    @Previewable @State var isInternalNavigated = false
    CommunityCenterView(isInternalNavigated: $isInternalNavigated)
}
