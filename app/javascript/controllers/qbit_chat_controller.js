import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["question", "messages", "status", "submit"]
  static values = { url: String }

  connect() {
    this.history = []
  }

  async ask(event) {
    event.preventDefault()
    const question = this.questionTarget.value.trim()
    if (!question) return

    this.appendMessage("You", question, "bg-slate-100")
    this.history.push({ role: "user", content: question })
    this.questionTarget.value = ""
    this.statusTarget.textContent = "Q-Bit is thinking…"
    this.submitTarget.disabled = true

    try {
      const response = await fetch(this.urlValue, {
        method: "POST",
        headers: {
          "Content-Type": "application/json",
          "Accept": "application/json",
          "X-CSRF-Token": document.querySelector("meta[name='csrf-token']").content
        },
        body: JSON.stringify({ message: question, history: this.history.slice(-6) })
      })
      const payload = await response.json()
      if (!response.ok) throw new Error(payload.error || "Q-Bit could not answer right now.")

      this.appendMessage("Q-Bit", payload.reply, "bg-cyan-50")
      this.history.push({ role: "assistant", content: payload.reply })
      this.statusTarget.textContent = ""
    } catch (error) {
      this.statusTarget.textContent = `${error.message} Start Ollama with “ollama serve” and install the guide with “ollama pull llama3.2:latest”.`
    } finally {
      this.submitTarget.disabled = false
    }
  }

  appendMessage(speaker, content, color) {
    const message = document.createElement("article")
    message.className = `rounded-lg p-3 text-sm ${color}`
    const name = document.createElement("strong")
    name.textContent = `${speaker}: `
    message.append(name, document.createTextNode(content))
    this.messagesTarget.append(message)
    this.messagesTarget.scrollTop = this.messagesTarget.scrollHeight
  }
}
