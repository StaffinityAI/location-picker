library location_picker;

import 'package:latlong2/latlong.dart';
import 'package:location_picker/nominatim/nominatim_methods.dart';

import 'google_maps/google_maps_mothods.dart';

class LocationPicker {
  static pickLocationFromAddress(
      {required String street,
      required String streetNumber,
      String? city,

      /// ONLY REQUIRED WHEN USING [PickerMethods.googleMapsMethod]
      String? googleMapsApiKey,
      required String zipcode,
      required PickerMethods method}) {
    if (method == PickerMethods.nominatimMethod) {
      return searchByName(street: '$streetNumber $street', zipcode: zipcode);
    } else if (method == PickerMethods.googleMapsMethod) {
      return googlePlacesSearch(
          street: street, streetNumber: streetNumber, city: city, zipcode: zipcode, apiKey: googleMapsApiKey!);
    }
  }

  static pickLocationFromLatLong(
      {required LatLng points,

      /// ONLY REQUIRED WHEN USING [PickerMethods.googleMapsMethod]
      String? googleMapsApiKey,
      required PickerMethods method}) {
    if (method == PickerMethods.nominatimMethod) {
      return reverseGeocoding(points);
    } else if (method == PickerMethods.googleMapsMethod) {}
  }
}

enum PickerMethods { nominatimMethod, googleMapsMethod }
