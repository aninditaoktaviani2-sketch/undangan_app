import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:url_launcher/url_launcher.dart';

import '../models/ucapan_model.dart';
import '../services/websocket_service.dart';

class UndanganPage extends StatefulWidget {
  const UndanganPage({super.key});

  @override
  State<UndanganPage> createState() => _UndanganPageState();
}

class _UndanganPageState extends State<UndanganPage> {
  final TextEditingController namaController = TextEditingController();
  final TextEditingController ucapanController = TextEditingController();

  final WebSocketService _socketService = WebSocketService();
  List<UcapanModel> ucapanList = [];
  String? selectedWaktuId;

  int totalHadir = 0;
  int totalTidakHadir = 0;

  @override
  void initState() {
    super.initState();
    _initWebSocket();
  }

  void _initWebSocket() {
    _socketService.onMessageReceived = (UcapanModel dataModel) {
      if (!mounted) return;
      setState(() {
        if (dataModel.action == "create") {
          ucapanList.insert(0, dataModel);
        } else if (dataModel.action == "update") {
          int index = ucapanList.indexWhere((element) => element.waktu == dataModel.waktu);
          if (index != -1) {
            ucapanList[index] = dataModel;
          }
        } else if (dataModel.action == "delete") {
          ucapanList.removeWhere((element) => element.waktu == dataModel.waktu);
        }
      });
    };
    _socketService.connect();
  }

  void kirimRSVP(String status) {
    if (namaController.text.isEmpty) {
      _tampilkanSnackbar("Isi nama terlebih dahulu");
      return;
    }
    FocusScope.of(context).unfocus();
    setState(() {
      if (status == "Hadir") totalHadir++;
      if (status == "Tidak Hadir") totalTidakHadir++;
    });
    _tampilkanSnackbar("Konfirmasi $status berhasil");
  }

  void prosesSimpanAtauUbah() {
    if (namaController.text.isEmpty || ucapanController.text.isEmpty) {
      _tampilkanSnackbar("Nama dan ucapan tidak boleh kosong!");
      return;
    }
    FocusScope.of(context).unfocus();

    if (selectedWaktuId == null) {
      _socketService.kirimPesan("create", namaController.text, ucapanController.text);
      _tampilkanSnackbar("Ucapan berhasil dikirim!");
    } else {
      _socketService.kirimPesan("update", namaController.text, ucapanController.text, waktuLama: selectedWaktuId);
      _tampilkanSnackbar("Ucapan berhasil diperbarui!");
      selectedWaktuId = null;
    }

    namaController.clear();
    ucapanController.clear();
  }

  void hapusUcapan(UcapanModel item) {
    FocusScope.of(context).unfocus();
    _socketService.kirimPesan("delete", item.nama, item.isi, waktuLama: item.waktu);
    _tampilkanSnackbar("Ucapan berhasil dihapus");
  }

  Future<void> bukaMaps() async {
    final Uri url = Uri.parse("https://maps.app.goo.gl/LpuAhiD26WKaA57UA");
    if (await canLaunchUrl(url)) {
      await launchUrl(url, mode: LaunchMode.externalApplication);
    } else {
      _tampilkanSnackbar("Tidak bisa membuka Google Maps");
    }
  }

