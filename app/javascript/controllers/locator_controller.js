import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="locator"
export default class extends Controller {
  static targets = ["latitude", "longitude"]

  connect() {
    console.log(this.latitudeTarget)
    navigator.geolocation.getCurrentPosition(this.successCallback.bind(this), this.errorCallback.bind(this));
  }

  successCallback(position) {
    // set latitude field
    const lat = position.coords.latitude
    this.latitudeTarget.value = lat
    // set longitude field
    const lng = position.coords.longitude
    this.longitudeTarget.value = lng
  }

  errorCallback(error) {
    console.log(error);
  }
}
