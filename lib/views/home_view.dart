import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class HomeView extends StatefulWidget {
  @override
  _HomeViewState createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {

  Set<Marker> _markers = {};

  void _onMapCreated(GoogleMapController controller) {
    setState(() {
      _markers.add(
        Marker(
          infoWindow: InfoWindow(
            title: "NEXT MY HOUSE",
            snippet: "TARUMA MANAUS TOP CENTER"
          ),
          markerId: MarkerId("id-1"),
          position: LatLng(-3.006669087006096, -60.036741948623686),
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Google Map"),
      ),
      body: GoogleMap(
        onMapCreated: _onMapCreated,
        markers: _markers,
        initialCameraPosition: CameraPosition(
            target: LatLng(-2.9962554022094388, -60.02916501383111), zoom: 15),
      ),
    );
  }
}
