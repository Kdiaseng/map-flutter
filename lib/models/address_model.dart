class AddressModel {
   int id;
   String street;
   String number;
   String city;
   String state;

  AddressModel({this.id, this.street, this.number, this.city, this.state});


  AddressModel.fromJson(Map<String, dynamic> json){
     id = json['id'];
     street = json['street'];
     number = json['number'];
     city = json['city'];
     state = json['state'];
  }
}
