import 'package:flutter/material.dart';
import 'package:steak_finder/services/steakhouses.dart';

class Favorites extends StatefulWidget {
  const Favorites({Key? key}) : super(key: key);

  @override
  State<Favorites> createState() => _FavoritesState();
}

class _FavoritesState extends State<Favorites> {
  @override
  void initState() {
    super.initState();
    print('Favorites');
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Center(
        child: Text('Favorites!'),
      ),
    );
  }
}
