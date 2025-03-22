
const OPENAI_API_KEY = ""
async function chatWithLuna(userMessage) {
    let user = JSON.parse(localStorage.getItem("loggedInUser"));
    let userAge = user ? user.age : "unknown";

    const systemMessage = `
        You are a professional psychologist who specializes in young girls' mental health.
        The user is ${userAge} years old, so provide **age-appropriate**, **empathetic**, and **scientific** advice.
    `;

    let response = await fetch("https://api.openai.com/v1/chat/completions", {
        method: "POST",
        headers: {
            "Content-Type": "application/json",
            "Authorization": `Bearer ${OPENAI_API_KEY}`
        },
        body: JSON.stringify({
            model: "gpt-4",
            messages: [
                { "role": "system", "content": systemMessage },
                { "role": "user", "content": userMessage }
            ],
            max_tokens: 250
        })
    });

    let data = await response.json();
    return data.choices[0].message.content.trim();
}
