import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:flutter/services.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Nextflow Google Maps',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Nextflow Google Maps'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  CameraPosition _startLocation = CameraPosition(
    target: LatLng(13.6737608,100.451856),
    zoom: 17,
  );

  Set<Marker> markerSet = new Set<Marker>();
  Set<Polyline> polylineSet = new Set<Polyline>();

  GoogleMapController _controller;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: GoogleMap(
        mapType: MapType.satellite,
        initialCameraPosition: _startLocation,
        markers: markerSet,
        polylines: polylineSet,
        myLocationButtonEnabled: false,
        onMapCreated: (GoogleMapController controller) {
          _controller = controller;
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          var location = new Location();
          try {
            var currentLocation = await location.getLocation();
            var newPosition = CameraPosition(
              target: LatLng(currentLocation.latitude, currentLocation.longitude),
              zoom: 20,
              tilt: 90.0
            );

            // _kGooglePlex = newPosition;
            _controller.animateCamera(CameraUpdate.newCameraPosition(newPosition));

            // Plot Marker on device's location
            var deviceLatLng = LatLng(currentLocation.latitude, currentLocation.longitude);
            var destinationLatLng = LatLng(12.6960129, 101.2662837);

            var marker = Marker(
              markerId: MarkerId('1'),
              position: deviceLatLng
            );

            // Ploy polyline from device's locatoin to Central Plaza Rayong
            var line = Polyline(
              polylineId: PolylineId('line1'),
              points: [
                deviceLatLng,
                destinationLatLng
              ],
              color: Colors.yellow,
              geodesic: true,
            );

            var markerCentral = Marker(
              markerId: MarkerId('2'),
              position: destinationLatLng
            );

            setState(() {
              polylineSet.add(line);
              markerSet.add(marker);
              markerSet.add(markerCentral);
            });
            

          } on PlatformException catch (e) {
            if (e.code == 'PERMISSION_DENIED') {
              print('Permission denied');
            }
          }
        },
        tooltip: 'Increment',
        child: Icon(Icons.location_on),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
