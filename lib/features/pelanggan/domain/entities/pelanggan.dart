class Pelanggan {
  final String id;
  final String nama;
  final String noHp;
  final String? alamat;
  final String jenisIdentitas;
  final String noIdentitas;
  final String? fotoIdentitas;
  final DateTime createdAt;

  const Pelanggan({
    required this.id,
    required this.nama,
    required this.noHp,
    this.alamat,
    required this.jenisIdentitas,
    required this.noIdentitas,
    this.fotoIdentitas,
    required this.createdAt,
  });
}
