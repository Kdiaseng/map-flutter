import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:rating_bar/rating_bar.dart';

class HomeView extends StatefulWidget {
  @override
  _HomeViewState createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  Set<Marker> _markers = {};
  BitmapDescriptor mapMarker;
  BitmapDescriptor mapMarkerUnavailable;
  BitmapDescriptor mapMarkerThree;

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
            ImageConfiguration(size: Size(72, 72)), 'assets/available.png')
        .then((onValue) {
      mapMarkerThree = onValue;
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

      _markers.add(
        Marker(
            markerId: MarkerId("id-3"),
            position: LatLng(-3.0107769937230198, -60.032253593350944),
            infoWindow: InfoWindow(
                title: "ESTACIONAMENTO TOP LINHA", snippet: "MELHOR DA CIDADE"),
            icon: mapMarkerThree),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Google Map"),
      ),
      body: Stack(children: [_getGoogleMaps(context), _parkingListContainer()]),
    );
  }

  Widget _getGoogleMaps(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height,
      width: MediaQuery.of(context).size.width,
      child: GoogleMap(
        onMapCreated: _onMapCreated,
        markers: _markers,
        myLocationEnabled: false,
        myLocationButtonEnabled: true,
        zoomControlsEnabled: false,
        initialCameraPosition: CameraPosition(
            target: LatLng(-2.9962554022094388, -60.02916501383111), zoom: 15),
      ),
    );
  }

  Widget _parkingListContainer() {
    return Align(
      alignment: Alignment.bottomLeft,
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 20.0),
        height: 200,
        child: ListView(
          scrollDirection: Axis.horizontal,
          children: [
            SizedBox(width: 10.0),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: _parkingBox(
                  -3.006669087006096, -60.036741948623686, "Parking One"),
            ),
            SizedBox(width: 10.0),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: _parkingBox(
                  -3.006669087006096, -60.036741948623686, "Parking two"),
            ),
            SizedBox(width: 10.0),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: _parkingBox(
                  -3.006669087006096, -60.036741948623686, "Parking three"),
            ),
          ],
        ),
      ),
    );
  }

  Widget _parkingBox(double lat, double long, String parkingName) {
    return GestureDetector(
      onTap: () {},
      child: Container(
        child: FittedBox(
          child: Material(
            color: Colors.white,
            elevation: 14.0,
            borderRadius: BorderRadius.circular(10.0),
            child: Padding(
              padding: const EdgeInsets.all(15.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    parkingName,
                    style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        fontSize: 16.0),
                  ),
                  Container(
                    child: Row(
                      children: [
                        Icon(Icons.room_outlined),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("Largo de São Sebastião - Centro,",
                                style: TextStyle(
                                    color: Colors.black54, fontSize: 12)),
                            Text("Manaus - AM, 69067-080",
                                style: TextStyle(
                                    color: Colors.black54, fontSize: 12))
                          ],
                        ),
                        IconButton(
                            icon: Icon(Icons.favorite_border), onPressed: () {})
                      ],
                    ),
                  ),
                  SizedBox(height: 19.0),
                  Container(
                    child: Row(
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Pagamento",
                              style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold),
                            ),
                            Row(
                              children: [
                                Icon(Icons.credit_card_outlined),
                                SizedBox(width: 3.0),
                                Icon(Icons.payments_outlined)
                              ],
                            )
                          ],
                        ),
                        SizedBox(width: 32.0),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Veículos",
                              style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold),
                            ),
                            Row(
                              children: [
                                Icon(Icons.drive_eta),
                                SizedBox(width: 3.0),
                                Icon(Icons.local_shipping),
                                SizedBox(width: 3.0),
                                Icon(Icons.two_wheeler)
                              ],
                            )
                          ],
                        ),
                        SizedBox(width: 32.0),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Vagas",
                              style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold),
                            ),
                            Text(
                              "36",
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 23.0),
                  Container(
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text("600 M",
                            style: TextStyle(
                                color: Color(0xFF23CB7E),
                                fontSize: 16,
                                fontWeight: FontWeight.bold)),
                        SizedBox(width: 11),
                        Text("4.5",
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 12,
                            )),
                        SizedBox(width: 5),
                        RatingBar.readOnly(
                          initialRating: 4.5,
                          isHalfAllowed: true,
                          halfFilledIcon: Icons.star_half,
                          filledIcon: Icons.star,
                          filledColor: Color(0xFF23CB7E),
                          emptyIcon: Icons.star_border,
                          size: 12,
                        ),
                        SizedBox(width: 34),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("R\$ 100,00 ",
                                style: TextStyle(
                                    color: Color(0xFF23CB7E),
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold)),
                            SizedBox(height: 3),
                            Text("Por dia: 1 dia",
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 12,
                                )),
                          ],
                        )
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
