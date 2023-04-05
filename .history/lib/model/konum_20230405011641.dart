class Location {
  double latitude;
  double longitude;
  String address;
  DateTime timestamp;

  Location({required this.latitude, required this.longitude, required this.address, required this.timestamp});

  // Firestore'a dönüştürme işlemi
  Map<String, dynamic> toMap() {
    return {
      'latitude': latitude,
      'longitude': longitude,
      'address': address,
      'timestamp': timestamp,
    };
  }
}
