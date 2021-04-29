import 'package:dio/dio.dart';
import 'package:flutter_map_app/models/parking_model.dart';
import 'package:flutter_map_app/models/response_parking.dart';

class ParkingRepository {
  final url =
      "http://172.100.10.101:8362/ws-parking-driver/api/driver/pagination";

  Future<List<ParkingModel>> getParkingLots() async {
    final response = await Dio().get(url);
    final responseParkingDynamic = response.data;
    final responseParking = ResponseParking.fromJson(responseParkingDynamic);
    return responseParking.content;
  }
}
