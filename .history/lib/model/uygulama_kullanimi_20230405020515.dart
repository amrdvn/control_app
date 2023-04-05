class Uygulama {
  String isim;
  Duration kullanımSuresi;

  Uygulama({required this.isim, required this.kullanımSuresi});

  Map<String, dynamic> toMap() {
    return {
      'isim': isim,
      'kullanımSuresi': kullanımSuresi.inSeconds,
    };
  }
}