import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

Widget days(date, String url, temp) {
  return Card(
    color: Colors.blueAccent,
    child: SizedBox(
      height: 100,
      width: 100,
      child: Column(
        children: [
          Text(
            date.toString(),
            style: GoogleFonts.inter(
                fontWeight: FontWeight.w500, fontSize: 20, color: Colors.white),
          ),
          Image.network(
            url,
            fit: BoxFit.cover,
            height: 70,
            width: 70,
          ),
          Text(
            temp.toString(),
            style: GoogleFonts.archivo(
              fontSize: 25,
              fontWeight: FontWeight.w600,
              color: Colors.white,
            ),
          )
        ],
      ),
    ),
  );
}
