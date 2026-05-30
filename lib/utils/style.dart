import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppStyle {

  static const Color cream = Color(0xFFFFF3E6);
  static const Color mahogany = Color(0xFF4E1F1F);

  // ✨ TULISAN UTAMA (TEGAK BERSAMBUNG)
  static TextStyle script = GoogleFonts.dancingScript(
    fontSize: 34,
    fontWeight: FontWeight.w600,
    color: mahogany,
  );

  // 📝 TEKS NORMAL
  static TextStyle normal = GoogleFonts.poppins(
    fontSize: 15,
    height: 1.4,
    color: mahogany,
  );

  // 🏷 LABEL (MEMPELAI / BAPAK IBU)
  static TextStyle label = GoogleFonts.poppins(
    fontSize: 13,
    fontWeight: FontWeight.w600,
    color: mahogany,
  );

  // 🔻 TEKS KECIL (ORTU / DETAIL)
  static TextStyle small = GoogleFonts.poppins(
    fontSize: 12,
    color: mahogany,
  );
}