import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../widgets/navigation_row.dart';
import 'home_page_screen.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({super.key});

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  final _formKey = GlobalKey<FormState>();
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  // Form controllers and focus nodes
  late TextEditingController _emailController;
  late FocusNode _emailFocusNode;

  late TextEditingController _passwordController;
  late FocusNode _passwordFocusNode;
  late bool _isPasswordVisible;

  @override
  void initState() {
    super.initState();
    _emailController = TextEditingController();
    _emailFocusNode = FocusNode();

    _passwordController = TextEditingController();
    _passwordFocusNode = FocusNode();
    _isPasswordVisible = false;
  }

  @override
  void dispose() {
    _emailController.dispose();
    _emailFocusNode.dispose();

    _passwordController.dispose();
    _passwordFocusNode.dispose();

    super.dispose();
  }

  // Method to handle sign-in with email and password
  Future<void> _signInWithEmail(BuildContext context) async {
    if (_formKey.currentState?.validate() ?? false) {
      try {
        await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: _emailController.text,
          password: _passwordController.text,
        );

        // Navigate to home page on success
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => const HomePageScreen()));
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
        key: _scaffoldKey,
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
                const NavigationRow(isFromSignIn: true),
                const SizedBox(height: 20),
                _buildEmailTextField(),
                _buildPasswordTextField(),
                _buildSignInButton(context),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Email TextField Widget
  Widget _buildEmailTextField() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: TextFormField(
        controller: _emailController,
        focusNode: _emailFocusNode,
        decoration: InputDecoration(
          fillColor: Colors.transparent,
          hintText: 'Email',
          hintStyle: GoogleFonts.interTight(color: Colors.white),
          enabledBorder: _inputBorder(),
          focusedBorder: _inputBorder(),
          errorBorder: _inputBorder(error: true),
          focusedErrorBorder: _inputBorder(error: true),
          filled: true,
        ),
        style: GoogleFonts.inter(color: Colors.white),
        cursorColor: Colors.white,
        validator: _emailValidator,
      ),
    );
  }

  // Password TextField Widget
  Widget _buildPasswordTextField() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: TextFormField(
        controller: _passwordController,
        focusNode: _passwordFocusNode,
        obscureText: !_isPasswordVisible,
        decoration: InputDecoration(
          fillColor: Colors.transparent,
          hintText: 'Password',
          hintStyle: GoogleFonts.interTight(color: Colors.white),
          enabledBorder: _inputBorder(),
          focusedBorder: _inputBorder(),
          errorBorder: _inputBorder(error: true),
          focusedErrorBorder: _inputBorder(error: true),
          filled: true,
          suffixIcon: IconButton(
            icon: Icon(
              _isPasswordVisible ? Icons.visibility : Icons.visibility_off,
              color: Colors.white,
              size: 20,
            ),
            onPressed: () {
              setState(() {
                _isPasswordVisible = !_isPasswordVisible;
              });
            },
          ),
        ),
        style: GoogleFonts.inter(color: Colors.white),
        cursorColor: Colors.white,
        validator: _passwordValidator,
      ),
    );
  }

  // Sign In Button
  Widget _buildSignInButton(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 20),
      child: ElevatedButton(
        onPressed: () => _signInWithEmail(context),
        style: ElevatedButton.styleFrom(
          foregroundColor: Colors.black, backgroundColor: Colors.white,
          minimumSize: const Size(100, 40),
          padding: const EdgeInsets.symmetric(horizontal: 16),
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
        child: Text(
          'Sign In',
          style: GoogleFonts.interTight(
            color: Colors.black,
            fontWeight: FontWeight.normal,
          ),
        ),
      ),
    );
  }

  // Common Input Border style
  OutlineInputBorder _inputBorder({bool error = false}) {
    return OutlineInputBorder(
      borderSide: BorderSide(
        color: error ? Colors.red : Colors.white,
      ),
      borderRadius: BorderRadius.circular(8),
    );
  }

  // Email Validator
  String? _emailValidator(String? value) {
    if (value == null || value.isEmpty) {
      return 'Email cannot be empty';
    }
    if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) {
      return 'Please enter a valid email';
    }
    return null;
  }

  // Password Validator
  String? _passwordValidator(String? value) {
    if (value == null || value.isEmpty) {
      return 'Password cannot be empty';
    }
    if (value.length < 6) {
      return 'Password must be at least 6 characters';
    }
    return null;
  }
}


