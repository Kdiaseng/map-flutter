class ParkingModel {
  int id;
  double longitude;
  double latitude;

  String nameFantasia;
  int qtdVagas;
  int qtdVagasDisponivel;

  // AddressModel address;
  // Payment paymentForm;

  ParkingModel(
      {this.id,
      this.longitude,
      this.latitude,
      this.nameFantasia,
      this.qtdVagas,
      this.qtdVagasDisponivel});

  ParkingModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    longitude = json['longitude'];
    latitude = json['latitude'];
    nameFantasia = json['nameFantasia'];
    qtdVagas = json['qtdVagas'];
    qtdVagasDisponivel = json['qtdVagasDisponivel'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['longitude'] = this.longitude;
    data['latitude'] = this.latitude;
    data['nameFantasia'] = this.nameFantasia;
    data['qtdVagas'] = this.qtdVagas;
    data['qtdVagasDisponivel'] = this.qtdVagasDisponivel;
    return data;
  }
}
