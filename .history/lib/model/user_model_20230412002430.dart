class UserModel {
  String? uid;
  String? email;
  String? ad;
  String? soyad;
  String? token;

  UserModel({this.uid, this.email, this.ad, this.soyad, this.token});

  // receiving data from server
  factory UserModel.fromMap(map) {
    return UserModel(
      uid: map['uid'],
      email: map['email'],
      ad: map['Ad'],
      soyad: map['Soyad'],
      this.token
    );
  }

  // sending data to our server
  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'email': email,
      'Ad': ad,
      'Soyad': soyad,
    };
  }
}