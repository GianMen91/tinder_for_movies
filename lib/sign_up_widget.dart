import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:tinder_for_movies/home_page_widget.dart';
import 'package:tinder_for_movies/sign_in_widget.dart';
import 'package:tinder_for_movies/sign_up_model.dart';


// Create an AuthManager to handle Firebase authentication
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

// Create a Theme class as a replacement for FlutterFlowTheme
class AppTheme {
  static const TextStyle bodyMedium = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.normal,
  );

  static const TextStyle labelMedium = TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.normal,
  );

  static const TextStyle titleSmall = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w600,
  );

  static const Color errorColor = Colors.red;
  static const Color primaryText = Colors.black;

  static AppTheme of(BuildContext context) => AppTheme();
}

// Define a ButtonOptions class to replace FlutterFlowButtonOptions
class ButtonOptions {
  final double width;
  final double height;
  final EdgeInsetsDirectional padding;
  final EdgeInsetsDirectional iconPadding;
  final Color color;
  final TextStyle textStyle;
  final double elevation;
  final BorderRadius borderRadius;

  const ButtonOptions({
    required this.width,
    required this.height,
    required this.padding,
    required this.iconPadding,
    required this.color,
    required this.textStyle,
    required this.elevation,
    required this.borderRadius,
  });
}

// Custom button widget to replace FFButtonWidget
class CustomButton extends StatelessWidget {
  final Function() onPressed;
  final String text;
  final ButtonOptions options;

  const CustomButton({
    super.key,
    required this.onPressed,
    required this.text,
    required this.options,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: options.width,
      height: options.height,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: options.color,
          elevation: options.elevation,
          padding: options.padding.resolve(Directionality.of(context)),
          shape: RoundedRectangleBorder(
            borderRadius: options.borderRadius,
          ),
        ),
        child: Text(
          text,
          style: options.textStyle,
        ),
      ),
    );
  }
}

// Record class to replace UsersRecord
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

// Helper function to safely set state
void safeSetState(Function setState) {

    setState();

}

class SignUpWidget extends StatefulWidget {
  const SignUpWidget({super.key});

  static const String routeName = 'SignUp';
  static const String routePath = '/signUp';

  @override
  State<SignUpWidget> createState() => _SignUpWidgetState();
}

class _SignUpWidgetState extends State<SignUpWidget> {
  late SignUpModel _model;
  final scaffoldKey = GlobalKey<ScaffoldState>();
  final authManager = AuthManager();
  @override
  bool mounted = true;

  @override
  void initState() {
    super.initState();
    _model = SignUpModel();
    _model.initState(context);

    _model.emailTextController ??= TextEditingController();
    _model.textFieldFocusNode1 ??= FocusNode();

    _model.passwordTextController ??= TextEditingController();
    _model.textFieldFocusNode2 ??= FocusNode();

    _model.confirmPasswordTextController ??= TextEditingController();
    _model.textFieldFocusNode3 ??= FocusNode();

    _model.textController2 ??= TextEditingController();
    _model.textFieldFocusNode4 ??= FocusNode();
  }

