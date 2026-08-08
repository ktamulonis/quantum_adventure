import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["toggle"]

  connect() {
    this.apply(this.savedTheme())
  }

  toggle() {
    const theme = this.dark? ? "light" : "dark"

    localStorage.setItem("quantum-adventure-theme", theme)
    this.apply(theme)
  }

  apply(theme) {
    const dark = theme === "dark"

    document.documentElement.classList.toggle("dark", dark)
    this.toggleTarget.setAttribute("aria-pressed", dark.toString())
    this.toggleTarget.textContent = dark ? "☀ Light mode" : "☾ Dark mode"
  }

  dark?() {
    return document.documentElement.classList.contains("dark")
  }

  savedTheme() {
    return localStorage.getItem("quantum-adventure-theme") || "dark"
  }
}
