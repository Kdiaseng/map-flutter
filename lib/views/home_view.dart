import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class HomeView extends StatefulWidget {
  @override
  _HomeViewState createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  Set<Marker> _markers = {};
  BitmapDescriptor mapMarker;
  BitmapDescriptor mapMarkerUnavailable;

  @override
  void initState() {
    super.initState();
    setCustomMarker();
  }

  void setCustomMarker() async {
    BitmapDescriptor.fromAssetImage(
            ImageConfiguration(size: Size(72, 72)), 'assets/available.png')
        .then((onValue) {
      mapMarker = onValue;
    });

    BitmapDescriptor.fromAssetImage(
            ImageConfiguration(size: Size(72, 72)), 'assets/unavailable.png')
        .then((onValue) {
      mapMarkerUnavailable = onValue;
    });
  }

  void _onMapCreated(GoogleMapController controller) {
    setState(() {
      _markers.add(
        Marker(
            markerId: MarkerId("id-1"),
            position: LatLng(-3.006669087006096, -60.036741948623686),
            infoWindow: InfoWindow(
                title: "NEXT MY HOUSE", snippet: "TARUMA MANAUS TOP CENTER"),
            icon: mapMarker),
      );

      _markers.add(
        Marker(
            markerId: MarkerId("id-2"),
            position: LatLng(-3.003152497680512, -60.0288825221795),
            infoWindow:
                InfoWindow(title: "ESTACIONAMENTO", snippet: "VENHA QUE É TOP"),
            icon: mapMarkerUnavailable),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Google Map"),
      ),
      body: Stack(children: [
        GoogleMap(
          onMapCreated: _onMapCreated,
          markers: _markers,
          myLocationEnabled: true,
          myLocationButtonEnabled: true,
          zoomControlsEnabled: false,
          initialCameraPosition: CameraPosition(
              target: LatLng(-2.9962554022094388, -60.02916501383111),
              zoom: 15),
        ),
      ]),
    );
  }
}
