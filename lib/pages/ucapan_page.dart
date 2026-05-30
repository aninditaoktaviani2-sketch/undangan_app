import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UcapanPage extends StatefulWidget {
  const UcapanPage({super.key});

  @override
  State<UcapanPage> createState() => _UcapanPageState();
}

class _UcapanPageState extends State<UcapanPage> {
  final TextEditingController namaController = TextEditingController();
  final TextEditingController ucapanController = TextEditingController();

  List<Map<String, String>> dataUcapan = [];

  int? editIndex;

  @override
  void initState() {
    super.initState();
    loadData();
  }

  // LOAD DATA
  void loadData() async {
    final prefs = await SharedPreferences.getInstance();
    final String? data = prefs.getString('ucapan');

    if (data != null) {
      final List decoded = jsonDecode(data);

      setState(() {
        dataUcapan = decoded
            .map((e) => Map<String, String>.from(e))
            .toList();
      });
    }
  }

  // SAVE DATA KE STORAGE
  void saveToStorage() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString('ucapan', jsonEncode(dataUcapan));
  }

  void simpanUcapan() {
    if (namaController.text.isEmpty || ucapanController.text.isEmpty) return;

    setState(() {
      if (editIndex == null) {
        // CREATE
        dataUcapan.add({
          "nama": namaController.text,
          "ucapan": ucapanController.text,
        });
      } else {
        // UPDATE
        dataUcapan[editIndex!] = {
          "nama": namaController.text,
          "ucapan": ucapanController.text,
        };
        editIndex = null;
      }

      namaController.clear();
      ucapanController.clear();
    });

    saveToStorage(); // 🔥 SIMPAN BIAR GAK HILANG
  }

  void editUcapan(int index) {
    setState(() {
      editIndex = index;
      namaController.text = dataUcapan[index]["nama"]!;
      ucapanController.text = dataUcapan[index]["ucapan"]!;
    });
  }

  void hapusUcapan(int index) {
    setState(() {
      dataUcapan.removeAt(index);
    });

    saveToStorage(); // 🔥 UPDATE STORAGE
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Ucapan Tamu"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: namaController,
              decoration: const InputDecoration(labelText: "Nama"),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: ucapanController,
              decoration: const InputDecoration(labelText: "Ucapan"),
            ),
            const SizedBox(height: 20),

            ElevatedButton(
              onPressed: simpanUcapan,
              child: Text(editIndex == null ? "Tambah Ucapan" : "Update Ucapan"),
            ),

            const SizedBox(height: 20),

            Expanded(
              child: ListView.builder(
                itemCount: dataUcapan.length,
                itemBuilder: (context, index) {
                  return Card(
                    child: ListTile(
                      title: Text(dataUcapan[index]["nama"]!),
                      subtitle: Text(dataUcapan[index]["ucapan"]!),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: const Icon(Icons.edit),
                            onPressed: () => editUcapan(index),
                          ),
                          IconButton(
                            icon: const Icon(Icons.delete),
                            onPressed: () => hapusUcapan(index),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}