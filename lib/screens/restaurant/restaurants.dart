import 'dart:async';
import 'dart:developer';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:steak_finder/screens/restaurant/favorites.dart';
import 'package:steak_finder/screens/restaurant/list.dart';
import 'package:steak_finder/services/steakhouses.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:steak_finder/widgets/restaurant/floatingButton.dart';

import 'package:steak_finder/widgets/restaurant/map.dart';

import '../../services/local_auth.dart';
import 'package:local_auth/local_auth.dart';

class Restaurants extends StatefulWidget {
  const Restaurants({super.key});

  @override
  State<Restaurants> createState() => _RestaurantsState();
}

class _RestaurantsState extends State<Restaurants> {
  //late Future<dynamic> steakhouses;

  dynamic steakhouseDetails = [];
  Stream connectivityStream = Connectivity().onConnectivityChanged;

  late bool bugFix = false;

  @override
  void initState() {
    super.initState();
    testFunc();
  }

  void focusLocation(data) {
    setState(() {
      steakhouseDetails = data;
    });
  }

  testFunc() {
    Connectivity().checkConnectivity().then(
      (value) {
        if (value == ConnectivityResult.none) {
          setState(() {
            bugFix = true;
          });
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: connectivityStream,
        builder: ((context, snapshot) {
          if (snapshot.hasData || bugFix) {
            final connectivityResult =
                bugFix ? ConnectivityResult.none : snapshot.data;

            // The phone has no internet connection
            if (connectivityResult == ConnectivityResult.none) {
              bugFix = false;

              return Scaffold(
                  body: Center(
                    child: Text('No internet connection'),
                  ),
                  floatingActionButton: FloatingButton(
                    noConnection: false,
                    steakhouses: snapshot.data,
                    steakhouseDetails: steakhouseDetails,
                    focusLocation: (restaurant) {
                      focusLocation(restaurant);
                    },
                  ),
                  floatingActionButtonLocation:
                      FloatingActionButtonLocation.startFloat);
            }
            // The phone has internet connection
            return FutureBuilder(
                future: fetchSteakhouses(),
                builder: ((context, AsyncSnapshot snapshot) {
                  if (snapshot.hasData) {
                    return Scaffold(
                        body: Map(
                          steakhouses: snapshot.data,
                          steakhouseDetails: steakhouseDetails,
                        ),
                        floatingActionButton: FloatingButton(
                          noConnection: true,
                          steakhouses: snapshot.data,
                          steakhouseDetails: steakhouseDetails,
                          focusLocation: (restaurant) {
                            focusLocation(restaurant);
                          },
                        ),
                        floatingActionButtonLocation:
                            FloatingActionButtonLocation.startFloat);
                  }
                  return const Center(child: CircularProgressIndicator());
                }));
          }
          // loading screen if Streambuilder is waiting for result
          return Center(
              child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                margin: const EdgeInsets.all(20),
                child: const CircularProgressIndicator(),
              ),
            ],
          ));
        }));
  }
}
