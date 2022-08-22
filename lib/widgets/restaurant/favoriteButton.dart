import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:like_button/like_button.dart';
import 'package:steak_finder/services/databaseHelper.dart';

import '../../models/FavoriteSteakhouse.dart';

class FavoriteButton extends StatefulWidget {
  const FavoriteButton({Key? key, required this.restaurant}) : super(key: key);

  final dynamic restaurant;

  @override
  State<FavoriteButton> createState() => _FavoriteButtonState();
}

class _FavoriteButtonState extends State<FavoriteButton> {
  // late final isFavorite;

  //late final isChecked;
  @override
  void initState() {
    super.initState();
  }

  Future<dynamic> checkisLiked(placeId) async {
    inspect(placeId);
    return await DatabaseHelper.instance.findById(placeId);
  }

  void addToFavorite(restaurant) {
    inspect(restaurant.location['lat']);
    // if not is favorite
    // if (isFavorite) {
    //   inspect('toevoegen');
    //   DatabaseHelper.instance.add(
    //     FavoriteSteakhouse(
    //       placeId: restaurant.placeId,
    //       name: restaurant.name,
    //       lat: restaurant.location['lat'],
    //       lng: restaurant.location['lng'],
    //     ),
    //   );
    // } else {
    //   inspect('Verwijderen');
    // }
  }

  Future<bool> onLikeButtonTapped(bool isLiked) async {
    /// send your request here
    // final bool success= await sendRequest();

    /// if failed, you can do nothing
    // return success? !isLiked:isLiked;
    inspect(isLiked);
    if (!isLiked) {
      inspect('Add');
      DatabaseHelper.instance.add(
        FavoriteSteakhouse(
          placeId: widget.restaurant.placeId,
          name: widget.restaurant.name,
          lat: widget.restaurant.location['lat'],
          lng: widget.restaurant.location['lng'],
        ),
      );
    } else {
      inspect('Delete');
      DatabaseHelper.instance.remove(widget.restaurant.placeId);
    }
    inspect(widget.restaurant);
    return !isLiked;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: DatabaseHelper.instance.findById(widget.restaurant.placeId),
        builder: (context, AsyncSnapshot snapshot) {
          if (snapshot.hasData) {
            return LikeButton(
              isLiked: snapshot.data.isNotEmpty,
              onTap: onLikeButtonTapped,
            );
            // return IconButton(
            //   onPressed: () =>
            //       {addToFavorite(widget.restaurant, snapshot.hasData)},
            //   icon: Icon(
            //     snapshot.data.isNotEmpty
            //         ? Icons.favorite
            //         : Icons.favorite_border,
            //     color: snapshot.data.isNotEmpty ? Colors.red : null,
            //   ),
            // );
          } else if (snapshot.hasError) {
            return Text('${snapshot.error}');
          }
          return const Center(child: CircularProgressIndicator());
        });
  }
}
