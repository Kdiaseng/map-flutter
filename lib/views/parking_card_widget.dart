import 'package:flutter/material.dart';
import 'package:flutter_map_app/models/parking_model.dart';
import 'package:rating_bar/rating_bar.dart';

class ParkingCardWidget extends StatefulWidget {

  ParkingCardWidget({
    Key key,
    this.parking,
    this.onTap,
    this.onFavorite
  }) : super(key: key);


  final ParkingModel parking;

  final void Function(ParkingModel parking) onTap;

  final void Function (ParkingModel parking) onFavorite;

  @override
  _ParkingCardWidgetState createState() => _ParkingCardWidgetState();

}

class _ParkingCardWidgetState extends State<ParkingCardWidget> {
  bool isSelected = false;
  IconData icon = Icons.favorite_border;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (widget.parking.longitude != null &&
            widget.parking.latitude != null) {
          widget.onTap(widget.parking);
        }
      },
      child: Padding(
        padding: const EdgeInsets.all(3.0),
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
                          widget.parking.nameFantasia != null
                              ? widget.parking.nameFantasia
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
                                          widget.parking.address.street != null
                                              ? widget.parking.address.street
                                              : "----",
                                          style: TextStyle(
                                              color: Colors.black54,
                                              fontSize: 16)),
                                      Text(
                                          widget.parking.address.city != null
                                              ? "${widget.parking.address.city} - ${widget.parking.address.state}, 69067-080"
                                              : "----",
                                          style: TextStyle(
                                              color: Colors.black54,
                                              fontSize: 16))
                                    ],
                                  ),
                                ],
                              ),
                              IconButton(
                                  icon: Icon(icon),
                                  onPressed: () {
                                    setState(() {
                                      print("merda");
                                      // widget.onFavorite(widget.parking);
                                      isSelected = !isSelected;
                                      icon = isSelected
                                          ? Icons.favorite
                                          : Icons.favorite_border;
                                    });
                                  })
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
                                    widget.parking.qtdVagasDisponivel
                                        .toString(),
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
}
