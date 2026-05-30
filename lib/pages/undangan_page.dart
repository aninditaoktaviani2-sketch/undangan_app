import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class UndanganPage extends StatefulWidget {
  const UndanganPage({super.key});

  @override
  State<UndanganPage> createState() => _UndanganPageState();
}

class _UndanganPageState extends State<UndanganPage> {
  final TextEditingController namaController = TextEditingController();
  final TextEditingController ucapanController = TextEditingController();

  final CollectionReference ucapanRef =
      FirebaseFirestore.instance.collection('ucapan');

  String? selectedId;

  // CREATE
  Future<void> tambahUcapan() async {
    if (namaController.text.isEmpty || ucapanController.text.isEmpty) return;

    await ucapanRef.add({
      'nama': namaController.text,
      'ucapan': ucapanController.text,
      'waktu': Timestamp.now(),
    });

    namaController.clear();
    ucapanController.clear();
  }

  // UPDATE
  Future<void> updateUcapan() async {
    if (selectedId == null) return;

    await ucapanRef.doc(selectedId).update({
      'nama': namaController.text,
      'ucapan': ucapanController.text,
    });

    namaController.clear();
    ucapanController.clear();
    selectedId = null;
  }

  // DELETE
  Future<void> deleteUcapan(String id) async {
    await ucapanRef.doc(id).delete();
  }

