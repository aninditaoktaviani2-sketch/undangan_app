import 'package:flutter/material.dart';

class UcapanProvider extends ChangeNotifier {
  List<Map<String, String>> dataUcapan = [];

  void tambah(String nama, String ucapan) {
    dataUcapan.add({"nama": nama, "ucapan": ucapan});
    notifyListeners();
  }

  void update(int index, String nama, String ucapan) {
    dataUcapan[index] = {"nama": nama, "ucapan": ucapan};
    notifyListeners();
  }

  void hapus(int index) {
    dataUcapan.removeAt(index);
    notifyListeners();
  }
}