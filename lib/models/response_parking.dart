import 'package:flutter_map_app/models/parking_model.dart';

class ResponseParking {
  List<ParkingModel> content;

  ResponseParking({this.content});

  ResponseParking.fromJson(Map<String, dynamic> json) {
    final list = json['content'] as List;
    content = list.map((json) => ParkingModel.fromJson(json)).toList();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['content'] = this.content;
    return data;
  }
}
