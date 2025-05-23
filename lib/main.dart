import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:tinder_for_movies/screens/sign_in_screen.dart';

import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(
    const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: SignInScreen(),
    ),
  );
}
