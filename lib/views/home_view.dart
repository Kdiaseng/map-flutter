import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_map_app/controllers/home_controller.dart';
import 'package:flutter_map_app/models/parking_model.dart';
import 'package:flutter_map_app/utils/permissions_manager.dart';
import 'package:flutter_map_app/views/parking_card_widget.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';
import 'package:search_map_place/search_map_place.dart';

class HomeView extends StatefulWidget {
  @override
  _HomeViewState createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  final homeController = HomeController();
  Position _currentPosition = Position();
  bool isShowContentParking = false;

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
      child: Container(
        height: 400,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              buttonListParking(_showListParking, Icons.list),
              SizedBox(height: 15),
              buttonCurrentLocate(_goCurrentPosition, Icons.my_location),
            ],
          ),
        ),
      ),
    );
  }

  _onAddMarker() {
    if(mounted)setState(() {
      _markers.add(
        Marker(
          markerId: MarkerId("current_location"),
          position:
              LatLng(_currentPosition.latitude, _currentPosition.longitude),
          infoWindow: InfoWindow(
            title: 'Current Location',
            snippet: 'Campos Sales',
          ),
          icon: BitmapDescriptor.defaultMarker,
        ),
      );
    });
  }

  _showListParking() {}

  _goCurrentPosition() async {
    await Geolocator.getCurrentPosition(
            desiredAccuracy: LocationAccuracy.best,
            forceAndroidLocationManager: true)
        .then((Position position) => {
              if(mounted)setState(() {
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
              _showOrHideContentParking(true);
              // _selectedItem(parking.id);
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

  _showOrHideContentParking(bool on){
    if(mounted){
      setState(() {
        isShowContentParking = on;
      });
    }
  }

  Widget buttonListParking(Function function, IconData icon) {
    return FloatingActionButton(
      onPressed: function,
      materialTapTargetSize: MaterialTapTargetSize.padded,
      backgroundColor: Colors.white,
      child: Icon(
        icon,
        color: Color(0xFF23CB7E),
        size: 32.0,
      ),
    );
  }

  Widget buttonCurrentLocate(Function function, IconData icon) {
    return FloatingActionButton(
      onPressed: function,
      materialTapTargetSize: MaterialTapTargetSize.padded,
      backgroundColor: Colors.white,
      mini: true,
      child: Icon(
        icon,
        color: Colors.black,
        size: 24.0,
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
    if(mounted) setState(() {
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
    if(isShowContentParking){
      var index =
      homeController.parkingLots.indexWhere((element) => element.id == id);
      itemScrollController.scrollTo(
          index: index,
          duration: Duration(seconds: 2),
          curve: Curves.easeInOutCubic);
    }
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
      height: MediaQuery.of(context).size.height,
      width: MediaQuery.of(context).size.width,
      child: GoogleMap(
        onTap: (LatLng latLng) {
          _showOrHideContentParking(false);
        },
        onMapCreated: _onMapCreated,
        markers: _markers,
        myLocationEnabled: true,
        myLocationButtonEnabled: true,
        zoomControlsEnabled: false,
        initialCameraPosition: CameraPosition(
            target: LatLng(-3.006669087006096, -60.036741948623686), zoom: 15),
      ),
    );
  }

  Widget _parkingLots(BuildContext context) {
    return Visibility(
      visible: isShowContentParking,
      child: Align(
        alignment: Alignment.bottomLeft,
        child: Container(
          margin: EdgeInsets.symmetric(vertical: 20.0),
          height: 200,
          child: ScrollablePositionedList.builder(
            itemCount: homeController.parkingLots.length,
            scrollDirection: Axis.horizontal,
            itemBuilder: (context, index) => ParkingCardWidget(
              parking: homeController.parkingLots[index],
              onFavorite: (ParkingModel parking) {},
              onTap: (ParkingModel parking) =>
                  _gotoLocation(parking.latitude, parking.longitude),
            ),
            itemScrollController: itemScrollController,
            itemPositionsListener: itemPositionsListener,
          ),
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
