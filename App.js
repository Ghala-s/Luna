
function saveUser(user) {
  let users = JSON.parse(localStorage.getItem("users")) || [];
  users.push(user);
  localStorage.setItem("users", JSON.stringify(users));
}

function getUser(username) {
  let users = JSON.parse(localStorage.getItem("users")) || [];
  return users.find(user => user.username === username);
}

function showRegister() {
  document.getElementById("login-section").style.display = "none";
  document.getElementById("register-section").style.display = "block";
}

function showLogin() {
  document.getElementById("register-section").style.display = "none";
  document.getElementById("login-section").style.display = "block";
}

function register() {
  let username = document.getElementById("register-username").value;
  let password = document.getElementById("register-password").value;
  let name = document.getElementById("register-name").value;
  let age = document.getElementById("register-age").value;

  if (!username || !password || !name || !age) {
      alert("Please fill in all fields.");
      return;
  }

  if (getUser(username)) {
      alert("Username already exists!");
      return;
  }

  let newUser = { username, password, name, age };
  saveUser(newUser);

  alert("Registration successful! You can now log in.");
  showLogin();
}

function login() {
  let username = document.getElementById("login-username").value;
  let password = document.getElementById("login-password").value;

  let user = getUser(username);

  if (!user) {
      alert("User not found!");
      return;
  }

  if (user.password !== password) {
      alert("Incorrect password!");
      return;
  }

  localStorage.setItem("loggedInUser", JSON.stringify(user));
  showChat();
}

function showChat() {
  let user = JSON.parse(localStorage.getItem("loggedInUser"));
  if (!user) return showLogin();

  document.getElementById("login-section").style.display = "none";
  document.getElementById("register-section").style.display = "none";
  document.getElementById("chat-section").style.display = "block";

  document.getElementById("chat-user").innerText = `Hello, ${user.name}! 👋`;
  updateTime();
}

function updateTime() {
  let now = new Date();
  document.getElementById("current-time").innerText =
      now.toLocaleTimeString([], { hour: "2-digit", minute: "2-digit" }) +
      " - " + now.toDateString();
}

function displayMessage(message, sender) {
  let chatContainer = document.getElementById("chat-container");
  let messageDiv = document.createElement("div");
  messageDiv.classList.add("chat-box", sender);
  messageDiv.innerText = message;
  chatContainer.appendChild(messageDiv);
  chatContainer.scrollTop = chatContainer.scrollHeight; 
}


async function sendMessage() {
  let messageInput = document.getElementById("message-input");
  let userMessage = messageInput.value.trim();
  if (!userMessage) return;

  displayMessage(userMessage, "user"); 

  try {
      let botResponse = await chatWithLuna(userMessage);
      displayMessage(botResponse, "bot"); 
  } catch (error) {
      console.error("Chatbot Error:", error);
      displayMessage("Sorry, something went wrong.", "bot");
  }

  messageInput.value = "";
}


function logout() {
  localStorage.removeItem("loggedInUser");
  location.reload();
}

window.onload = function() {
  if (localStorage.getItem("loggedInUser")) {
      showChat();
  }
};
