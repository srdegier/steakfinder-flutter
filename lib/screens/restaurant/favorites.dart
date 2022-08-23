import 'package:flutter/material.dart';
import 'package:like_button/like_button.dart';

import '../../models/FavoriteSteakhouse.dart';
import '../../services/databaseHelper.dart';

//Callback.
typedef IntCallback = void Function(dynamic steakhouseDetails);

class Favorites extends StatefulWidget {
  const Favorites({Key? key, required this.focusLocation}) : super(key: key);
  final IntCallback focusLocation;
  @override
  _FavoritesState createState() => _FavoritesState();
}

class _FavoritesState extends State<Favorites> {
  int? selectedId;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Favorites'),
      ),
      body: Center(
        child: FutureBuilder<List<FavoriteSteakhouse>>(
            future: DatabaseHelper.instance.getFavorites(),
            builder: (BuildContext context,
                AsyncSnapshot<List<FavoriteSteakhouse>> snapshot) {
              if (!snapshot.hasData) {
                return Center(child: Text('Loading...'));
              }
              return snapshot.data!.isEmpty
                  ? Center(child: Text('No favorites yet!'))
                  : ListView.builder(
                      itemCount: snapshot.data?.length,
                      itemBuilder: (BuildContext context, int index) {
                        return Card(
                          child: ListTile(
                            leading: const Icon(Icons.image),
                            trailing: Row(
                              // spacing: 12,
                              mainAxisSize: MainAxisSize.min,
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                IconButton(
                                  onPressed: () {
                                    widget.focusLocation(snapshot.data![index]);
                                    Navigator.pop(context);
                                  },
                                  icon: const Icon(Icons.pin_drop),
                                  iconSize: 30.0,
                                ),
                                IconButton(
                                    onPressed: () {
                                      setState(() {
                                        DatabaseHelper.instance.remove(
                                            snapshot.data![index].placeId);
                                      });
                                    },
                                    icon: const Icon(Icons.delete))
                              ],
                            ),
                            title: Text(snapshot.data![index].name),
                          ),
                        );
                      });
            }),
      ),
    );
  }
}
