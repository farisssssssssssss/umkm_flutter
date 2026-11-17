
class UmkmModel {
  final int id;
  final String namaUmkm;
  final String pemilik;
  final String alamat;
  final String kategori;
  final String kontak;
  final String? createdAt;
  final String? updatedAt;

  UmkmModel({
    required this.id,
    required this.namaUmkm,
    required this.pemilik,
    required this.alamat,
    required this.kategori,
    required this.kontak,
    this.createdAt,
    this.updatedAt,
  });

  factory UmkmModel.fromJson(Map<String, dynamic> json) {
    return UmkmModel(
      id: int.parse(json['id'].toString()),
      namaUmkm: json['nama_umkm']?.toString() ?? '',
      pemilik: json['pemilik']?.toString() ?? '',
      alamat: json['alamat']?.toString() ?? '',
      kategori: json['kategori']?.toString() ?? '',
      kontak: json['kontak']?.toString() ?? '',
      createdAt: json['created_at']?.toString(),
      updatedAt: json['updated_at']?.toString(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'nama_umkm': namaUmkm,
      'pemilik': pemilik,
      'alamat': alamat,
      'kategori': kategori,
      'kontak': kontak,
    };
  }
}