  @override
  void dispose() {
    mounted = false;
    _model.dispose();
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
          actions: const [],
          centerTitle: false,
          elevation: 0,
        ),
        body: SafeArea(
          child: Column(
            children: [
              Align(
                alignment: const AlignmentDirectional(0, 0),
                child: Padding(
                  padding: const EdgeInsetsDirectional.fromSTEB(0, 100, 0, 0),
                  child: Text(
                    'FILMFLIX',
                    style: GoogleFonts.interTight(
                      fontWeight: FontWeight.bold,
                      color: const Color(0xFFFF0000),
                      fontSize: 40,
                      letterSpacing: 0.0,
                    ),
                  ),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Padding(
                    padding: const EdgeInsetsDirectional.fromSTEB(0, 40, 0, 0),
                    child: GestureDetector(

                      onTap: () async {
                            () => Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(builder: (context) => const SignInWidget()));

                      },
                      child: Text(
                        'Sign In',
                        style: GoogleFonts.interTight(
                          color: const Color(0xFF787777),
                          fontSize: 30,
                          letterSpacing: 0.0,
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsetsDirectional.fromSTEB(0, 40, 0, 0),
                    child: Text(
                      'Sign Up',
                      style: GoogleFonts.interTight(
                        color: Colors.white,
                        fontSize: 30,
                        letterSpacing: 0.0,
                      ),
                    ),
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsetsDirectional.fromSTEB(20, 20, 20, 0),
                child: SizedBox(
                  width: double.infinity,
                  child: TextFormField(
                    controller: _model.emailTextController,
                    focusNode: _model.textFieldFocusNode1,
                    decoration: InputDecoration(
                      isDense: true,
                      labelStyle: GoogleFonts.inter(
                        letterSpacing: 0.0,
                      ),
                      hintText: 'email',
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
                padding: const EdgeInsetsDirectional.fromSTEB(20, 20, 20, 0),
                child: SizedBox(
                  width: double.infinity,
                  child: TextFormField(
                    controller: _model.passwordTextController,
                    focusNode: _model.textFieldFocusNode2,
                    obscureText: !_model.passwordVisibility1,
                    decoration: InputDecoration(
                      isDense: true,
                      labelStyle: GoogleFonts.inter(
                        letterSpacing: 0.0,
                      ),
                      hintText: 'password',
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
                      suffixIcon: InkWell(
                        onTap: () => setState(
                              () => _model.passwordVisibility1 =
                          !_model.passwordVisibility1,
                        ),
                        focusNode: FocusNode(skipTraversal: true),
                        child: Icon(
                          _model.passwordVisibility1
                              ? Icons.visibility_outlined
                              : Icons.visibility_off_outlined,
                          color: Colors.white,
                          size: 20,
                        ),
                      ),
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
                padding: const EdgeInsetsDirectional.fromSTEB(20, 20, 20, 0),
                child: SizedBox(
                  width: double.infinity,
                  child: TextFormField(
                    controller: _model.confirmPasswordTextController,
                    focusNode: _model.textFieldFocusNode3,
                    obscureText: !_model.passwordVisibility2,
                    decoration: InputDecoration(
                      isDense: true,
                      labelStyle: GoogleFonts.inter(
                        letterSpacing: 0.0,
                      ),
                      hintText: 'confirm password',
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
                      suffixIcon: InkWell(
                        onTap: () => setState(
                              () => _model.passwordVisibility2 =
                          !_model.passwordVisibility2,
                        ),
                        focusNode: FocusNode(skipTraversal: true),
                        child: Icon(
                          _model.passwordVisibility2
                              ? Icons.visibility_outlined
                              : Icons.visibility_off_outlined,
                          color: Colors.white,
                          size: 20,
                        ),
                      ),
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
                padding: const EdgeInsetsDirectional.fromSTEB(20, 20, 20, 0),
                child: SizedBox(
                  width: double.infinity,
                  child: TextFormField(
                    controller: _model.textController2,
                    focusNode: _model.textFieldFocusNode4,
                    decoration: InputDecoration(
                      isDense: true,
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
                child: CustomButton(
                  onPressed: () async {
                    if (_model.passwordTextController!.text !=
                        _model.confirmPasswordTextController!.text) {
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
                      _model.emailTextController!.text,
                      _model.passwordTextController!.text,
                    );
                    if (user == null) {
                      return;
                    }

                    await UsersRecord.collection
                        .doc(user.uid)
                        .set(UsersRecord.createUsersRecordData(
                      displayName: _model.textController2!.text,
                    ));

                    Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (context) => const HomePageWidget()));
                  },
                  text: 'Sign Up',
                  options: ButtonOptions(
                    width: 100,
                    height: 40,
                    padding: const EdgeInsetsDirectional.fromSTEB(16, 0, 16, 0),
                    iconPadding: const EdgeInsetsDirectional.fromSTEB(0, 0, 0, 0),
                    color: Colors.white,
                    textStyle: GoogleFonts.interTight(
                      color: Colors.black,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      letterSpacing: 0.0,
                    ),
                    elevation: 0,
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}