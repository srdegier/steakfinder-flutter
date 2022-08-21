import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class Map extends StatefulWidget {
  const Map(
      {Key? key, required this.steakhouses, required this.steakhouseDetails})
      : super(key: key);

  final Future steakhouses;
  final dynamic steakhouseDetails;

  @override
  State<Map> createState() => _MapState();
}

class _MapState extends State<Map> {
  late GoogleMapController mapController;
  final LatLng _center = const LatLng(51.91708229074513, 4.483624281079596);

  @override
  void initState() {
    super.initState();
    inspect(widget.steakhouseDetails);
  }

  @override
  void didUpdateWidget(steakhouseDetails) {
    // do function
    inspect(widget.steakhouseDetails.location);
    inspect(widget.steakhouseDetails.location['lat']);
    if (widget.steakhouseDetails != []) {
      showMarkerInfoWindow(MarkerId(widget.steakhouseDetails.placeId));
      // zoom to location of steakhouse
      mapController?.animateCamera(CameraUpdate.newCameraPosition(
        CameraPosition(
            target: LatLng(widget.steakhouseDetails.location['lat'],
                widget.steakhouseDetails.location['lng']),
            zoom: 17),
      ));
    }
    super.didUpdateWidget(steakhouseDetails);
  }

  void _onMapCreated(GoogleMapController controller) async {
    mapController = controller;
  }

  showMarkerInfoWindow(MarkerId markerId) {
    inspect(markerId);
    inspect('ik ben hier');
    return mapController.showMarkerInfoWindow(markerId);
  }

  _mapPins(data) {
    List<Marker> markers = [];

    for (var restaurant in data) {
      markers.add(
        Marker(
          markerId: MarkerId(restaurant.placeId),
          position:
              LatLng(restaurant.location['lat'], restaurant.location['lng']),
          infoWindow: InfoWindow(title: restaurant.name),
          onTap: () {
            _restaurantDetail(restaurant);
            // showMarkerInfoWindow(const MarkerId('ChIJa1H5JQkzxEcRf_XgrBpbj5Q'));
          },
        ),
      );
    }
    return Set<Marker>.of(markers);
  }

  _restaurantDetail(restaurant) {
    inspect('???');
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: widget.steakhouses,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return GoogleMap(
            onMapCreated: _onMapCreated,
            initialCameraPosition: CameraPosition(
              target: _center,
              zoom: 13.0,
            ),
            markers: _mapPins(
              snapshot.data,
            ),
          );
        } else if (snapshot.hasError) {
          return Text('${snapshot.error}');
        }
        return const Center(child: CircularProgressIndicator());
      },
    );
  }
}
