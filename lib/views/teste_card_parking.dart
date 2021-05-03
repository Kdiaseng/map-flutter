import 'package:flutter/material.dart';
import 'package:flutter_map_app/models/address_model.dart';
import 'package:flutter_map_app/models/parking_model.dart';
import 'package:flutter_map_app/views/parking_card_widget.dart';

class TestCardParking extends StatelessWidget {


  @override
  Widget build(BuildContext context) {

    ParkingModel parking = new ParkingModel(
        id: 1,
        latitude: -3.006669087006096,
        longitude: -60.036741948623686,
        nameFantasia: "TESTANDO",
        qtdVagas: 5,
        qtdVagasDisponivel: 2);

    var address = new AddressModel(
      id: 22,
      number: "16",
      city: "Manaus",
      state: "AM",
      street: "AV. Testequarto Tapajos"
    );

    parking.address = address;


    return Container(
      height:  MediaQuery.of(context).size.height,
      width:  MediaQuery.of(context).size.width,
      child: Align(
        alignment: Alignment.bottomCenter,
        child: ParkingCardWidget(
          parking: parking,
          onFavorite: (parking) => {},
          onTap: (parking) => {},
        ),
      ),
    );
  }
}
