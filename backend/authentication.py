import json
import hashlib
import os

USER_FILE = "users.json"

def load_users():
    if not os.path.exists(USER_FILE):  
        with open(USER_FILE, "w") as file:
            json.dump({"users": []}, file)
    with open(USER_FILE, "r") as file:
        data = json.load(file)
    return data["users"]

def save_users(users):
    with open(USER_FILE, "w") as file:
        json.dump({"users": users}, file, indent=4)

def hash_password(password):
    return hashlib.sha256(password.encode()).hexdigest()

def register_user(username, password):
    users = load_users()

    if any(user["username"] == username for user in users):
        print("Username already exists")
        return

    users.append({"username": username, "password": hash_password(password)})
    save_users(users)
    print("Registration successful")

def authenticate_user(username, password):
    users = load_users()
    hashed_input_password = hash_password(password)  

    for user in users:
        if user["username"] == username and user["password"] == hashed_input_password:
            return True  
    return False 

def main():
    print("Welcome! Choose an option:")
    print("1️. Register")
    print("2️. Sign In")
    
    choice = input("Enter 1 or 2: ")

    if choice == "1":
        username = input("Choose a username: ")
        password = input("Choose a password: ")
        register_user(username, password)
    elif choice == "2":
        username = input("Enter username: ")
        password = input("Enter password: ")

        if authenticate_user(username, password):
            print("Login Successful!")
        else:
            print(" Invalid Credentials.")

if __name__ == "__main__":
    main()
