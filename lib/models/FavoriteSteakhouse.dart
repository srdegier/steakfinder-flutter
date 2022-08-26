import 'dart:ffi';

class FavoriteSteakhouse {
  final String? placeId;
  final String name;
  final double lat;
  final double lng;
  final rating;

  FavoriteSteakhouse(
      {this.placeId,
      required this.name,
      required this.lat,
      required this.lng,
      required this.rating});

  factory FavoriteSteakhouse.fromMap(Map<String, dynamic> json) =>
      FavoriteSteakhouse(
        placeId: json['placeId'],
        name: json['name'],
        lat: json['lat'],
        lng: json['lng'],
        rating: json['rating'],
      );

  Map<String, dynamic> toMap() {
    return {
      'placeId': placeId,
      'name': name,
      'lat': lat,
      'lng': lng,
      'rating': rating
    };
  }
}
