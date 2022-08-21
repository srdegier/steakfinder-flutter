import 'package:flutter_map/flutter_map.dart';

Set<Marker> getmarkers() {
  //markers to place on map
  dynamic markers;
  markers.add(Marker(
    //add first marker
    markerId: MarkerId(showLocation.toString()),
    position: showLocation, //position of marker
    infoWindow: InfoWindow(
      //popup info
      title: 'Marker Title First ',
      snippet: 'My Custom Subtitle',
    ),
    icon: BitmapDescriptor.defaultMarker, //Icon for Marker
  ));

  return markers;
}
