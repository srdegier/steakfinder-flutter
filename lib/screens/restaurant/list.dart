import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';

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
                    trailing: Wrap(
                      spacing: 12,
                      children: [
                        IconButton(
                          onPressed: () {
                            widget.focusLocation(snapshot.data[index]);
                            Navigator.pop(context);
                          },
                          icon: const Icon(Icons.pin_drop),
                        ),
                        IconButton(
                          onPressed: () {
                            // widget.focusLocation(snapshot.data[index]);
                          },
                          icon: const Icon(Icons.favorite),
                        ), // icon-2
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