  Widget bunga(double size) {
    return Icon(
      Icons.local_florist,
      color: Colors.white.withOpacity(0.4),
      size: size,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF8B6B4A),

      appBar: AppBar(
        backgroundColor: const Color(0xFF8B6B4A),
        elevation: 0,
        centerTitle: true,

        title: const Text(
          "Wedding Invitation",
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),

        actions: [

          IconButton(
            icon: const Icon(Icons.logout, color: Colors.white),

            onPressed: () async {

              await GoogleSignIn().signOut();
              await FirebaseAuth.instance.signOut();

            },
          ),

        ],
      ),

      body: Stack(
        children: [

          // HIASAN POJOK
          Positioned(top: 30, left: 20, child: bunga(50)),
          Positioned(top: 30, right: 20, child: bunga(50)),
          Positioned(bottom: 30, left: 20, child: bunga(50)),
          Positioned(bottom: 30, right: 20, child: bunga(50)),

          // DEKOR ATAS
          Positioned(
            top: 0,
            left: 0,
            right: 0,
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

          // PAGE VIEW
          PageView(
            scrollDirection: Axis.vertical,
            children: [

              // PAGE 1
              Center(
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [

                      Text(
                        "THE WEDDING",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 24,
                          letterSpacing: 3,
                        ),
                      ),

                      SizedBox(height: 25),

                      Text(
                        "Zhafran\n&\nAlkayran",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 38,
                          fontStyle: FontStyle.italic,
                          fontWeight: FontWeight.bold,
                        ),
                      ),

                      SizedBox(height: 25),

                      Text(
                        "20 Desember 2026",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                        ),
                      ),

                      SizedBox(height: 10),

                      Text(
                        "08.00 WIB - Selesai",
                        style: TextStyle(
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // PAGE 2 MEMPELAI
              Center(
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [

                      Text(
                        "MEMPELAI PRIA",
                        style: TextStyle(
                          color: Colors.white,
                          letterSpacing: 2,
                        ),
                      ),

                      SizedBox(height: 15),

                      Text(
                        "Zhafran Arga Dirgantara",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 30,
                          fontStyle: FontStyle.italic,
                          fontWeight: FontWeight.bold,
                        ),
                      ),

                      SizedBox(height: 10),

                      Text(
                        "Putra Bpk. Ahmad & Ibu Sinta",
                        style: TextStyle(color: Colors.white),
                      ),

                      SizedBox(height: 50),

                      Text(
                        "MEMPELAI WANITA",
                        style: TextStyle(
                          color: Colors.white,
                          letterSpacing: 2,
                        ),
                      ),

                      SizedBox(height: 15),

                      Text(
                        "Alkayran Jeng Ayu",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 30,
                          fontStyle: FontStyle.italic,
                          fontWeight: FontWeight.bold,
                        ),
                      ),

                      SizedBox(height: 10),

                      Text(
                        "Putri Bpk. Danu & Ibu Rani",
                        style: TextStyle(color: Colors.white),
                      ),
                    ],
                  ),
                ),
              ),

              // PAGE 3
              SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    children: [

                      const SizedBox(height: 40),

                      const Text(
                        "UCAPAN TAMU",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),

                      const SizedBox(height: 20),

                      TextField(
                        controller: namaController,
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: Colors.white,
                          hintText: "Nama Anda",
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                        ),
                      ),

                      const SizedBox(height: 15),

                      TextField(
                        controller: ucapanController,
                        maxLines: 3,
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: Colors.white,
                          hintText: "Tulis ucapan terbaik...",
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                        ),
                      ),

                      const SizedBox(height: 15),

                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [

                          ElevatedButton(
                            onPressed: tambahUcapan,
                            child: const Text("CREATE"),
                          ),

                          ElevatedButton(
                            onPressed: updateUcapan,
                            child: const Text("UPDATE"),
                          ),
                        ],
                      ),

                      const SizedBox(height: 30),

                      // LOKASI
                      Container(
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.15),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: const Column(
                          children: [

                            Text(
                              "📍 LOKASI ACARA",
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 18,
                              ),
                            ),

                            SizedBox(height: 10),

                            Text(
                              "Hotel Aston Cirebon",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                              ),
                            ),

                            SizedBox(height: 5),

                            Text(
                              "08.00 WIB - Selesai",
                              style: TextStyle(
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 25),

                      // WEDDING GIFT
                      Container(
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.15),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: const Column(
                          children: [

                            Text(
                              "🎁 WEDDING GIFT",
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 18,
                              ),
                            ),

                            SizedBox(height: 15),

                            Text(
                              "BCA - Alkayran Jeng Ayu",
                              style: TextStyle(color: Colors.white),
                            ),

                            Text(
                              "1234567890",
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),

                            SizedBox(height: 15),

                            Text(
                              "BRI - Zhafran Arga Dirgantara",
                              style: TextStyle(color: Colors.white),
                            ),

                            Text(
                              "0987654321",
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),

                            SizedBox(height: 15),

                            Text(
                              "DANA - Alkayran",
                              style: TextStyle(color: Colors.white),
                            ),

                            Text(
                              "081234567890",
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 30),

                      // REALTIME UCAPAN
                      StreamBuilder<QuerySnapshot>(
                        stream: ucapanRef
                            .orderBy('waktu', descending: true)
                            .snapshots(),

                        builder: (context, snapshot) {

                          if (!snapshot.hasData) {
                            return const CircularProgressIndicator();
                          }

                          final data = snapshot.data!.docs;

                          return ListView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: data.length,

                            itemBuilder: (context, i) {

                              final item = data[i];

                              return Card(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(15),
                                ),

                                child: ListTile(
                                  title: Text(item['nama']),
                                  subtitle: Text(item['ucapan']),

                                  trailing: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [

                                      IconButton(
                                        icon: const Icon(Icons.edit),

                                        onPressed: () {

                                          namaController.text =
                                              item['nama'];

                                          ucapanController.text =
                                              item['ucapan'];

                                          selectedId = item.id;
                                        },
                                      ),

                                      IconButton(
                                        icon: const Icon(Icons.delete),

                                        onPressed: () {
                                          deleteUcapan(item.id);
                                        },
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          );
                        },
                      ),

                      const SizedBox(height: 50),
                    ],
                  ),
                ),
              ),

              // PAGE 4
              const Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [

                    Text(
                      "Terima Kasih 🤍",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    SizedBox(height: 15),

                    Text(
                      "Atas doa dan kehadirannya",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}