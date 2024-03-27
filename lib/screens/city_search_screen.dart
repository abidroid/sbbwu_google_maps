import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geocoding/geocoding.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class CitySearchScreen extends StatefulWidget {
  const CitySearchScreen({super.key});

  @override
  State<CitySearchScreen> createState() => _CitySearchScreenState();
}

class _CitySearchScreenState extends State<CitySearchScreen> {
  final Completer<GoogleMapController> _controller =
  Completer<GoogleMapController>();

  TextEditingController cityC = TextEditingController();


  Set<Marker> markers = {};

   CameraPosition cameraPosition = CameraPosition(
    target: LatLng(34.008, 71.57849),
    zoom: 10.4746,
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
        title: const Text('Go to any City'),

      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: TextField(
              controller: cityC,
              decoration: InputDecoration(hintText: 'city name',

              suffixIcon: IconButton(onPressed: () async{

                String cityName = cityC.text.trim();

                if( cityName.isEmpty){
                    Fluttertoast.showToast(msg: 'Please provide city name');
                }else{

                  try{
                    List<Location> locations = await locationFromAddress(cityName);

                    if( locations.isNotEmpty){
                      Fluttertoast.showToast(msg: locations.length.toString());

                      Location location = locations[0];

                      cameraPosition =  CameraPosition(
                        target: LatLng(location.latitude, location.longitude),
                        zoom: 10.4746,
                      );

                      markers.clear();
                      markers.add( Marker(markerId: MarkerId(cityC.text),
                          position: LatLng(location.latitude, location.longitude),
                          infoWindow: InfoWindow(title: cityC.text, snippet: 'I am in ${cityC.text}')
                      ));

                     GoogleMapController controller = await _controller.future;

                     controller.animateCamera(CameraUpdate.newCameraPosition(cameraPosition));

                     setState(() {

                     });
                    }
                  } on Exception catch (e){
                    Fluttertoast.showToast(msg: e.toString());
                  }
                }

              }, icon: const Icon(Icons.search))
              ),

            ),
          ),

          Expanded(
            child: GoogleMap(
              mapType: MapType.terrain,
              initialCameraPosition: cameraPosition,

              markers: markers,

              onTap: (LatLng latLng) async {

                // Reverse Geo coding

                List<Placemark> placemarks = await placemarkFromCoordinates(latLng.latitude, latLng.longitude);

                Placemark placemark = placemarks[0];

                String? country = placemark.country;
                String? locality = placemark.locality;


                cameraPosition =  CameraPosition(
                  target: latLng,
                  zoom: 10.4746,
                );

                markers.clear();
                markers.add( Marker(markerId: MarkerId(cityC.text),
                    position: latLng,
                    infoWindow: InfoWindow(title: country ?? 'Not country', snippet: 'I am in ${locality ?? 'no locality'}')
                ));

                GoogleMapController controller = await _controller.future;

                controller.animateCamera(CameraUpdate.newCameraPosition(cameraPosition));

                setState(() {

                });
              },


              onMapCreated: (GoogleMapController controller) {
                _controller.complete(controller);
              },
            ),
          ),
        ],
      ),
    );
  }
}
