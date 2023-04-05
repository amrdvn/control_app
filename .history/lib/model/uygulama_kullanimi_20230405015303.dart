class UygulamaKullanimi {
  String uygulamaAdi;
  Duration kullanilanSure;

  UygulamaKullanimi({required this.uygulamaAdi, required this.kullanilanSure});

  Map<String, dynamic> toMap() {
    return {
      'uygulamaAdi': uygulamaAdi,
      'kullanilanSure': kullanilanSure.inSeconds,
    };
  }
}