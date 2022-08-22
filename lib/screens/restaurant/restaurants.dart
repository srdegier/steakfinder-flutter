import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:steak_finder/screens/restaurant/favorites.dart';
import 'package:steak_finder/screens/restaurant/list.dart';
import 'package:steak_finder/services/steakhouses.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';

import 'package:steak_finder/widgets/restaurant/map.dart';

class Restaurants extends StatefulWidget {
  const Restaurants({super.key});

  @override
  State<Restaurants> createState() => _RestaurantsState();
}

class _RestaurantsState extends State<Restaurants> {
  late dynamic steakhouses;

  dynamic steakhouseDetails = [];

  @override
  void initState() {
    super.initState();
    steakhouses = fetchSteakhouses();
  }

  void focusLocation(data) {
    setState(() {
      steakhouseDetails = data;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Map(
          steakhouses: steakhouses,
          steakhouseDetails: steakhouseDetails,
        ),
        // body: Text(test),
        floatingActionButton: SpeedDial(
          animatedIcon: AnimatedIcons.menu_close,
          //openCloseDial: isDialOpen,
          //backgroundColor: Colors.redAccent,
          switchLabelPosition: true,
          overlayColor: Colors.grey,
          overlayOpacity: 0.5,
          spacing: 15,
          spaceBetweenChildren: 15,
          closeManually: false,
          children: [
            SpeedDialChild(
                child: const Icon(Icons.favorite),
                label: 'Favorites',
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const Favorites()),
                  );
                }),
            SpeedDialChild(
                child: const Icon(Icons.list),
                label: 'List',
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => list(
                              steakhouses: steakhouses,
                              focusLocation: (restaurant) {
                                focusLocation(restaurant);
                              },
                            )),
                  );
                }),
          ],
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.startFloat);
  }
}
