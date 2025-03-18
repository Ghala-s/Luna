import Foundation
import CryptoKit 

struct User: Codable {
    let username: String
    let password: String  
}

let usersFile = "users.json"  

func loadUsers() -> [User] {
    guard let url = Bundle.main.url(forResource: "users", withExtension: "json") else {
        print("users.json file not found!")
        return []
    }

    do {
        let data = try Data(contentsOf: url)
        let users = try JSONDecoder().decode([User].self, from: data)
        return users
    } catch {
        print("Error loading JSON: \(error)")
        return []
    }
}

func saveUsers(users: [User]) {
    let fileURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0].appendingPathComponent("users.json")

    do {
        let data = try JSONEncoder().encode(users)
        try data.write(to: fileURL)
        print("Users saved successfully.")
    } catch {
        print("Error saving JSON: \(error)")
    }
}

func hashPassword(_ password: String) -> String {
    let inputData = Data(password.utf8)
    let hashed = SHA256.hash(data: inputData)
    return hashed.compactMap { String(format: "%02x", $0) }.joined()
}

func registerUser(username: String, password: String) {
    var users = loadUsers()

    if users.contains(where: { $0.username == username }) {
        print("Username already exists")
        return
    }

    let newUser = User(username: username, password: hashPassword(password))
    users.append(newUser)

    saveUsers(users: users)
    print("Registration successful!")
}

func authenticateUser(username: String, password: String) -> Bool {
    let users = loadUsers()
    let hashedPassword = hashPassword(password)

    return users.contains { $0.username == username && $0.password == hashedPassword }
}

print("Choose an option:")
print("1️. Register")
print("2️. Sign In")

if let choice = readLine() {
    if choice == "1" {
        print("Choose a username:")
        let username = readLine() ?? ""
        print("Choose a password:")
        let password = readLine() ?? ""

        registerUser(username: username, password: password)
    } else if choice == "2" {
        print("Enter username:")
        let username = readLine() ?? ""
        print("Enter password:")
        let password = readLine() ?? ""

        if authenticateUser(username: username, password: password) {
            print("Login Successful!")
        } else {
            print("Invalid Credentials.")
        }
    } 
}
