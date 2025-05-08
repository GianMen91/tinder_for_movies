import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tinder_for_movies/screens/sign_in_screen.dart';

import '../screens/sign_up_screen.dart';

class NavigationRow extends StatelessWidget {
  final bool isFromSignIn;

  const NavigationRow({super.key, required this.isFromSignIn});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 40),
          child: InkWell(
            onTap: () {
              if (!isFromSignIn) {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => const SignInScreen()),
                );
              }
            },
            child: Text(
              'Sign In',
              style: TextStyle(
                fontFamily: GoogleFonts.interTight().fontFamily,
                color: !isFromSignIn
                    ? const Color(0xFF787777)
                    : const Color(0xFFFFFFFF),
                fontSize: 30,
              ),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 40),
          child: InkWell(
            onTap: () {
              if (isFromSignIn) {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => const SignUpScreen()),
                );
              }
            },
            child: Text(
              'Sign Up',
              style: TextStyle(
                fontFamily: GoogleFonts.interTight().fontFamily,
                color: isFromSignIn
                    ? const Color(0xFF787777)
                    : const Color(0xFFFFFFFF),
                fontSize: 30,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
