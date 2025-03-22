import SwiftUI

struct LoginView: View {
    @State private var username = ""
    @State private var password = ""
    @StateObject private var userProfileStore = UserProfileStore()
    @State private var showChat = false
    @State private var showRegister = false

    var body: some View {
        VStack {
            Image("mascot") 
                .resizable()
                .scaledToFit()
                .frame(width: 100, height: 100)

            Text("Welcome to Luna Chat")
                .font(.largeTitle)
                .bold()
                .foregroundColor(.purple)

            TextField("Enter your username", text: $username)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()

            SecureField("Enter your password", text: $password)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()

            Button("Sign In") {
                if userProfileStore.authenticateUser(username: username, password: password) {
                    showChat = true
                } else {
                    print("Invalid Credentials")
                }
            }
            .padding()
            .background(Color.purple)
            .foregroundColor(.white)
            .cornerRadius(8)

            Button("Register") {
                showRegister = true
            }
            .padding()
        }
        .background(LinearGradient(gradient: Gradient(colors: [Color.black, Color.purple]), startPoint: .topLeading, endPoint: .bottomTrailing))
        .fullScreenCover(isPresented: $showChat) {
            ChatView()
        }
        .fullScreenCover(isPresented: $showRegister) {
            RegisterView()
        }
    }
}
