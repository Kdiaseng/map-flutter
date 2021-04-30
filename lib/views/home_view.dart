import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_map_app/controllers/home_controller.dart';
import 'package:flutter_map_app/models/parking_model.dart';
import 'package:flutter_map_app/utils/permissions_manager.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:rating_bar/rating_bar.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';
import 'package:search_map_place/search_map_place.dart';

class HomeView extends StatefulWidget {
  @override
  _HomeViewState createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  final homeController = HomeController();
  Position _currentPosition = Position();

  Set<Marker> _markers = {};
  BitmapDescriptor mapMarker;
  Completer<GoogleMapController> _controller = Completer();
  final ItemScrollController itemScrollController = ItemScrollController();
  final ItemPositionsListener itemPositionsListener =
  ItemPositionsListener.create();

  @override
  void initState() {
    super.initState();
    PermissionManager().determinePosition();
    _loadParkingLots();
    setCustomMarker();
  }

  _start() {
    return Container();
  }

  _loading() {
    return Center(child: CircularProgressIndicator());
  }

  _error() {
    return Center(
      child: ElevatedButton(
        onPressed: () {
          homeController.getParkingLots();
        },
        child: Text('Tentar novamente'),
      ),
    );
  }

  stateManagement(HomeState state) {
    switch (state) {
      case HomeState.start:
        return _start();
      case HomeState.loading:
        return _loading();
      case HomeState.error:
        return _error();
      case HomeState.success:
        return Stack(
          children: [
            _getGoogleMaps(context),
            _parkingLots(context),
            _searchPlace(),
            _contentButtons()
          ],
        );
        break;
      default:
    }
  }

  Widget _contentButtons() {
    return Align(
      alignment: Alignment.bottomRight,
      child: Column(
        children: [
          button(_goCurrentPosition, Icons.location_searching),
        ],
      ),
    );
  }

  _onAddMarker() {
    setState(() {
      _markers.add(
        Marker(
          markerId: MarkerId("current_location"),
          position: LatLng(_currentPosition.latitude, _currentPosition.longitude),
          infoWindow: InfoWindow(
            title: 'Current Location',
            snippet: 'Campos Sales',
          ),
          icon: BitmapDescriptor.defaultMarker,
        ),
      );
    });
  }

