class UcapanModel {
  final String action;
  final String nama;
  final String isi;
  final String waktu;

  UcapanModel({
    required this.action,
    required this.nama,
    required this.isi,
    required this.waktu,
  });

  factory UcapanModel.fromJson(Map<String, dynamic> json) {
    return UcapanModel(
      action: json['action']?.toString() ?? '',
      nama: json['nama']?.toString() ?? '',
      isi: json['isi']?.toString() ?? '',
      waktu: json['waktu']?.toString() ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'action': action,
      'nama': nama,
      'isi': isi,
      'waktu': waktu,
    };
  }
}