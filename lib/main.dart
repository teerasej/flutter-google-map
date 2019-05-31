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
  static final CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(37.42796133580664, -122.085749655962),
    zoom: 14.4746,
  );

  GoogleMapController _controller;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: GoogleMap(
        mapType: MapType.normal,
        initialCameraPosition: _kGooglePlex,
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
              zoom: 14.4746,
            );

           
            _controller.animateCamera(CameraUpdate.newCameraPosition(newPosition));
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
