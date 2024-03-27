import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MyPeshawarScreen extends StatefulWidget {
  const MyPeshawarScreen({super.key});

  @override
  State<MyPeshawarScreen> createState() => _MyPeshawarScreenState();
}

class _MyPeshawarScreenState extends State<MyPeshawarScreen> {
  final Completer<GoogleMapController> _controller =
      Completer<GoogleMapController>();

  Set<Marker> markers = {};

  static const CameraPosition myPeshawarCP = CameraPosition(
    target: LatLng(34.008, 71.57849),
    zoom: 14.4746,
  );


  @override
  void initState() {

    markers.add( const Marker(markerId: MarkerId('1'),
    position: LatLng(34.008, 71.57849),
      infoWindow: InfoWindow(title: 'My Peshawar', snippet: 'I am in Peshawar')
    ));
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Peshawar on Map'),
      ),
      body: GoogleMap(
        mapType: MapType.terrain,
        initialCameraPosition: myPeshawarCP,

        markers: markers,
        onMapCreated: (GoogleMapController controller) {
          _controller.complete(controller);
        },
      ),
    );
  }
}
