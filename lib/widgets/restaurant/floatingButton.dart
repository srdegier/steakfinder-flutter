import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:steak_finder/screens/restaurant/favorites.dart';
import 'package:steak_finder/services/local_auth.dart';

import '../../screens/restaurant/list.dart';

//Callback.
typedef IntCallback = void Function(dynamic steakhouseDetails);

class FloatingButton extends StatefulWidget {
  FloatingButton({
    Key? key,
    required this.steakhouseDetails,
    required this.steakhouses,
    required this.focusLocation,
    required bool this.noConnection,
  }) : super(key: key);

  final IntCallback focusLocation;
  final steakhouses;
  final steakhouseDetails;
  final noConnection;
  @override
  State<FloatingButton> createState() => _FloatingButtonState();
}

class _FloatingButtonState extends State<FloatingButton> {
  void focusLocation(data) {
    widget.focusLocation(data);
  }

  @override
  Widget build(BuildContext context) {
    return SpeedDial(
      animatedIcon: AnimatedIcons.menu_close,
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
            onTap: () async {
              var result = await LocalAuth.authenticate();
              if (result) {
                // ignore: use_build_context_synchronously
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => Favorites(
                            focusLocation: (restaurant) {
                              focusLocation(restaurant);
                            },
                          )),
                );
              }
            }),
        SpeedDialChild(
            visible: widget.noConnection,
            child: const Icon(Icons.list),
            label: 'List',
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => list(
                          steakhouses: widget.steakhouses,
                          focusLocation: (restaurant) {
                            focusLocation(restaurant);
                          },
                        )),
              );
            }),
      ],
    );
  }
}
