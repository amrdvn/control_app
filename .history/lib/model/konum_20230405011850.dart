class Konum {
  double latitude;
  double longitude;
  String tarih;

  Konum({required this.kullaniciId,required this.latitude,required this.longitude,required this.tarih});

  Map<String, dynamic> toMap() {
    return {
      'kullaniciId': kullaniciId,
      'latitude': latitude,
      'longitude': longitude,
      'tarih': tarih,
    };
  }
}