import 'package:flutter/cupertino.dart';
import 'package:google_fonts/google_fonts.dart';

class AppLogo extends StatefulWidget {
  const AppLogo({super.key});

  @override
  State<AppLogo> createState() => _AppLogoState();
}

class _AppLogoState extends State<AppLogo> {
  @override
  Widget build(BuildContext context) {
    return Text(
      'FILMFLIX',
      style: TextStyle(
        fontFamily: GoogleFonts.interTight().fontFamily,
        color: const Color(0xFFFF0000),
        fontSize: 40,
        fontWeight: FontWeight.bold,
      ),
    );
  }
}
