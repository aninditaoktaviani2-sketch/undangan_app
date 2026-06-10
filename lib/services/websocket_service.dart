import 'dart:convert';
import 'package:web_socket_channel/web_socket_channel.dart';
import '../models/ucapan_model.dart'; 

class WebSocketService {
  WebSocketChannel? _channel;
  
  // Callback untuk mengirim data ucapan ke UI
  Function(UcapanModel)? onMessageReceived;

  // 🌐 Sudah menggunakan IP Laptop kamu dengan port 8080
  final String _url = 'ws://192.168.1.8:8080'; 

  void connect() {
    try {
      _channel = WebSocketChannel.connect(Uri.parse(_url));

      _channel!.stream.listen((message) {
        if (onMessageReceived != null) {
          final Map<String, dynamic> data = jsonDecode(message);
          UcapanModel ucapanBaru = UcapanModel.fromJson(data);
          onMessageReceived!(ucapanBaru);
        }
      }, onError: (error) {
        print('WebSocket Error: $error');
      }, onDone: () {
        print('WebSocket Koneksi Terputus.');
      });
    } catch (e) {
      print('Gagal terhubung ke WebSocket: $e');
    }
  }

  // Fungsi kirim pesan yang sudah disinkronkan dengan tombol UI (Create, Update, Delete)
  void kirimPesan(String tipe, String nama, String isi, {String? waktuLama}) {
    if (_channel != null) {
      final dataKirim = {
        'action': tipe, 
        'nama': nama,
        'isi': isi,
        'waktu': waktuLama ?? DateTime.now().toIso8601String(),
      };
      _channel!.sink.add(jsonEncode(dataKirim));
    }
  }

  void disconnect() {
    _channel?.sink.close();
  }
}