  _goCurrentPosition() async {
    await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.best,
        forceAndroidLocationManager: true)
        .then((Position position) =>
    {
      setState(() {
        _currentPosition = position;
        _gotoLocation(position.latitude, position.longitude);
        _onAddMarker();
      })
    });
  }

  _loadParkingLots() {
    homeController.getParkingLots();
  }

  _loadMarker() {
    homeController.parkingLots.forEach((parking) {
      _markers.add(
        Marker(
            onTap: () {
              _selectedItem(parking.id);
            },
            markerId: MarkerId(parking.id.toString()),
            position: LatLng(
                parking.latitude != null
                    ? parking.latitude
                    : -3.006669087006096,
                parking.longitude != null
                    ? parking.longitude
                    : -60.036741948623686),
            icon: mapMarker),
      );
    });
  }


  Widget button(Function function, IconData icon) {
    return FloatingActionButton(
      onPressed: function,
      materialTapTargetSize: MaterialTapTargetSize.padded,
      backgroundColor: Colors.white,
      child: Icon(
        icon,
        size: 32.0,
      ),
    );
  }

  void setCustomMarker() async {
    BitmapDescriptor.fromAssetImage(
        ImageConfiguration(size: Size(48, 48)), 'assets/available.png')
        .then((onValue) {
      mapMarker = onValue;
    });
  }

  void _onMapCreated(GoogleMapController controller) {
    _controller.complete(controller);
    setState(() {
      _loadMarker();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: AnimatedBuilder(
          animation: homeController.state,
          builder: (context, child) =>
              stateManagement(homeController.state.value),
        ),
      ),
    );
  }

  _selectedItem(int id) {
    var index =
    homeController.parkingLots.indexWhere((element) => element.id == id);
    itemScrollController.scrollTo(
        index: index,
        duration: Duration(seconds: 2),
        curve: Curves.easeInOutCubic);
  }

  Widget _searchPlace() {
    return Align(
      alignment: Alignment.topCenter,
      child: SearchMapPlaceWidget(
        radius: 30000,
        placeholder: "Digite o endereço",
        apiKey: "AIzaSyCULCZ4hkchX9u0sggf5LCwZ2oOTAcM10s",
        language: 'pt-BR',
        placeType: PlaceType.address,
        location: LatLng(-3.006669087006096, -60.036741948623686),
        onSelected: (Place place) async {
          final geolocation = await place.geolocation;
          final GoogleMapController controller = await _controller.future;
          controller
              .animateCamera(CameraUpdate.newLatLng(geolocation.coordinates));
          controller.animateCamera(
              CameraUpdate.newLatLngBounds(geolocation.bounds, 0));
        },
      ),
    );
  }

  Widget _getGoogleMaps(BuildContext context) {
    return Container(
      height: MediaQuery
          .of(context)
          .size
          .height,
      width: MediaQuery
          .of(context)
          .size
          .width,
      child: GoogleMap(
        onMapCreated: _onMapCreated,
        markers: _markers,
        myLocationEnabled: false,
        myLocationButtonEnabled: true,
        zoomControlsEnabled: false,
        initialCameraPosition: CameraPosition(
            target: LatLng(-3.006669087006096, -60.036741948623686), zoom: 15),
      ),
    );
  }

  Widget _parkingLots(BuildContext context) {
    return Align(
      alignment: Alignment.bottomLeft,
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 20.0),
        height: 200,
        child: ScrollablePositionedList.builder(
          itemCount: homeController.parkingLots.length,
          scrollDirection: Axis.horizontal,
          itemBuilder: (context, index) =>
              _parkingBox(
                homeController.parkingLots[index],
              ),
          itemScrollController: itemScrollController,
          itemPositionsListener: itemPositionsListener,
        ),
      ),
    );
  }

  Widget _parkingBox(ParkingModel parking) {
    return GestureDetector(
      onTap: () {
        if (parking.longitude != null && parking.latitude != null) {
          _gotoLocation(parking.latitude, parking.longitude);
        }
      },
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Row(
          children: [
            SizedBox(width: 8.0),
            Container(
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
                          parking.nameFantasia != null
                              ? parking.nameFantasia
                              : "---",
                          style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                              fontSize: 21.0),
                        ),
                        Container(
                          width: 315,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  Icon(Icons.room_outlined),
                                  SizedBox(width: 5),
                                  Column(
                                    crossAxisAlignment:
                                    CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                          parking.address.street != null
                                              ? parking.address.street
                                              : "----",
                                          style: TextStyle(
                                              color: Colors.black54,
                                              fontSize: 16)),
                                      Text(
                                          parking.address.city != null
                                              ? "${parking.address
                                              .city} - ${parking.address
                                              .state}, 69067-080"
                                              : "----",
                                          style: TextStyle(
                                              color: Colors.black54,
                                              fontSize: 16))
                                    ],
                                  ),
                                ],
                              ),
                              IconButton(
                                  icon: Icon(Icons.favorite_border),
                                  onPressed: () {})
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
                                        fontSize: 16,
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
                                        fontSize: 16,
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
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  Text(
                                    parking.qtdVagasDisponivel.toString(),
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 16,
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
                                      fontSize: 21,
                                      fontWeight: FontWeight.bold)),
                              SizedBox(width: 11),
                              Text("4.5",
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 16,
                                  )),
                              SizedBox(width: 5),
                              RatingBar.readOnly(
                                initialRating: 4.5,
                                isHalfAllowed: true,
                                halfFilledIcon: Icons.star_half,
                                filledIcon: Icons.star,
                                filledColor: Color(0xFF23CB7E),
                                emptyIcon: Icons.star_border,
                                size: 16,
                              ),
                              SizedBox(width: 34),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text("R\$ 100,00 ",
                                      style: TextStyle(
                                          color: Color(0xFF23CB7E),
                                          fontSize: 21,
                                          fontWeight: FontWeight.bold)),
                                  SizedBox(height: 3),
                                  Text("Por dia: 1 dia",
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 16,
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
          ],
        ),
      ),
    );
  }

  Future<void> _gotoLocation(double lat, double long) async {
    final GoogleMapController controller = await _controller.future;
    controller.animateCamera(CameraUpdate.newCameraPosition((CameraPosition(
        target: LatLng(lat, long), zoom: 15, tilt: 50, bearing: 45))));
  }
}
