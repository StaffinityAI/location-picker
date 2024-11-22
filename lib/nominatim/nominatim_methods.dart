import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:geoflutterfire_plus/geoflutterfire_plus.dart';
import 'package:latlong2/latlong.dart';
import 'package:osm_nominatim/osm_nominatim.dart';

Future<Map<String, dynamic>> searchByName({
  required String street,
  required String zipcode,
  required String city,
}) async {
  try {
    final searchResult = await Nominatim.searchByName(
        street: street,
        postalCode: zipcode,
        city: city,
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

reverseGeocoding(LatLng points) async {
  try {
    final reverseSearchResult = await Nominatim.reverseSearch(
      lat: points.latitude,
      lon: points.longitude,
      addressDetails: true,
      extraTags: true,
      nameDetails: true,
    );

    if (reverseSearchResult.address == null) {
      throw 'Address Not Found!';
    } else {
      final addressMap = reverseSearchResult.address!;
      final geoPoint = GeoPoint(points.latitude, points.longitude);
      final GeoFirePoint geoFirePoint = GeoFirePoint(geoPoint);
      return {
        'street': addressMap['road'],
        'streetNumber': addressMap['house_number'],
        'zipcode': addressMap['postcode'],
        'city': addressMap['city'],
        'country': addressMap['country'],
        'geoPoint': geoPoint,
        'geohash': geoFirePoint.data['geohash']
      };
    }
  } catch (e) {
    throw e.toString();
  }
}
