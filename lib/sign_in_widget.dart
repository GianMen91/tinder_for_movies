import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tinder_for_movies/sign_up_widget.dart';

import 'home_page_widget.dart';


class SignInWidget extends StatefulWidget {
  const SignInWidget({super.key});

  static String routeName = 'SignIn';
  static String routePath = '/signIn';

  @override
  State<SignInWidget> createState() => _SignInWidgetState();
}

class _SignInWidgetState extends State<SignInWidget> {
  final _formKey = GlobalKey<FormState>();
  final scaffoldKey = GlobalKey<ScaffoldState>();

  // Form controllers
  late TextEditingController emailTextController;
  late FocusNode textFieldFocusNode1;

  late TextEditingController passwordTextController;
  late FocusNode textFieldFocusNode2;
  late bool passwordVisibility;

  @override
  void initState() {
    super.initState();
    emailTextController = TextEditingController();
    textFieldFocusNode1 = FocusNode();

    passwordTextController = TextEditingController();
    textFieldFocusNode2 = FocusNode();
    passwordVisibility = false;
  }

  @override
  void dispose() {
    emailTextController.dispose();
    textFieldFocusNode1.dispose();

    passwordTextController.dispose();
    textFieldFocusNode2.dispose();

    super.dispose();
  }

  // Method to handle sign in with email and password
  Future<void> signInWithEmail(BuildContext context) async {
    if (_formKey.currentState?.validate() ?? false) {
      try {
        await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: emailTextController.text,
          password: passwordTextController.text,
        );

        // Navigate to home page on success
        Navigator.of(context).pushReplacementNamed(HomePageWidget.routeName);
      } on FirebaseAuthException catch (e) {
        // Handle authentication errors
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(e.message ?? 'An error occurred during sign in'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
        FocusManager.instance.primaryFocus?.unfocus();
      },
      child: Scaffold(
        key: scaffoldKey,
        backgroundColor: Colors.black,
        appBar: AppBar(
          backgroundColor: Colors.black,
          automaticallyImplyLeading: false,
          elevation: 0,
        ),
        body: SafeArea(
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                Align(
                  alignment: const AlignmentDirectional(0, 0),
                  child: Padding(
                    padding: const EdgeInsetsDirectional.fromSTEB(0, 100, 0, 0),
                    child: Text(
                      'FILMFLIX',
                      style: TextStyle(
                        fontFamily: GoogleFonts.interTight().fontFamily,
                        color: const Color(0xFFFF0000),
                        fontSize: 40,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Padding(
                      padding: const EdgeInsetsDirectional.fromSTEB(0, 40, 0, 0),
                      child: Text(
                        'Sign In',
                        style: TextStyle(
                          fontFamily: GoogleFonts.interTight().fontFamily,
                          color: Colors.white,
                          fontSize: 30,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsetsDirectional.fromSTEB(0, 40, 0, 0),
                      child: InkWell(
                        splashColor: Colors.transparent,
                        focusColor: Colors.transparent,
                        hoverColor: Colors.transparent,
                        highlightColor: Colors.transparent,
                        onTap: () async {
                          Navigator.of(context).pushNamed(SignUpWidget.routeName);
                        },
                        child: Text(
                          'Sign Up',
                          style: TextStyle(
                            fontFamily: GoogleFonts.interTight().fontFamily,
                            color: const Color(0xFF787777),
                            fontSize: 30,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                Padding(
                  padding: const EdgeInsetsDirectional.fromSTEB(20, 20, 20, 0),
                  child: TextFormField(
                    controller: emailTextController,
                    focusNode: textFieldFocusNode1,
                    decoration: InputDecoration(
                      isDense: true,
                      hintText: 'email',
                      hintStyle: TextStyle(
                        fontFamily: GoogleFonts.interTight().fontFamily,
                        color: Colors.white,
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide: const BorderSide(
                          color: Colors.white,
                        ),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: const BorderSide(
                          color: Colors.white,
                        ),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      errorBorder: OutlineInputBorder(
                        borderSide: const BorderSide(
                          color: Colors.red,
                        ),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      focusedErrorBorder: OutlineInputBorder(
                        borderSide: const BorderSide(
                          color: Colors.red,
                        ),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      filled: true,
                    ),
                    style: TextStyle(
                      fontFamily: GoogleFonts.inter().fontFamily,
                      color: Colors.white,
                    ),
                    cursorColor: Colors.white,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Email cannot be empty';
                      }
                      if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) {
                        return 'Please enter a valid email';
                      }
                      return null;
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsetsDirectional.fromSTEB(20, 20, 20, 0),
                  child: TextFormField(
                    controller: passwordTextController,
                    focusNode: textFieldFocusNode2,
                    obscureText: !passwordVisibility,
                    decoration: InputDecoration(
                      isDense: true,
                      hintText: 'password',
                      hintStyle: TextStyle(
                        fontFamily: GoogleFonts.interTight().fontFamily,
                        color: Colors.white,
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide: const BorderSide(
                          color: Colors.white,
                        ),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: const BorderSide(
                          color: Colors.white,
                        ),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      errorBorder: OutlineInputBorder(
                        borderSide: const BorderSide(
                          color: Colors.red,
                        ),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      focusedErrorBorder: OutlineInputBorder(
                        borderSide: const BorderSide(
                          color: Colors.red,
                        ),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      filled: true,
                      suffixIcon: InkWell(
                        onTap: () => setState(
                              () => passwordVisibility = !passwordVisibility,
                        ),
                        focusNode: FocusNode(skipTraversal: true),
                        child: Icon(
                          passwordVisibility
                              ? Icons.visibility_outlined
                              : Icons.visibility_off_outlined,
                          color: Colors.white,
                          size: 20,
                        ),
                      ),
                    ),
                    style: TextStyle(
                      fontFamily: GoogleFonts.inter().fontFamily,
                      color: Colors.white,
                    ),
                    cursorColor: Colors.white,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Password cannot be empty';
                      }
                      if (value.length < 6) {
                        return 'Password must be at least 6 characters';
                      }
                      return null;
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsetsDirectional.fromSTEB(0, 20, 0, 0),
                  child: ElevatedButton(
                    onPressed: () => signInWithEmail(context),
                    style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.black,
                      backgroundColor: Colors.white,
                      minimumSize: const Size(100, 40),
                      padding: const EdgeInsetsDirectional.fromSTEB(16, 0, 16, 0),
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: Text(
                      'Sign In',
                      style: TextStyle(
                        fontFamily: GoogleFonts.interTight().fontFamily,
                        color: Colors.black,
                        fontWeight: FontWeight.normal,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}