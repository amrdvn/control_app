class UserModel {
  String? uid;
  String? email;
  String? ad;
  String? soyad;
  String? token;

  UserModel({this.uid, this.email, this.ad, this.soyad, this.token});

  factory UserModel.fromMap(map) {
    return UserModel(
      uid: map['uid'],
      email: map['email'],
      ad: map['Ad'],
      soyad: map['Soyad'],
      token: map['token'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'email': email,
      'Ad': ad,
      'Soyad': soyad,
      'token': token,
    };
  }
}