
import 'package:flutter_map_app/models/parking_model.dart';
import 'package:flutter_map_app/repositories/parking_repository.dart';
import 'package:flutter/material.dart';

class HomeController {
  List<ParkingModel> parkingLots = [];
  final ParkingRepository _repository;

  final state = ValueNotifier<HomeState>(HomeState.start);

  HomeController([ParkingRepository repository])
      : _repository = repository ?? ParkingRepository();

  Future getParkingLots() async {
    state.value = HomeState.loading;
    try {
      parkingLots = await _repository.getParkingLots();
      state.value = HomeState.success;
    } catch (e) {
      state.value = HomeState.error;
    }
  }
}

enum HomeState { start, loading, success, error }
