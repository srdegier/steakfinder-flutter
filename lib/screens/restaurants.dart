import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

class Restaurants extends StatelessWidget {
  const Restaurants({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: <Widget>[
          FlutterMap(
              options: MapOptions(
                  minZoom: 1.0,
                  center: LatLng(51.828987290912465, 4.634127878496988)),
              layers: [
                TileLayerOptions(
                    urlTemplate:
                        'https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png',
                    subdomains: ['a', 'b', 'c']),
                MarkerLayerOptions(markers: [
                  Marker(
                      width: 105.0,
                      height: 105.0,
                      point: LatLng(51.828987290912465, 4.634127878496988),
                      builder: (context) => Container(
                            child: IconButton(
                                icon: const Icon(
                                  Icons.restaurant_sharp,
                                  color: Colors.black,
                                  size: 40.0,
                                ),
                                onPressed: () {
                                  print('Marker tapped!');
                                }),
                          ))
                ])
              ])
        ],
      ),
    );
  }
}
