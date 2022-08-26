import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';

class Map extends StatefulWidget {
  const Map(
      {Key? key, required this.steakhouses, required this.steakhouseDetails})
      : super(key: key);

  final List steakhouses;
  final dynamic steakhouseDetails;

  @override
  State<Map> createState() => _MapState();
}

class _MapState extends State<Map> {
  late GoogleMapController mapController;
  final LatLng _center = const LatLng(51.91708229074513, 4.483624281079596);
  Location _location = Location();

  @override
  void initState() {
    super.initState();
  }

  @override
  void didUpdateWidget(steakhouseDetails) {
    if (widget.steakhouseDetails != []) {
      showMarkerInfoWindow(MarkerId(widget.steakhouseDetails.placeId));
      // zoom to location of steakhouse
      mapController.animateCamera(CameraUpdate.newCameraPosition(
        CameraPosition(
            target: LatLng(
              widget.steakhouseDetails.lat,
              widget.steakhouseDetails.lng,
            ),
            zoom: 17),
      ));
    }
    super.didUpdateWidget(steakhouseDetails);
  }

  // void _onMapCreated(GoogleMapController controller) async {
  //   mapController = controller;
  // }

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
    _location.onLocationChanged.listen((l) {
      // mapController.animateCamera(
      //   CameraUpdate.newCameraPosition(
      //     CameraPosition(target: LatLng(l.latitude!, l.longitude!), zoom: 15),
      //   ),
      // );
    });
  }

  showMarkerInfoWindow(MarkerId markerId) {
    return mapController.showMarkerInfoWindow(markerId);
  }

  _mapPins(data) {
    List<Marker> markers = [];

    for (var restaurant in data) {
      markers.add(
        Marker(
          markerId: MarkerId(restaurant.placeId),
          position: LatLng(restaurant.lat, restaurant.lng),
          infoWindow: InfoWindow(title: restaurant.name),
        ),
      );
    }
    return Set<Marker>.of(markers);
  }

  @override
  Widget build(BuildContext context) {
    return GoogleMap(
      mapType: MapType.normal,
      myLocationEnabled: true,
      onMapCreated: _onMapCreated,
      initialCameraPosition: CameraPosition(
        target: _center,
        zoom: 13.0,
      ),
      markers: _mapPins(
        widget.steakhouses,
      ),
    );
  }
}
