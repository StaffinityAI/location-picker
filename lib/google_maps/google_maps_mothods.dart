import 'dart:convert';
import 'dart:developer';
import 'package:http/http.dart' as http;
import 'package:location_picker/extension/google_geocoding_address.dart';

googlePlacesSearch(
    {required String street,
    required String streetNumber,
    required String zipcode,
    String? city,
    required String apiKey}) async {
  try {
    Uri url = Uri.parse(
        'https://maps.googleapis.com/maps/api/geocode/json?address=$street} $streetNumber $city,$zipcode,Germany&key=$apiKey');
    log('URL::${url.toString()}');
    var response = await http.get(url);
    if (response.statusCode == 200) {
      log('RESPONSE FROM GOOGLE PLACES:: ${response.body}');
      Map<String, dynamic> add;
      add = (json.decode(response.body) as Map<dynamic, dynamic>).getAddressFromResponse(
          cityText: city ?? "",
          streetNoText: streetNumber,
          countryText: 'Germany',
          streetText: street,
          zipcodeText: zipcode);
      return add;
    }
  } catch (e) {
    throw e.toString();
  }
}
