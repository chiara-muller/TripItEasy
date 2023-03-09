import { Controller } from "@hotwired/stimulus"
import { Loader } from '@googlemaps/js-api-loader';


// Connects to data-controller="autocomplete"
export default class extends Controller {
  static targets = ['search', 'lat', 'lng']
  static values = {
    apiKey: String
  }

  connect() {
    console.log(this.apiKeyValue)
    const _this = this
    const loader = new Loader({
      apiKey: this.apiKeyValue,
      version: "weekly",
      libraries: ["places"]
    });

    loader
      .load()
      .then((google) => {
        _this.searchBox = new google.maps.places.SearchBox(_this.searchTarget, {});
        _this.searchBox.addListener("places_changed", () => {
          const places = _this.searchBox.getPlaces();
          console.log(places)
          const lat = places[0].geometry.location.lat()
          const lng = places[0].geometry.location.lng()
          _this.latTarget.value = lat
          _this.lngTarget.value = lng
        })
      })
      .catch(e => {
        // do something
        console.log("error loading google  api")
      });
  }
}
