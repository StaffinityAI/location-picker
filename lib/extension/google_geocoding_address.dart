import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:geoflutterfire_plus/geoflutterfire_plus.dart';

extension GoogleGeocodingAddress on Map<dynamic, dynamic> {
  Map<String, dynamic> getAddressFromResponse(
      {required String streetText,
      required String zipcodeText,
      required String cityText,
      required String streetNoText,
      required String countryText}) {
    double lat = ((this['results'] as List)[0]['geometry']['location']['lat']);
    double long = (this['results'] as List)[0]['geometry']['location']['lng'];
    GeoPoint geoPoint = GeoPoint(lat, long);
    final GeoFirePoint geoFirePoint = GeoFirePoint(geoPoint);
    String no = streetNoText;
    String street = streetText;
    String code = zipcodeText;
    String city = cityText;
    String country = countryText;

    var address = ((this['results'] as List)[0]['address_components'] as List);
    if (address.isNotEmpty) {
      for (var i in address) {
        if (i['types'] != null || (i['types'] as List).isNotEmpty) {
          if ((i['types'] as List).contains('street_number')) {
            no = i['long_name'];
          } else if ((i['types'] as List).contains('route')) {
            street = i['long_name'];
          } else if ((i['types'] as List).contains('locality')) {
            city = i['long_name'];
          } else if ((i['types'] as List).contains('country')) {
            country = i['long_name'];
          } else if ((i['types'] as List).contains('postal_code')) {
            code = i['long_name'];
          }
        }
      }
    }

    return {
      'street': street,
      'streetNumber': no,
      'zipcode': code,
      'city': city,
      'country': country,
      'geoPoint': geoPoint,
      'geohash': geoFirePoint.data['geohash'],
    };
  }
}
