
class Konum {
  double latitude;
  double longitude;
  String tarih;

  Konum({required this.latitude,required this.longitude,required this.tarih});

  Map<String, dynamic> toMap() {
    return {
      'latitude': latitude,
      'longitude': longitude,
      'tarih': tarih,
    };
  }
}