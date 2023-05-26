import 'package:flutter/material.dart';
import 'package:string_validator/string_validator.dart';

class Validator {
  static bool isEmailValid({required String? email}) {
    if (email != null) {
      return isEmail(email);
    }
    return false;
  }

  static bool isValidPassport({required String passPortValue}) {
    const pattern = r'^(?!^0+$)[a-zA-Z0-9]{3,20}';
    final regExp = RegExp(pattern);

    return regExp.hasMatch(passPortValue);
  }

  static bool isInteger(dynamic value) {
    try {
      int.parse(value);

      return true;
    } catch (e) {
      return false;
    }
  }

  static bool isDouble(dynamic value) {
    try {
      double.parse(value);

      return true;
    } catch (e) {
      return false;
    }
  }

  static bool isNumber(dynamic value) {
    try {
      num.parse(value);

      return true;
    } catch (e) {
      return false;
    }
  }

  static bool isUrlValid({required String? url}) {
    if (url == null) {
      return false;
    }

    return isURL(url);
  }

  static String? removeMultipleWhiteSpace(String value) {
    final whitespaceRE = RegExp(r"\s+");
    String cleanupWhitespace(String input) =>
        input.replaceAll(whitespaceRE, " ");

    return cleanupWhitespace(value);
  }

  static bool isValidPhoneNumberFormat({required String? phoneNumber}) {
    const pattern = r'^[+]*[(]{0,1}[0-9]{1,4}[)]{0,1}[-\s\./0-9]*$';
    final regExp = RegExp(pattern);

    if (phoneNumber == null || phoneNumber.isEmpty || phoneNumber.length < 10) {
      return false;
    }

    if (!regExp.hasMatch(phoneNumber)) {
      return false;
    }
    return true;
  }

  static bool isHttpSuccessOrClientError(int statusCode) {
    // Check if the status code is within the HTTP success range.
    return statusCode >= 200 && statusCode < 300 ||
        statusCode >= 400 && statusCode < 500;
  }
}
