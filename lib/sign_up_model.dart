import 'package:flutter/material.dart';
import 'sign_up_widget.dart';

// FlutterFlowModel replacement
abstract class FlutterFlowModel<T extends StatefulWidget> {
  void initState(BuildContext context) {}

  void dispose() {}
}

class SignUpModel extends FlutterFlowModel<SignUpWidget> {
  ///  State fields for stateful widgets in this page.
  // State field(s) for TextField widget.
  FocusNode? textFieldFocusNode1;
  TextEditingController? emailTextController;
  String? Function(BuildContext, String?)? emailTextControllerValidator;

  // State field(s) for TextField widget.
  FocusNode? textFieldFocusNode2;
  TextEditingController? passwordTextController;
  late bool passwordVisibility1;
  String? Function(BuildContext, String?)? passwordTextControllerValidator;

  // State field(s) for TextField widget.
  FocusNode? textFieldFocusNode3;
  TextEditingController? confirmPasswordTextController;
  late bool passwordVisibility2;
  String? Function(BuildContext, String?)?
      confirmPasswordTextControllerValidator;

  // State field(s) for TextField widget.
  FocusNode? textFieldFocusNode4;
  TextEditingController? textController2;
  String? Function(BuildContext, String?)? textController2Validator;

  @override
  void initState(BuildContext context) {
    passwordVisibility1 = false;
    passwordVisibility2 = false;

    // Add validators for form fields
    emailTextControllerValidator = _validateEmail;
    passwordTextControllerValidator = _validatePassword;
    confirmPasswordTextControllerValidator = _validateConfirmPassword;
    textController2Validator = _validateDisplayName;
  }

  @override
  void dispose() {
    textFieldFocusNode1?.dispose();
    emailTextController?.dispose();

    textFieldFocusNode2?.dispose();
    passwordTextController?.dispose();

    textFieldFocusNode3?.dispose();
    confirmPasswordTextController?.dispose();

    textFieldFocusNode4?.dispose();
    textController2?.dispose();
  }

  // Email validator
  String? _validateEmail(BuildContext context, String? value) {
    if (value == null || value.isEmpty) {
      return 'Email is required';
    }

    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    if (!emailRegex.hasMatch(value)) {
      return 'Please enter a valid email address';
    }

    return null;
  }

  // Password validator
  String? _validatePassword(BuildContext context, String? value) {
    if (value == null || value.isEmpty) {
      return 'Password is required';
    }

    if (value.length < 6) {
      return 'Password must be at least 6 characters';
    }

    return null;
  }

  // Confirm password validator
  String? _validateConfirmPassword(BuildContext context, String? value) {
    if (value == null || value.isEmpty) {
      return 'Please confirm your password';
    }

    if (passwordTextController != null &&
        value != passwordTextController!.text) {
      return 'Passwords do not match';
    }

    return null;
  }

  // Display name validator
  String? _validateDisplayName(BuildContext context, String? value) {
    if (value == null || value.isEmpty) {
      return 'Display name is required';
    }

    return null;
  }
}
