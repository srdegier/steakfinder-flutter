import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:google_maps_flutter_platform_interface/src/types/marker.dart';
import 'package:steak_finder/models/FavoriteSteakhouse.dart';
import 'package:steak_finder/services/databaseHelper.dart';
import 'package:steak_finder/widgets/restaurant/favoriteButton.dart';

//Callback.
typedef IntCallback = void Function(dynamic steakhouseDetails);

class List extends StatefulWidget {
  const List({
    Key? key,
    required this.steakhouses,
    required this.focusLocation,
  }) : super(key: key);

  // ignore: prefer_typing_uninitialized_variables
  final steakhouses;
  final IntCallback focusLocation;

  @override
  State<List> createState() => _ListState();

  void add(Marker marker) {}
}

class _ListState extends State<List> {
  void likeButtonIsPressed() {}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Steakhouses'),
      ),
      body: ListView.builder(
          itemCount: widget.steakhouses.length,
          itemBuilder: (BuildContext context, int index) {
            return Card(
              child: ListTile(
                leading: Text(widget.steakhouses[index].rating.toString()),
                trailing: Row(
                  // spacing: 12,
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    IconButton(
                      onPressed: () {
                        widget.focusLocation(widget.steakhouses[index]);
                        Navigator.pop(context);
                      },
                      icon: const Icon(Icons.pin_drop),
                      iconSize: 30.0,
                    ),
                    FavoriteButton(restaurant: widget.steakhouses[index]),
                  ],
                ),
                title: Text(widget.steakhouses[index].name),
              ),
            );
          }),
    );
  }
}
