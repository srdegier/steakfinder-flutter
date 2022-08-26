import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';

import 'package:steak_finder/services/steakhouses.dart';
import 'package:steak_finder/widgets/restaurant/floatingButton.dart';
import 'package:steak_finder/widgets/restaurant/map.dart';

class Restaurants extends StatefulWidget {
  const Restaurants({super.key});

  @override
  State<Restaurants> createState() => _RestaurantsState();
}

class _RestaurantsState extends State<Restaurants> {
  dynamic steakhouseDetails = [];
  Stream connectivityStream = Connectivity().onConnectivityChanged;

  late bool startedOffline = false;

  @override
  void initState() {
    super.initState();
    checkStartedWithOffline();
  }

  void focusLocation(data) {
    setState(() {
      steakhouseDetails = data;
    });
  }

  void checkStartedWithOffline() {
    // gets current connectivity status
    Connectivity().checkConnectivity().then(
      (value) {
        if (value == ConnectivityResult.none) {
          setState(() {
            startedOffline = true;
          });
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    // determine if the app is offline or online
    return StreamBuilder(
        stream: connectivityStream,
        builder: ((context, snapshot) {
          if (snapshot.hasData || startedOffline) {
            final connectivityResult =
                startedOffline ? ConnectivityResult.none : snapshot.data;

            // The phone has no internet connection
            if (connectivityResult == ConnectivityResult.none) {
              startedOffline = false;
              // return without Map() widget. Limited use of app.
              return Scaffold(
                  body: const Center(
                    child: Text('No internet connection'),
                  ),
                  floatingActionButton: FloatingButton(
                    noConnection: false, // the menu only has the favorite list.
                    steakhouses: const [], // empty list of steakhouses.
                    steakhouseDetails: steakhouseDetails,
                    focusLocation: (restaurant) {
                      // callback function.
                      focusLocation(restaurant);
                    },
                  ),
                  floatingActionButtonLocation:
                      FloatingActionButtonLocation.startFloat);
            }
            // The phone has internet connection
            return FutureBuilder(
                future:
                    fetchSteakhouses(), // doing a fetch and await it with Futurebuilder
                builder: ((context, AsyncSnapshot snapshot) {
                  if (snapshot.hasData) {
                    return Scaffold(
                        body: Map(
                          steakhouses:
                              snapshot.data, // list of steakhouses in area.
                          steakhouseDetails:
                              steakhouseDetails, // steakhouse detail for map inzoom.
                        ),
                        floatingActionButton: FloatingButton(
                          noConnection:
                              true, // the menu got all available buttons
                          steakhouses:
                              snapshot.data, // list of steakhouses in area.
                          steakhouseDetails:
                              steakhouseDetails, // steakhouse detail for map inzoom.
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
          // loading screen if Streambuilder is waiting for changes
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
