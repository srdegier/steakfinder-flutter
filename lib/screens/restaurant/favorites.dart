import 'package:flutter/material.dart';

import '../../models/FavoriteSteakhouse.dart';
import '../../services/databaseHelper.dart';

class Favorites extends StatefulWidget {
  const Favorites({Key? key}) : super(key: key);

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
                  : ListView(
                      children: snapshot.data!.map((steakhouse) {
                        return Center(
                          child: Card(
                            color: selectedId == steakhouse.placeId
                                ? Colors.white70
                                : Colors.white,
                            child: ListTile(
                              title: Text(steakhouse.name),
                              onTap: () {
                                // setState(() {
                                //   if (selectedId == null) {
                                //     textController.text = grocery.name;
                                //     selectedId = grocery.placeId;
                                //   } else {
                                //     textController.text = '';
                                //     selectedId = null;
                                //   }
                                // });
                              },
                              onLongPress: () {
                                setState(() {
                                  DatabaseHelper.instance
                                      .remove(steakhouse.placeId!);
                                });
                              },
                            ),
                          ),
                        );
                      }).toList(),
                    );
            }),
      ),
    );
  }
}
