library location_picker;

import 'dart:developer';

import 'package:firebase_cloud_firestore/firebase_cloud_firestore.dart';
import 'package:geoflutterfire_plus/geoflutterfire_plus.dart';
import 'package:osm_nominatim/osm_nominatim.dart';

class LocationPicker {
  static Future<Map<String, dynamic>> searchByName({
    required String street,
    required String zipcode,
  }) async {
    try {
      final searchResult = await Nominatim.searchByName(
          street: street,
          postalCode: zipcode,
          country: 'Germany',
          limit: 1,
          addressDetails: true,
          extraTags: true,
          nameDetails: true);
      if (searchResult.isEmpty || searchResult[0].address == null) {
        throw 'No Address Found!';
      }
      final addressMap = searchResult[0].address!;

      final geoPoint = GeoPoint(searchResult[0].lat, searchResult[0].lon);
      final GeoFirePoint geoFirePoint = GeoFirePoint(geoPoint);
      log('SELECTED ADDRESS:: $addressMap');

      return {
        'street': addressMap['road'],
        'streetNumber': addressMap['house_number'],
        'zipcode': addressMap['postcode'],
        'city': addressMap['city'],
        'country': addressMap['country'],
        'geoPoint': geoPoint,
        'geohash': geoFirePoint.data['geohash'],
      };
    } catch (e) {
      throw e.toString();
    }
  }
}
