import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:steak_finder/models/FavoriteSteakhouse.dart';
import 'package:steak_finder/services/databaseHelper.dart';
import 'package:steak_finder/widgets/restaurant/favoriteButton.dart';

// Step 1: Define a Callback.
typedef IntCallback = void Function(dynamic steakhouseDetails);

class list extends StatefulWidget {
  const list({
    Key? key,
    required this.steakhouses,
    required this.focusLocation,
  }) : super(key: key);

  // ignore: prefer_typing_uninitialized_variables
  final steakhouses;
  final IntCallback focusLocation;

  @override
  State<list> createState() => _listState();
}

class _listState extends State<list> {
  void likeButtonIsPressed() {}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Steakhouses'),
      ),
      body: FutureBuilder(
        future: widget.steakhouses,
        builder: (context, AsyncSnapshot snapshot) {
          if (snapshot.hasData) {
            return ListView.builder(
                itemCount: snapshot.data?.length,
                itemBuilder: (BuildContext context, int index) {
                  return ListTile(
                    leading: const Icon(Icons.image),
                    trailing: Row(
                      // spacing: 12,
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        IconButton(
                          onPressed: () {
                            widget.focusLocation(snapshot.data[index]);
                            Navigator.pop(context);
                          },
                          icon: const Icon(Icons.pin_drop),
                          iconSize: 30.0,
                        ),
                        FavoriteButton(restaurant: snapshot.data[index]),
                        // IconButton(
                        //   onPressed: () => {inspect('breh')},
                        //   icon: FavoriteButton(
                        //       placeId: snapshot.data[index].placeId),
                        // )
                      ],
                    ),
                    title: Text(snapshot.data[index].name),
                  );
                });
          } else if (snapshot.hasError) {
            return Text('${snapshot.error}');
          }
          return const Center(child: CircularProgressIndicator());
        },
      ),
    );
  }
}
