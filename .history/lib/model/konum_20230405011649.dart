class Konum {
  String kullaniciId;
  double latitude;
  double longitude;
  String tarih;

  Konum({required this.kullaniciId, this.latitude, this.longitude, this.tarih});

  Map<String, dynamic> toMap() {
    return {
      'kullaniciId': kullaniciId,
      'latitude': latitude,
      'longitude': longitude,
      'tarih': tarih,
    };
  }
}