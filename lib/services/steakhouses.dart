// import 'package:flutter/material.dart';
import 'dart:convert';
import 'dart:developer';
import 'dart:ffi';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';

Future fetchSteakhouses() async {
  final response = await http.get(Uri.parse(
      'https://maps.googleapis.com/maps/api/place/nearbysearch/json?location=51.91708229074513,4.483624281079596&radius=4000&type=restaurant&keyword=steakhouse&key=${dotenv.env['API_KEY']}'));

  if (response.statusCode == 200) {
    // If the server did return a 200 OK response,
    // then parse the JSON.
    final jsonResponse = json.decode(response.body);
    final steakhouses = jsonResponse['results'];
    //return jsonResponse;
    return steakhouses
        .map(
          (dynamic item) => Steakhouse.fromJson(item),
        )
        .toList();
  } else {
    // If the server did not return a 200 OK response,
    // then throw an exception.
    throw Exception('Failed to load Steakhouses');
  }
}

class Steakhouse {
  final String placeId;
  final String name;
  final double lat;
  final double lng;
  //final dynamic location;

  const Steakhouse({
    required this.placeId,
    required this.name,
    required this.lat,
    required this.lng,
    //required this.location,
  });

  factory Steakhouse.fromJson(Map<String, dynamic> json) {
    return Steakhouse(
        placeId: json['place_id'],
        name: json['name'],
        lat: json['geometry']['location']['lat'],
        lng: json['geometry']['location']['lng']
        // location: json['geometry']['location'],
        );
  }
}
