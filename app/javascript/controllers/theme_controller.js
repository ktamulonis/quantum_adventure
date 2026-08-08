import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["toggle"]

  connect() {
    this.apply(this.savedTheme())
  }

  toggle(event) {
    event.preventDefault()

    const theme = this.darkMode() ? "light" : "dark"

    this.saveTheme(theme)
    this.apply(theme)
  }

  apply(theme) {
    const dark = theme === "dark"

    document.documentElement.classList.toggle("dark", dark)
    this.toggleTarget.setAttribute("aria-pressed", dark.toString())
    this.toggleTarget.textContent = dark ? "☀ Light mode" : "☾ Dark mode"
  }

  darkMode() {
    return document.documentElement.classList.contains("dark")
  }

  savedTheme() {
    try {
      return localStorage.getItem("quantum-adventure-theme") || "dark"
    } catch (_error) {
      return "dark"
    }
  }

  saveTheme(theme) {
    try {
      localStorage.setItem("quantum-adventure-theme", theme)
    } catch (_error) {
      // The toggle remains usable when browser storage is unavailable.
    }
  }
}