  void _tampilkanSnackbar(String pesan) {
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(pesan)));
    }
  }

  Widget hiasanBunga(double size) {
    return Icon(Icons.local_florist, color: Colors.white.withOpacity(0.4), size: size);
  }

  @override
  void dispose() {
    namaController.dispose();
    ucapanController.dispose();
    _socketService.disconnect();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        backgroundColor: const Color(0xFF8B6B4A),
        appBar: AppBar(
          backgroundColor: const Color(0xFF8B6B4A),
          elevation: 0,
          centerTitle: true,
          title: const Text(
            "Wedding Invitation",
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
        ),
        body: Stack(
          children: [
            Positioned(top: 30, left: 20, child: hiasanBunga(50)),
            Positioned(top: 30, right: 20, child: hiasanBunga(50)),
            Positioned(bottom: 30, left: 20, child: hiasanBunga(50)),
            Positioned(bottom: 30, right: 20, child: hiasanBunga(50)),

            Positioned(
              top: 0, left: 0, right: 0,
              child: Container(
                height: 120,
                decoration: const BoxDecoration(
                  color: Color(0xFFE8D3B0),
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(60),
                    bottomRight: Radius.circular(60),
                  ),
                ),
              ),
            ),

            PageView(
              scrollDirection: Axis.vertical,
              children: [
                
                // SLIDE 1: Pembuka
                Center(
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const [
                        Text("THE WEDDING", style: TextStyle(color: Colors.white, fontSize: 24, letterSpacing: 3)),
                        SizedBox(height: 25),
                        Text("Zhafran\n&\nAlkayran", textAlign: TextAlign.center, style: TextStyle(color: Colors.white, fontSize: 38, fontStyle: FontStyle.italic, fontWeight: FontWeight.bold)),
                        SizedBox(height: 25),
                        Text("20 Desember 2026", style: TextStyle(color: Colors.white, fontSize: 18)),
                        SizedBox(height: 10),
                        Text("08.00 WIB - Selesai", style: TextStyle(color: Colors.white)),
                      ],
                    ),
                  ),
                ),

                // SLIDE 2: Mempelai
                Center(
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const [
                        Text("MEMPELAI PRIA", style: TextStyle(color: Colors.white, letterSpacing: 2)),
                        SizedBox(height: 15),
                        Text("Zhafran Arga Dirgantara", textAlign: TextAlign.center, style: TextStyle(color: Colors.white, fontSize: 30, fontStyle: FontStyle.italic, fontWeight: FontWeight.bold)),
                        SizedBox(height: 10),
                        Text("Putra Bpk. Ahmad & Ibu Sinta", style: TextStyle(color: Colors.white70)),
                        SizedBox(height: 50),
                        Text("MEMPELAI WANITA", style: TextStyle(color: Colors.white, letterSpacing: 2)),
                        SizedBox(height: 15),
                        Text("Alkayran Jeng Ayu", textAlign: TextAlign.center, style: TextStyle(color: Colors.white, fontSize: 30, fontStyle: FontStyle.italic, fontWeight: FontWeight.bold)),
                        SizedBox(height: 10),
                        Text("Putri Bpk. Danu & Ibu Rani", style: TextStyle(color: Colors.white70)),
                      ],
                    ),
                  ),
                ),

                // SLIDE 3: WebSocket CRUD Ucapan & RSVP
                SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(20, 140, 20, 40),
                    child: Column(
                      children: [
                        Text(
                          selectedWaktuId == null ? "UCAPAN & RSVP" : "UBAH UCAPAN",
                          style: const TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 20),
                        TextField(
                          controller: namaController,
                          decoration: InputDecoration(filled: true, fillColor: Colors.white, hintText: "Nama Anda", border: OutlineInputBorder(borderRadius: BorderRadius.circular(15))),
                        ),
                        const SizedBox(height: 15),
                        TextField(
                          controller: ucapanController,
                          maxLines: 2,
                          decoration: InputDecoration(filled: true, fillColor: Colors.white, hintText: "Tulis ucapan terbaik...", border: OutlineInputBorder(borderRadius: BorderRadius.circular(15))),
                        ),
                        const SizedBox(height: 15),
                        
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            if (selectedWaktuId != null)
                              TextButton(
                                onPressed: () {
                                  setState(() {
                                    selectedWaktuId = null;
                                    namaController.clear();
                                    ucapanController.clear();
                                  });
                                },
                                child: const Text("Batal", style: TextStyle(color: Colors.white70)),
                              ),
                            ElevatedButton(
                              onPressed: prosesSimpanAtauUbah,
                              child: Text(selectedWaktuId == null ? "CREATE" : "SAVE UPDATE"),
                            ),
                          ],
                        ),
                        const SizedBox(height: 20),
                        
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
                              onPressed: () => kirimRSVP("Hadir"),
                              child: const Text("Hadir", style: TextStyle(color: Colors.white)),
                            ),
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                              onPressed: () => kirimRSVP("Tidak Hadir"),
                              child: const Text("Tidak Hadir", style: TextStyle(color: Colors.white)),
                            ),
                          ],
                        ),
                        
                        Padding(
                          padding: const EdgeInsets.only(top: 12),
                          child: Text(
                            "Total RSVP -> Hadir: $totalHadir  |  Tidak Hadir: $totalTidakHadir",
                            textAlign: TextAlign.center,
                            style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                          ),
                        ),
                        const SizedBox(height: 20),

                        ucapanList.isEmpty
                            ? const Text("Belum ada ucapan.", style: TextStyle(color: Colors.white70))
                            : ListView.builder(
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                itemCount: ucapanList.length,
                                itemBuilder: (context, i) {
                                  final item = ucapanList[i];
                                  return Card(
                                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                                    child: ListTile(
                                      title: Text(item.nama),
                                      subtitle: Text(item.isi),
                                      trailing: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          IconButton(
                                            icon: const Icon(Icons.edit, color: Colors.blue),
                                            onPressed: () {
                                              setState(() {
                                                namaController.text = item.nama;
                                                ucapanController.text = item.isi;
                                                selectedWaktuId = item.waktu;
                                              });
                                            },
                                          ),
                                          IconButton(
                                            icon: const Icon(Icons.delete, color: Colors.red),
                                            onPressed: () => hapusUcapan(item),
                                          ),
                                        ],
                                      ),
                                    ),
                                  );
                                },
                              ),
                      ],
                    ),
                  ),
                ),

                // SLIDE 4: Google Maps
                Center(
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(color: Colors.white.withOpacity(0.15), borderRadius: BorderRadius.circular(20)),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Text("📍 LOKASI ACARA", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 22)),
                          const SizedBox(height: 15),
                          const Text("Hotel Aston Cirebon", style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w500)),
                          const SizedBox(height: 5),
                          const Text("08.00 WIB - Selesai", style: TextStyle(color: Colors.white70)),
                          const SizedBox(height: 25),
                          ElevatedButton.icon(
                            onPressed: bukaMaps,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFFE8D3B0),
                              foregroundColor: const Color(0xFF8B6B4A),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
                            ),
                            icon: const Icon(Icons.location_on),
                            label: const Text("Buka Google Maps", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),

                // SLIDE 5: Copy Wedding Gift
                Center(
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(color: Colors.white.withOpacity(0.15), borderRadius: BorderRadius.circular(20)),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Text("🎁 WEDDING GIFT", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 22)),
                          const SizedBox(height: 5),
                          const Text("Klik pada nomor untuk menyalin", style: TextStyle(color: Colors.white60, fontSize: 12)),
                          const SizedBox(height: 20),

                          const Text("BCA - Alkayran Jeng Ayu", style: TextStyle(color: Colors.white70)),
                          InkWell(
                            onTap: () {
                              Clipboard.setData(const ClipboardData(text: "1234567890"));
                              _tampilkanSnackbar("Nomor rekening BCA berhasil disalin!");
                            },
                            child: const Padding(
                              padding: EdgeInsets.symmetric(vertical: 5),
                              child: Text("1234567890 📋", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 20, decoration: TextDecoration.underline)),
                            ),
                          ),
                          const SizedBox(height: 20),

                          const Text("BRI - Zhafran Arga Dirgantara", style: TextStyle(color: Colors.white70)),
                          InkWell(
                            onTap: () {
                              Clipboard.setData(const ClipboardData(text: "0987654321"));
                              _tampilkanSnackbar("Nomor rekening BRI berhasil disalin!");
                            },
                            child: const Padding(
                              padding: EdgeInsets.symmetric(vertical: 5),
                              child: Text("0987654321 📋", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 20, decoration: TextDecoration.underline)),
                            ),
                          ),
                          const SizedBox(height: 20),

                          const Text("DANA - Alkayran", style: TextStyle(color: Colors.white70)),
                          InkWell(
                            onTap: () {
                              Clipboard.setData(const ClipboardData(text: "081234567890"));
                              _tampilkanSnackbar("Nomor DANA berhasil disalin!");
                            },
                            child: const Padding(
                              padding: EdgeInsets.symmetric(vertical: 5),
                              child: Text("081234567890 📋", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 20, decoration: TextDecoration.underline)),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),

                // SLIDE 6: Penutup
                Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      Text("Terima Kasih 🤍", style: TextStyle(color: Colors.white, fontSize: 32, fontWeight: FontWeight.bold)),
                      SizedBox(height: 15),
                      Text("Atas doa dan kehadirannya", style: TextStyle(color: Colors.white, fontSize: 16)),
                    ],
                  ),
                ),

              ],
            ),
          ],
        ),
      ),
    );
  }
}