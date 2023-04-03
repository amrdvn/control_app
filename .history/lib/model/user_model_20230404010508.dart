class UserModel {
  String? uid;
  String? email;
  String? ad;
  String? soyad;

  UserModel({this.uid, this.email, this.ad, this.soyad});

  // receiving data from server
  factory UserModel.fromMap(map) {
    return UserModel(
      uid: map['uid'],
      email: map['email'],
      ad: map['Ad'],
      soyad: map['Soyad'],
    );
  }

  // sending data to our server
  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'email': email,
      'firstName': ad,
      'secondName': soyad,
    };
  }
}