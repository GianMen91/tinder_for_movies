import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tinder_for_movies/screens/sign_in_screen.dart';

import '../models/user_record.dart';
import '../repository/auth_manager.dart';
import 'home_page_screen.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final _formKey = GlobalKey<FormState>();
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  // Form controllers and focus nodes
  late TextEditingController _emailController;
  late FocusNode _emailFocusNode;

  late TextEditingController _passwordController;
  late FocusNode _passwordFocusNode;
  late bool _isPasswordVisible;

  late TextEditingController _confirmPasswordController;
  late FocusNode _confirmPasswordFocusNode;
  late bool _isConfirmPasswordVisible;

  late TextEditingController _displayNameController;
  late FocusNode _displayNameFocusNode;

  final _authManager = AuthManager();

  @override
  void initState() {
    super.initState();
    _emailController = TextEditingController();
    _emailFocusNode = FocusNode();

    _passwordController = TextEditingController();
    _passwordFocusNode = FocusNode();
    _isPasswordVisible = false;

    _confirmPasswordController = TextEditingController();
    _confirmPasswordFocusNode = FocusNode();
    _isConfirmPasswordVisible = false;

    _displayNameController = TextEditingController();
    _displayNameFocusNode = FocusNode();
  }

  @override
  void dispose() {
    _emailController.dispose();
    _emailFocusNode.dispose();

    _passwordController.dispose();
    _passwordFocusNode.dispose();

    _confirmPasswordController.dispose();
    _confirmPasswordFocusNode.dispose();

    _displayNameController.dispose();
    _displayNameFocusNode.dispose();

    super.dispose();
  }

  Future<void> _signUp() async {
    if (_passwordController.text != _confirmPasswordController.text) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Passwords don\'t match!')),
      );
      return;
    }

    final user = await _authManager.createAccountWithEmail(
      context,
      _emailController.text,
      _passwordController.text,
    );
    if (user == null) return;

    await UserRecord.collection
        .doc(user.uid)
        .set(UserRecord.createUsersRecordData(displayName: _displayNameController.text));

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const HomePageScreen()),
    );
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
                _buildLogo(),
                const SizedBox(height: 20),
                _buildNavigationRow(context),
                const SizedBox(height: 20),
                _buildTextField(
                  controller: _emailController,
                  focusNode: _emailFocusNode,
                  hintText: 'email',
                  obscureText: false,
                  validator: _emailValidator,
                ),
                _buildTextField(
                  controller: _passwordController,
                  focusNode: _passwordFocusNode,
                  hintText: 'password',
                  obscureText: !_isPasswordVisible,
                  validator: _passwordValidator,
                  isPasswordField: true,
                ),
                _buildTextField(
                  controller: _confirmPasswordController,
                  focusNode: _confirmPasswordFocusNode,
                  hintText: 'confirm password',
                  obscureText: !_isConfirmPasswordVisible,
                  validator: _confirmPasswordValidator,
                  isPasswordField: true,
                ),
                _buildTextField(
                  controller: _displayNameController,
                  focusNode: _displayNameFocusNode,
                  hintText: 'display name',
                  obscureText: false,
                ),
                _buildSignUpButton(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Widgets for the UI components
  Widget _buildLogo() {
    return Padding(
      padding: const EdgeInsets.only(top: 100),
      child: Text(
      'FILMFLIX',
      style: TextStyle(
        fontFamily: GoogleFonts.interTight().fontFamily,
        color: const Color(0xFFFF0000),
        fontSize: 40,
        fontWeight: FontWeight.bold,
      ),
    ));
  }

  Widget _buildNavigationRow(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        _buildNavButton(
          text: 'Sign In',
          onTap: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const SignInScreen()),
            );
          },
        ),
        Text(
          'Sign Up',
          style: GoogleFonts.interTight(
            color: Colors.white,
            fontSize: 30,
          ),
        ),
      ],
    );
  }

  Widget _buildNavButton({required String text, required VoidCallback onTap}) {
    return InkWell(
      onTap: onTap,
      child: Text(
        text,
        style: GoogleFonts.interTight(
          color: const Color(0xFF787777),
          fontSize: 30,
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required FocusNode focusNode,
    required String hintText,
    required bool obscureText,
    String? Function(String?)? validator,
    bool isPasswordField = false,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: TextFormField(
        controller: controller,
        focusNode: focusNode,

        obscureText: obscureText,
        decoration: InputDecoration(
          hintText: hintText,
          fillColor: Colors.transparent,
          hintStyle: GoogleFonts.interTight(color: Colors.white),
          enabledBorder: _inputBorder(),
          focusedBorder: _inputBorder(),
          errorBorder: _inputBorder(error: true),
          focusedErrorBorder: _inputBorder(error: true),
          filled: true,
          suffixIcon: isPasswordField
              ? IconButton(
            icon: Icon(
              obscureText ? Icons.visibility_off : Icons.visibility,
              color: Colors.white,
              size: 20,
            ),
            onPressed: () {
              setState(() {
                if (hintText == 'password') {
                  _isPasswordVisible = !_isPasswordVisible;
                } else {
                  _isConfirmPasswordVisible = !_isConfirmPasswordVisible;
                }
              });
            },
          )
              : null,
        ),
        style: GoogleFonts.inter(color: Colors.white),
        cursorColor: Colors.white,
        validator: validator,
      ),
    );
  }

  Widget _buildSignUpButton() {
    return Padding(
      padding: const EdgeInsets.only(top: 20),
      child: ElevatedButton(
        onPressed: _signUp,
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
          'Sign Up',
          style: GoogleFonts.interTight(color: Colors.black),
        ),
      ),
    );
  }

  // Common input border style
  OutlineInputBorder _inputBorder({bool error = false}) {
    return OutlineInputBorder(
      borderSide: BorderSide(
        color: error ? Colors.red : Colors.white,
      ),
      borderRadius: BorderRadius.circular(8),
    );
  }

  // Validators
  String? _emailValidator(String? value) {
    if (value == null || value.isEmpty) {
      return 'Email cannot be empty';
    }
    if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) {
      return 'Please enter a valid email';
    }
    return null;
  }

  String? _passwordValidator(String? value) {
    if (value == null || value.isEmpty) {
      return 'Password cannot be empty';
    }
    if (value.length < 6) {
      return 'Password must be at least 6 characters';
    }
    return null;
  }

  String? _confirmPasswordValidator(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please confirm your password';
    }
    if (value != _passwordController.text) {
      return 'Passwords do not match';
    }
    return null;
  }
}
