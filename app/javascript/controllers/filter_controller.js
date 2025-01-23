import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  submit(event) {
    // Get all filter values
    const moduleType = document.querySelector('#module_type').value
    const connectionStatus = document.querySelector('#connection_status').value
    const searchQuery = document.querySelector('.search-input')?.value || ''
    
    // Build query string
    const params = new URLSearchParams(window.location.search)
    
    if (moduleType) {
      params.set('module_type', moduleType)
    } else {
      params.delete('module_type')
    }
    
    if (connectionStatus) {
      params.set('connection_status', connectionStatus)
    } else {
      params.delete('connection_status')
    }
    
    if (searchQuery) {
      params.set('search', searchQuery)
    }
    
    // Navigate to filtered URL
    window.location.href = `${window.location.pathname}?${params.toString()}`
  }
} 