import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tinder_for_movies/sign_in_widget.dart';

import 'home_page_widget.dart';

class AuthManager {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  Future<User?> createAccountWithEmail(
    BuildContext context,
    String email,
    String password,
  ) async {
    try {
      final userCredential = await _firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      return userCredential.user;
    } on FirebaseAuthException catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error: ${e.message}'),
        ),
      );
      return null;
    }
  }
}

class UsersRecord {
  static final CollectionReference collection =
  FirebaseFirestore.instance.collection('users');

  static Map<String, dynamic> createUsersRecordData({
    String? displayName,
  }) {
    return {
      'displayName': displayName,
      'createdTime': FieldValue.serverTimestamp(),
    };
  }
}

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final _formKey = GlobalKey<FormState>();
  final scaffoldKey = GlobalKey<ScaffoldState>();

  // Form controllers
  late TextEditingController emailTextController;
  late FocusNode textFieldFocusNode1;

  late TextEditingController passwordTextController;
  late FocusNode textFieldFocusNode2;
  late bool passwordVisibility;

  TextEditingController? confirmPasswordTextController;
  late FocusNode textFieldFocusNode3;
  late bool confirmPasswordVisibility;

  late TextEditingController displayNameTextController;
  late FocusNode textFieldFocusNode4;

  final authManager = AuthManager();

  @override
  void initState() {
    super.initState();
    emailTextController = TextEditingController();
    textFieldFocusNode1 = FocusNode();

    passwordTextController = TextEditingController();
    textFieldFocusNode2 = FocusNode();
    passwordVisibility = false;

    confirmPasswordTextController = TextEditingController();
    textFieldFocusNode3 = FocusNode();
    confirmPasswordVisibility = false;

    displayNameTextController = TextEditingController();
    textFieldFocusNode4 = FocusNode();
  }

  @override
  void dispose() {
    emailTextController.dispose();
    textFieldFocusNode1.dispose();

    passwordTextController.dispose();
    textFieldFocusNode2.dispose();

    confirmPasswordTextController?.dispose();
    textFieldFocusNode3.dispose();

    displayNameTextController.dispose();
    textFieldFocusNode4.dispose();

    super.dispose();
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
                      padding:
                          const EdgeInsetsDirectional.fromSTEB(0, 40, 0, 0),
                      child: InkWell(
                        splashColor: Colors.transparent,
                        focusColor: Colors.transparent,
                        hoverColor: Colors.transparent,
                        highlightColor: Colors.transparent,
                        onTap: () async {
                          Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const SignInWidget()));
                        },
                        child: Text(
                          'Sign In',
                          style: TextStyle(
                            fontFamily: GoogleFonts.interTight().fontFamily,
                            color: const Color(0xFF787777),
                            fontSize: 30,
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding:
                          const EdgeInsetsDirectional.fromSTEB(0, 40, 0, 0),
                      child: Text(
                        'Sign Up',
                        style: TextStyle(
                          fontFamily: GoogleFonts.interTight().fontFamily,
                          color: Colors.white,
                          fontSize: 30,
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
                      fillColor: Colors.transparent,
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
                      if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$')
                          .hasMatch(value)) {
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
                      fillColor: Colors.transparent,
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
                  padding: const EdgeInsetsDirectional.fromSTEB(20, 20, 20, 0),
                  child: TextFormField(
                    controller: confirmPasswordTextController,
                    focusNode: textFieldFocusNode3,
                    obscureText: !confirmPasswordVisibility,
                    decoration: InputDecoration(
                      fillColor: Colors.transparent,
                      isDense: true,
                      hintText: 'confirm password',
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
                              () => confirmPasswordVisibility = !confirmPasswordVisibility,
                        ),
                        focusNode: FocusNode(skipTraversal: true),
                        child: Icon(
                          confirmPasswordVisibility
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
                  padding: const EdgeInsetsDirectional.fromSTEB(20, 20, 20, 0),
                  child: SizedBox(
                    width: double.infinity,
                    child: TextFormField(
                      controller: displayNameTextController,
                      focusNode: textFieldFocusNode4,
                      decoration: InputDecoration(
                        isDense: true,
                        fillColor: Colors.transparent,
                        labelStyle: GoogleFonts.inter(
                          letterSpacing: 0.0,
                        ),
                        hintText: 'display name',
                        hintStyle: GoogleFonts.interTight(
                          color: Colors.white,
                          letterSpacing: 0.0,
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
                      style: GoogleFonts.inter(
                        color: Colors.white,
                        letterSpacing: 0.0,
                      ),
                      cursorColor: Colors.white,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsetsDirectional.fromSTEB(0, 20, 0, 0),
                  child: ElevatedButton(
                    onPressed: () async {
                      if (passwordTextController.text !=
                          confirmPasswordTextController!.text) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text(
                              'Passwords don\'t match!',
                            ),
                          ),
                        );
                        return;
                      }

                      final user = await authManager.createAccountWithEmail(
                        context,
                        emailTextController.text,
                        passwordTextController.text,
                      );
                      if (user == null) {
                        return;
                      }

                      await UsersRecord.collection
                          .doc(user.uid)
                          .set(UsersRecord.createUsersRecordData(
                            displayName: displayNameTextController.text,
                          ));

                      Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const HomePageWidget()));
                    },
                    style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.black,
                      backgroundColor: Colors.white,
                      minimumSize: const Size(100, 40),
                      padding:
                          const EdgeInsetsDirectional.fromSTEB(16, 0, 16, 0),
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: Text(
                      'Sign Up',
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
