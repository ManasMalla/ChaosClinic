//
//  SwiftUIView.swift
//  Chaos Clinic
//
//  Created by Manas Malla on 17/07/25.
//

import SwiftUI

struct User: Identifiable, Hashable {
    let id = UUID()
    let username: String
    let avatar: String // name or URL
    var isFollowed: Bool
}

struct Destination{
    var title: String
    var parentDestination: AppState
    var childDestination: AppTabState? = nil
    var subheadline: String
    var image: String = ""
}

struct SearchView: View {
    var onSelect: (Destination)->Void = {_ in }
    @State private var searchToken: String = ""
    @State var users: [User] = [
        User(username: "Kavya", avatar: "kavya", isFollowed: false),
        User(username: "Varshita", avatar: "varshita", isFollowed: false),
        User(username: "Jayadhar", avatar: "jayadhar", isFollowed: false),
        User(username: "Revanth", avatar: "revanth", isFollowed: false)
    ]
    let navigationDestinations: [Destination] = [
        Destination(title: "Chat With AI", parentDestination: .Home, childDestination: .ChatWithAi, subheadline: "Have a deep conversation with our emotional and empathetic chatbot.", image: "message"),
        Destination(title: "State of Mind", parentDestination: .Home, childDestination: .Dashboard, subheadline: "Record your emotional state of mind and get insights.", image: "brain.head.profile"),
        Destination(title: "Challenges", parentDestination: .Home, childDestination: .Challenges, subheadline: "Compete with friends and family in fun and challenging emotional challenges.", image: "medal"),
        Destination(title: "Community Center", parentDestination: .Home, childDestination: .CommunityCenter, subheadline: "A series of true stories on emotional well-being from people near you.", image: "person.2"),
        Destination(title: "Account & Settings", parentDestination: .Home, childDestination: .Settings, subheadline: "Manage your account and data or connect with HealthKit.", image: "person.badge.shield.checkmark")
    ]
    var body: some View {
        NavigationStack{
            List{
                ForEach(navigationDestinations.filter{ searchToken == "" ||
                    $0.title.lowercased().contains(searchToken.lowercased())
                }, id: \.title){ _destination in
                    HStack{
                        Image(systemName: _destination.image)
                        VStack(alignment: .leading) {
                            Text(_destination.title).font(.headline)
                            Text(_destination.subheadline).font(.subheadline).opacity(0.7).lineLimit(2)
                        }.padding(.leading, 8)
                    }.onTapGesture {
                        onSelect(_destination)
                    }
                }
                
                Section(header: Text("People")) {
                    ForEach(users.filter { searchToken == "" || $0.username.lowercased().contains(searchToken.lowercased()) }, id: \.id) { user in
                        HStack {
                            Image(user.avatar)
                                .resizable().scaledToFill()
                                .frame(width: 32, height: 32)
                                .clipShape(Circle())
                            Text(user.username)
                            Spacer()
                            Button(user.isFollowed ? "Following" : "Follow") {
                                if let idx = users.firstIndex(where: { $0.id == user.id }) {
                                    users[idx].isFollowed.toggle()
                                }
                            }
                            .buttonStyle(.borderedProminent)
                            .font(.caption)
                        }
                    }
                }
            }
            .navigationTitle(Text("Search"))
        }
        .searchable(text: $searchToken)
    }
}

#Preview {
    SearchView()
}
