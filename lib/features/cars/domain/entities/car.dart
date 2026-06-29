class Car {
  final String id;
  final String namaMobil;
  final String tipe;
  final int tahun;
  final String platNomor;
  final double hargaSewaPerhari;
  final String statusMobil;
  final DateTime createdAt;

  const Car({
    required this.id,
    required this.namaMobil,
    required this.tipe,
    required this.tahun,
    required this.platNomor,
    required this.hargaSewaPerhari,
    required this.statusMobil,
    required this.createdAt,
  });
}
